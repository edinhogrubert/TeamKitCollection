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


---

# Complemento C03 — Priorização e intervenção mínima antes da Fase B

**Autor:** AGT-004 — Backend
**Destinatário:** AGT-001
**Tarefa:** TKC-0011
**Decisão recebida:** parecer VIAVEL_COM_CONDICOES aceito com ressalvas por AGT-001, conforme mensagem transportada por HUMAN-001 (MEDIADO; não constitui aceite operacional).
**Parecer original:** d724e1733cb26253fcd55fee391d0cc146ff3334, preservado integralmente acima.
**Base C03:** 9dd81a8755a723f5e0d0473114b5dd61ab77272e
**rules_checked_commit:** aab1f29085a058bf2755392eb08885f4d0752cb2
**rules_scope:** AGENTS.md; COM-001; COM-002; índice e tarefa. Revisão normativa posterior ao parecer original conferida por comparação Git; mudanças prospectivas não concedem autorização retroativa.
**Claim documental C03:** 8babbba1abe8208ecb633e228290223f54a8ffdb, confirmado na main antes da publicação.
**Autorização:** HUMAN-001, explícita nesta sessão, MEDIADO, limitada a três arquivos de comunicação. Análise L0/L1, sem execução de produto. Todos os testes abaixo são PROPOSTOS/NÃO EXECUTADOS.

## 1. Decisão técnica complementar

Preservar a implementação de GET /health e a arquitetura atual. Não introduzir pool, ORM, migração, serviço adicional, endpoints de liveness/readiness ou refatoração nesta fatia. Diferenciar uma execução diagnóstica descartável, expressamente autorizada, da validação formal da Fase B: a segunda deve usar artefato identificável/reproduzível e evidência real. Não elevar riscos não reproduzidos a bugs de execução.

O diff entre o parecer original e a base C03 mostra mudanças normativas/modelos e registros de tarefa/índice, sem alteração dos caminhos técnicos analisados. Assim, a inspeção original continua aplicável a essa revisão; nenhuma nova execução foi realizada.

## 2. Duas categorias dos sete achados

| Achado | Categoria | Motivo e medida mínima |
|---|---|---|
| BE-001 — faixas de dependências | Indispensável antes da validação formal | Resolver versões diretas e transitivas em ambiente autorizado, fixar lock/hash e registrar plataforma; revisar incompatibilidades, CVEs/licenças. Sem números escolhidos por suposição. |
| BE-002 — tag Python mutável | Indispensável antes da validação formal | Fixar digest de base compatível com plataforma do laboratório; registrar digest da imagem construída e versão efetivamente testada. |
| BE-003 — integração apenas 200 | Indispensável como evidência, não necessariamente patch | Exigir ciclo real 200/503/200 e sanitização, usando orquestrador já existente e matriz QA se suficientes. Não duplicar controle de Docker em pytest. |
| BE-004 — captura genérica sem diagnóstico | Pode aguardar | Contrato atual deliberadamente uniformiza falhas e evita detalhe externo. Melhorar diagnóstico sanitizado depois; antecipar somente se evidência mostrar impossibilidade de investigar falhas sem expor segredos. |
| BE-005 — pytest/httpx na imagem | Pode aguardar | Separar dependências de teste é desejável, mas não bloqueia prova funcional. Se auditoria revelar vulnerabilidade impeditiva, reclassificar. Evitar quebrar mecanismo de teste do laboratório. |
| BE-006 — 503 ausente de OpenAPI explícito | Pode aguardar | Contrato escrito e resposta runtime já definidos; documentar depois sem mudar payload. |
| BE-007 — cobertura unitária direta insuficiente | Pode aguardar como expansão de suíte | Executar os três testes existentes e comprovar integração real antes do aceite. Testes diretos de configuração/driver desejáveis; acrescentar antes somente se falha observada ou requisito de QA exigir. |

BE-003 é um gate de evidência; não pressupõe que o arquivo de integração precise ser alterado. BE-001/002 são requisitos de repetibilidade do aceite formal, não prova de defeito em runtime. Caso HUMAN-001 e AGT-001 decidam fazer uma execução exploratória anterior, rotulá-la como diagnóstico, com versões efetivamente resolvidas registradas, sem equivaler à homologação.

## 3. Menor intervenção proposta e caminhos exatos

