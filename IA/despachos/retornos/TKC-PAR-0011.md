# TKC-PAR-0011 — Parecer técnico Backend

**Projeto:** TeamKitCollection
**Autor original / publicador:** AGT-004 — Backend (ChatGPT)
**Destinatário:** AGT-001
**Ordem:** TKC-REQ-0011
**Tarefa:** TKC-0011
**Data declarada:** 2026-11-27 (RELATADO, horário local)
**Estado:** PRONTO PARA REVISÃO — VIAVEL_COM_CONDICOES
**Nível:** análise L0/L1; publicação documental L2 especificamente autorizada
**Base técnica:** 89ca4115ea5cf9187dce0dde39a92948a63cc168
**Claim documental:** TKC-0011-C02, confirmado no remoto em caabd536b9ebb04759893ccc7f7b68f2a359f86c
**Proveniência:** inspeção direta Git VERIFICADO; autorização humana MEDIADO.
**rules_checked_commit:** 89ca4115ea5cf9187dce0dde39a92948a63cc168
**rules_scope:** AGENTS.md, IA/regras/comunicacao.md (COM-001), IA/despachos/README.md (COM-002); consultados IA/PROJETO.md e índice.
**rules_check_status:** ATUALIZADO na base consultada; claim C02 modificou somente tarefa e índice.

## 1. Decisão e limites

A arquitetura atual é coerente com o primeiro corte executável. Não há incompatibilidade fundamental identificada por inspeção que justifique substituir FastAPI, PostgreSQL ou Psycopg. Recomenda-se endurecimento técnico e validação controlada antes de homologação. Nenhuma falha operacional foi reproduzida nesta sessão. Nenhum teste, instalação, Docker, VM, rede ou PostgreSQL foi executado. Nenhum custo adicional gerado. A análise não concede autorização para patch, operação ou conclusão de M3-02.

## 2. Fontes verificadas

Todos os caminhos técnicos abaixo foram lidos diretamente no Git na revisão-base acima:
- src/backend/main.py, db.py, config.py, requirements.txt
- tests/unit/test_health_unit.py; tests/integration/test_health_compose.py
- infra/docker/Dockerfile.backend; infra/docker/docker-compose.lab.yml
- docs/contratos-api.md; docs/infraestrutura.md (seções pertinentes)
- IA/tarefas/TKC-0005.md, TKC-0010.md, TKC-0011.md, TKC-0012.md, TKC-0013.md
- IA/despachos/ordens/TKC-REQ-0011.md; IA/despachos/retornos/TKC-PAR-0012.md e TKC-PAR-0013.md (seções pertinentes).
Referência permanente: https://github.com/edinhogrubert/TeamKitCollection/tree/89ca4115ea5cf9187dce0dde39a92948a63cc168

## 3. Arquitetura e contrato HTTP — VERIFICADO POR INSPEÇÃO

Python 3.12, FastAPI, Uvicorn, Psycopg 3, PostgreSQL 16 previsto, Pytest/HTTPX/unittest.mock. O cliente local acessa 127.0.0.1:8000, backend em container liga-se ao banco existente tkc-postgres16:5432 pela rede externa tkc-lab-net. Compose declara somente backend, limite 512m e 1 CPU, sem criar banco ou volume ou publicar 5432. Uvicorn escuta 0.0.0.0 dentro do container; publicação do host restrita ao loopback no Compose. Não é prova de isolamento operacional.

GET /health chama check_database(), que abre conexão nova, executa SELECT 1 e exige resultado (1,). Sucesso: HTTP 200 {"status":"ok","database":"up"}. Exceção de configuração, conexão ou consulta: HTTP 503 {"status":"unhealthy","database":"down","error":"DB_UNAVAILABLE"}. Código está coerente com docs/contratos-api.md. Sem autenticação neste corte local. A resposta 200 prova somente conectividade/consulta naquele instante, não saúde integral do sistema. Configuração é lida a cada chamada; senha obrigatória, porta convertida para inteiro. Context managers encerram conexão/cursor. Não existe cache do estado de falha ou conexão permanente. Espera-se recuperação na próxima consulta bem-sucedida, sem restart. Teste com mocks representa sequência 200/503/200; recuperação real NÃO EXECUTADA.

## 4. Achados estáticos comprovados

| ID | Prioridade | Evidência | Recomendação |
|---|---|---|---|
| BE-001 | Alta | requirements.txt usa faixas fastapi>=0.115,<1; uvicorn>=0.30,<1; psycopg[binary]>=3.2,<4; httpx>=0.27,<1; pytest>=8,<10; instalação sem lock/hash | Resolver versões compatíveis e transitivas, gerar lock com hashes; não escolher versões arbitrárias |
| BE-002 | Alta | Dockerfile.backend FROM python:3.12-slim sem digest | Fixar digest após verificar arquitetura, compatibilidade e segurança; política de atualização |
| BE-003 | Alta | test_health_compose.py contém somente teste HTTP 200 | Complementar evidência de integração 503 e recuperação; manipulação de rede exclusivamente DevOps/operador autorizado |
| BE-004 | Média | main.py captura Exception genericamente, sem diagnóstico interno explícito | Preservar 503 público; diagnóstico sanitizado por classe de falha, sem DSN, senha, SQL ou mensagens sensíveis |
| BE-005 | Média | Dockerfile instala requirements.txt integral, incluindo pytest e httpx não usados no runtime atual | Separar dependências de runtime e testes |
| BE-006 | Baixa | Decorador GET /health não declara resposta 503 explicitamente no OpenAPI | Documentar 503 e schema sem mudar contrato |
| BE-007 | Média | Os três testes unitários analisados substituem integralmente check_database | Testes diretos de config.py e db.py, parâmetros, SELECT 1, resultado inesperado, encerramento de recursos |

BE-001/002 são limitações de reprodutibilidade, não prova de build quebrado; BE-003 não implica incapacidade dos scripts operacionais. BE-004 protege resposta externa, mas torna falhas de credencial, configuração, rede, timeout e programação indistinguíveis. BE-007 refere-se aos arquivos analisados, não afirma inventário exaustivo de testes.

## 5. Riscos e timeouts

| ID | Risco | Classificação |
|---|---|---|
| RBE-001 | Tempo HTTP pode exceder orçamento do cliente | INFERIDO |
| RBE-002 | Chamadas simultâneas ao health podem saturar threads/conexões | INFERIDO |
| RBE-003 | Resolução futura de dependências pode quebrar build/runtime | INFERIDO |
| RBE-004 | Vulnerabilidades na imagem/dependências | NÃO VERIFICADO |
| RBE-005 | Confusão entre liveness e readiness, reinícios desnecessários | INFERIDO |
| RBE-006 | Revisão implantada diferente da analisada | NÃO VERIFICADO |

db.py usa connect_timeout=3 e options="-c statement_timeout=3000"; teste de integração usa httpx.get(url, timeout=6). São controles distintos: não existe garantia de deadline global de 6 segundos, e o timeout do HTTPX não representa necessariamente prazo total absoluto. DNS, espera por thread, rede, encerramento da transação e outras fases podem afetar latência. Medir conexão, consulta e HTTP separadamente; definir orçamento temporal com margem e critérios de aceite, sem alegar falha reproduzida. Harmonizar TST-04 de QA: timeout de conexão/SQL não implica que toda requisição termine em 3 s.

## 6. Segurança

VERIFICADO por inspeção: USER 10001:10001, no-new-privileges, configuração por ambiente, senha obrigatória, resposta estática sem detalhes internos, loopback no Compose, limites de CPU/memória. Ausentes no arquivo de instalação: digest e lock. Auditoria CVE/licenças e isolamento real NÃO EXECUTADOS. Credenciais por ambiente não equivalem a segredo inacessível a administradores do Docker; não imprimir compose config com segredos. Não expor API à internet neste corte. Não reescrever Dockerfile integralmente. Não ligar reinicialização automática exclusivamente à indisponibilidade do banco (Docker healthcheck isolado não reinicia container por si só). Em evolução futura distinguir liveness do processo e readiness das dependências; /health atual verifica aplicação e banco. Evitar reinício do backend como mecanismo de recuperação de falha transitória do banco.

## 7. Testes atuais e propostos

VERIFICADO por inspeção: test_health_ok verifica 200, JSON e chamada única; test_health_unavailable_does_not_leak_secret verifica 503, JSON e ausência do segredo simulado; test_health_recovery_without_restart verifica 200/503/200 com side_effect. Nenhum deles executado nesta sessão. Integração test_live_health_returns_200 exige TKC_RUN_INTEGRATION=1, restringe URL a http://127.0.0.1:8000/health e usa timeout 6. Não manipula Docker; somente caso positivo.