**Patch mínimo candidato, sujeito a AUT própria:**
- src/backend/requirements.txt: converter resolução de instalação em conjunto fixo, incluindo dependências transitivas e hashes adequados ao alvo; alternativa de lock separado somente se AGT-001 especificar explicitamente o caminho e ajustar consumidor. Preservar conjunto atual de dependências nesta rodada, se compatível, para não quebrar testes existentes. Não instalar nesta análise.
- infra/docker/Dockerfile.backend: fixar FROM por digest verificado; usar instalação que valide hashes quando lock os contiver, preservando usuário não root e CMD.
- Nenhuma mudança obrigatória em main.py, db.py, config.py, Compose ou testes para validar o comportamento se os testes existentes mais o roteiro QA/DevOps cobrirem os critérios abaixo.

**Caminhos condicionais (não incluir automaticamente no patch mínimo):**
- tests/integration/test_health_compose.py: somente se evidência HTTP automatizada adicional for necessária; manter integração opt-in e loopback; não controlar Docker/rede a partir do teste.
- tests/unit/test_health_unit.py: somente se necessário reforçar asserções de sanitização e recuperação.
- tests/unit/test_db_unit.py e tests/unit/test_config_unit.py (novos arquivos propostos): casos de parâmetros de conexão, retorno inesperado, configuração inválida e fechamento de recursos; dependem de autorização específica para criação.
- src/backend/main.py: diagnóstico sanitizado/OpenAPI 503, diferidos. src/backend/db.py e src/backend/config.py: correção dirigida somente se falha comprovada.
- src/backend/requirements-dev.txt (novo, proposto): separação futura; coordenar instalação e execução dos testes com DevOps.
- scripts/infra/backend-lab.sh: não é escopo do backend; AGT-003 deve verificar se o mecanismo de build utiliza revisão antiga ou dependências fixadas no local correto e propor alteração própria se necessário. Não duplicar patch em TKC-0010. infra/docker/docker-compose.lab.yml permanece intacto salvo necessidade comprovada e autorização separada.

Critério de parada: não expandir escopo para melhorias adiáveis se o artefato mínimo e os testes de aceite forem suficientes. Se resolução, digest ou execução apresentar falha, registrar evidência e formular correção específica; não iniciar refatoração por hipótese.

## 4. Aceitação proposta — evidência necessária

Todos os casos estão NÃO EXECUTADOS por AGT-004. Execução requer autorização de ambiente/comandos e supervisão apropriada. Aproveitar matriz TKC-PAR-0012 (TST-01..10) em vez de criar campanha concorrente.

| Gate | Pré-condição e procedimento autorizado futuro | Resultado exigido / evidência |
|---|---|---|
| A01 — artefato | Verificar commit de fonte, plataforma, digest base, lock/hash; construir em laboratório autorizado | Build bem-sucedido; registrar SHA de fonte, versões resolvidas, digest/ID da imagem; repetir resolução/build e comparar conjunto de dependências e digest de origem (não exigir igualdade binária de imagem sem build determinístico). Revisão de vulnerabilidades/licenças, sem custo adicional. |
| A02 — unidade | Executar pytest nos testes unitários existentes com dependências autorizadas | Três casos de health passam; saída real com contagem, versão e código de retorno; nenhuma conexão PostgreSQL real nos mocks. |
| A03 — HTTP 200 | Banco existente acessível pela rede privada; chamar GET /health no loopback | HTTP 200 e JSON exatamente {"status":"ok","database":"up"} semanticamente; registrar horário, duração e resposta. |
| A04 — HTTP 503 | DevOps/operador autorizado simula perda temporária de conectividade por mecanismo revisado, com restauração garantida e confirmação humana conforme autorização | HTTP 503 e JSON exatamente {"status":"unhealthy","database":"down","error":"DB_UNAVAILABLE"}; não aceitar timeout do cliente, 500 ou ausência de resposta como equivalente. Registrar duração e código real. |
| A05 — sanitização | Teste de falha mock com marcador sintético; inspecionar respostas e logs autorizados sanitizados durante A04 | Marcador, senha, DSN, SQL e stack trace ausentes da resposta; sem divulgação de credenciais em logs/evidências; não imprimir ambiente real. Teste unitário de resposta não prova segurança de todos os logs. |
| A06 — recuperação | Restaurar exclusivamente a conectividade temporariamente afetada, mantendo API ativa | Retorno a HTTP 200 e JSON esperado dentro da janela acordada previamente; registrar identidade e instante de início do container/processo Uvicorn antes/depois para provar ausência de restart; retries limitados, latências observadas. |
| A07 — preservação PostgreSQL | Antes/depois registrar identidade do container do banco, volume/mount e evidência de dados de referência não sensíveis por consulta somente leitura autorizada; comparar rede e publicação de portas | Mesmo banco e volume, dados de referência preservados, sem segundo banco, sem exclusão/recriação de volume, sem nova exposição 5432; API publicada apenas no loopback; rede restaurada. Não inferir preservação apenas de SELECT 1 ou do retorno 200. Não inserir dados nem reiniciar banco nesta validação salvo autorização própria. |
| A08 — orçamento temporal e falha segura | Medir conexão/SQL/HTTP nos casos de sucesso e falha; fixar orçamento e tolerância antes da campanha | HTTP 503 observável dentro do limite acordado; distinguir timeout cliente de resposta do servidor. connect_timeout=3 e statement_timeout=3000 não são deadline global de 3 ou 6 s; HTTPX timeout=6 tampouco é garantia de duração total. Não inventar SLA. |
| A09 — revisão independente | QA analisa evidências A01–A08 e DevOps confirma recuperação/isolamento; AGT-001 consolida | Todos os gates indispensáveis satisfeitos ou impedimento explicitamente registrado; aceite humano distinto da execução. Nenhum marco concluído por este parecer. |