| ID | Cenário | Oráculo |
|---|---|---|
| BE-T01 | Configuração válida | Configuração carregada corretamente |
| BE-T02 | Senha ausente | Falha controlada e 503 |
| BE-T03 | Porta inválida | 503 sanitizado |
| BE-T04 | Falha de autenticação | 503 sem segredo |
| BE-T05 | Timeout conexão | Falha controlada |
| BE-T06 | Timeout SQL | Falha controlada |
| BE-T07 | Retorno SQL inesperado | 503 |
| BE-T08 | Conexão/cursor | Recursos encerrados corretamente |
| BE-T09 | Perda real de conectividade | 503 |
| BE-T10 | Restabelecimento real | 200 sem restart |
| BE-T11 | Requisições simultâneas | Consumo dentro de limites definidos previamente |
| BE-T12 | Reconstrução da imagem | Mesmas versões e digest de origem |

Todos PROPOSTOS, NÃO EXECUTADOS. BE-T09/T10 devem complementar TST-02/03 de TKC-PAR-0012, não criar orquestração concorrente. Para prova sem restart registrar identidade/tempo de início do processo/container antes/depois. Testes unitários com mocks não substituem testes reais.

## 8. Correção mínima proposta — não autorizada

1. Reprodutibilidade: requirements.txt, novo requirements-dev.txt (proposto), Dockerfile.backend; resolver lock/hash, separar testes, revisar CVEs/licenças e digest. Backend + DevOps.
2. Qualidade: main.py (diagnóstico sanitizado e OpenAPI 503), db.py e config.py somente se testes demonstrarem necessidade; tests/unit/test_health_unit.py, novos tests/unit/test_db_unit.py e test_config_unit.py, tests/integration/test_health_compose.py. Backend + QA. Preservar payloads existentes.
3. Validação operacional: build, conectividade, falha, recuperação, isolamento e preservação do banco, sob autorização distinta. DevOps + QA + HUMAN-001. Não criar segundo PostgreSQL nem remover volumes.

Não inventar versões, digest, latência ou resultados. A lista de paths acima é proposta, não autorização L2; eventual arquivo de lock precisa de caminho explícito em AUT. Revisar a revisão efetivamente usada por scripts antes da execução; TKC-0005 C07 relata uso de revisão fixa 959745e5513e313e477ef9cdd734111af2b9768f, não comprova imagem vigente. Verificar versão real a ser homologada.

## 9. Coordenação

AGT-001 consolida pareceres e autorizações; AGT-002 integra QA/segurança e revisa evidências; AGT-003 controla Dockerfile/Compose/scripts e operação; AGT-004 API/config/driver/testes unitários. TKC-0010: AUT em PENDENTE para correção do menu Bash; coordenar antes de operações mutáveis. TKC-PAR-0012 v2 aprovado com ressalvas documentalmente, sem homologação VM; TKC-PAR-0013 entregue, revisão independente pendente. Dockerfile, requirements e testes de integração são fronteiras compartilhadas: não autorizar edições simultâneas por agentes distintos; definir responsável e claim específico. Nenhum agente acionado automaticamente.

## 10. Critérios de homologação futura

- Imagem base identificada por digest; dependências reproduzíveis; revisão de vulnerabilidades/licenças.
- Testes unitários executados e aprovados.
- HTTP 200 com PostgreSQL real; 503 durante falha controlada; retorno a 200 sem restart.
- Latência/timeouts registrados; resposta e logs sem segredos; portas e rede verificadas.
- Banco e volumes existentes preservados; revisão independente; custo adicional R$ 0,00.

Nenhum critério operacional foi homologado nesta sessão. Persistência relatada anteriormente por HUMAN-001 é MEDIADO e não prova aceite do backend.

## 11. Governança e encerramento

A análise original ficou pronta sem escrita por ausência de autorização específica. HUMAN-001 confirmou literalmente "deve escrevver no git sim" em resposta à proposta de autorização restrita aos três caminhos de comunicação. Interpretação registrada como MEDIADO, sem ampliar escopo. Permissão técnica push informada pelo GitHub; claim C02 publicado e confirmado antes deste artefato. C01 preservado como ENTREGUE. Estado macro M3-02 PENDENTE. Nenhum produto, teste, script, norma ou infraestrutura alterado. 7 achados estáticos, 6 riscos, 12 testes propostos, 0 testes executados, 0 operações de infraestrutura, R$ 0,00 adicional. Não há falha operacional reproduzida. Entrega documental não equivale a aceite técnico. Próximo passo: AGT-001 revisar diretamente este parecer e consolidar B02 com QA/DevOps; eventual AUT própria, sem execução automática.

Commit de publicação: identificável pelo histórico Git deste arquivo (não se insere hash autorreferente).