A03–A06 podem aproveitar o ciclo do menu já planejado (opções 7 diagnóstico, 8 API, 9 falha/recuperação), desde que AGT-003 e QA confirmem a revisão vigente e o roteiro não mascara status, não reinicia API e restaura rede em caso de interrupção. A02 e A05 com mocks não substituem A04/A06 reais. Para falha de timeout SQL e credencial, usar testes unitários simulados como expansão inicial; não alterar senha/banco real apenas para provocar falha.

## 5. Interfaces e ordem de trabalho

- AGT-004: contrato HTTP, requirements e testes unitários; recomendar alterações mínimas, executar somente sob AUT/claim de produto.
- AGT-003: dono funcional de Dockerfile, Compose, scripts e operações de rede/VM; coordena com Backend a interface requirements/Dockerfile/build e confirma a fonte efetivamente implantada. TKC-0010-C04 encontra-se EM_EXECUCAO na base C03 com escopo de patch de menu Bash; não editar nem concorrer com esse trabalho. Aguardar revisão do patch ou evidência de solução antes de validação mutável pelo menu.
- AGT-002: proprietário funcional da matriz QA, oráculos, coleta/revisão das evidências e eventual testes de integração; coordena com Backend qualquer edição do mesmo arquivo. Não transformar parecer QA em teste executado.
- AGT-001: decide prioridades, resolve sobreposição, emite proposta AUT com caminhos exatos, ambiente, critérios, responsável único por arquivo e rollback; HUMAN-001 decide autorização. Ordem recomendada: fechar interface DevOps/menu e definir resolução de dependências/digest, executar patch mínimo sob claims coordenados, rodar unidade, campanha real QA/DevOps, revisão e aceite.
- Caminho compartilhado deve ter um único executor por tentativa: requirements.txt (Backend com revisão DevOps), Dockerfile.backend (DevOps com contrato Backend), tests/integration/test_health_compose.py (executor designado por AGT-001 com revisão QA/Backend). Índice compartilhado: alterar somente linha própria, revalidar HEAD e preservar registros concorrentes. Claims são cooperativos.

## 6. Evidências, riscos e conclusão

**VERIFICADO POR INSPEÇÃO:** sete achados do parecer original; parâmetros configurados, tratamento de erro, estrutura Compose e cobertura existente; comparação Git confirma ausência de mudanças técnicas entre entrega original e base C03; revisão normativa COM-001/002; posse C03 confirmada antes da escrita. Não equivale a confirmação de build, rede ou comportamento em execução.

**MEDIADO:** aceite com ressalvas do AGT-001 transportado por HUMAN-001; autorização documental explícita C03; relatos prévios de persistência não substituem A07.

**NÃO EXECUTADO:** pytest, integração, build, Docker, rede, VM, PostgreSQL, CVE/licença, medição de latências e teste de recuperação. Nenhum resultado PASS/FALHA operacional alegado.

**INFERIDO / NÃO VERIFICADO:** RBE-001 a RBE-006 do parecer original permanecem riscos; nenhum foi promovido a incidente reproduzido. A priorização é PROPOSTA técnica, não decisão de execução nem autorização. Nenhuma mudança de produto/infraestrutura, custo adicional R$ 0,00. Conclusão: três gates indispensáveis (BE-001/002/003), quatro melhorias adiáveis (BE-004/005/006/007); patch candidato mínimo de dois arquivos, condicionado à autorização; prova real obrigatória. C03 documental entregue para revisão de AGT-001; não concluir TKC-0011 nem M3-02 por autorrelato.
