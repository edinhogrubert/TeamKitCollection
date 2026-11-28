# TKC-PAR-0013 — Parecer de arquitetura e dependências do primeiro backend

**Tarefa / ordem:** `TKC-0013` / `TKC-REQ-0013`  
**Autor:** AGT-001 — Liderança e Arquitetura  
**Data:** 2026-11-27  
**Escopo:** L0/L1, inspeção documental do GitHub; sem código, Docker, VM ou operações no PostgreSQL  
**Base técnica verificada:** `8269fc7d7201664f2b6468ad50505485c9ddb41c`  
**Claim de publicação:** `TKC-0013-C02` confirmado em `355be18e5c9cbd1bdbd44011ee536c0ae45b4ea6`  
**Conclusão:** `APTO_PARA_PLANEJAMENTO` / `NÃO_HOMOLOGADO_OPERACIONALMENTE`; revisão independente ainda pendente.

## 1. Resumo executivo

O primeiro corte utiliza API Python 3.12/FastAPI com `GET /health`, uma consulta `SELECT 1` via Psycopg 3 e container PostgreSQL 16 preexistente. O Compose gerencia somente a API, com porta de host `127.0.0.1:8000` e rede externa `tkc-lab-net`. O serviço de banco `tkc-postgres16` e o volume `tkc-postgres16-data` devem ser preservados.

O desenho básico é consistente por inspeção, mas a Fase B ainda não possui evidência operacional suficiente. Não iniciar operações mutáveis do menu antes de avaliar a semântica Bash de tratamento de erro e os outros bloqueadores aplicáveis.

## 2. Interfaces, contratos e responsáveis

| Interface | Fonte verificada na base | Contrato e fronteira | Responsável técnico |
|---|---|---|---|
| HTTP / API | `src/backend/main.py`, `docs/contratos-api.md` | `GET /health`: 200 `{"status":"ok","database":"up"}`; falha 503 `{"status":"unhealthy","database":"down","error":"DB_UNAVAILABLE"}` | AGT-004 |
| Banco | `src/backend/db.py`, `src/backend/config.py` | `SELECT 1`; `connect_timeout=3`, `statement_timeout=3000`; credencial via ambiente, sem retorno ao cliente | AGT-004; operação por HUMAN-001 autorizado |
| Orquestração | `infra/docker/docker-compose.lab.yml`, `infra/docker/Dockerfile.backend` | API isolada; PostgreSQL não gerenciado pelo Compose; porta 5432 não publicada pelo Compose | AGT-003 |
| Menu e scripts | `scripts/infra/teamkit-lab.sh`, `scripts/infra/backend-lab.sh` | Menu 7 diagnóstico, 8 subida da API, 9 ciclo 200→503→200; preservação de dados e rede | AGT-003 |
| Verificações QA | `tests/unit/test_health_unit.py`, `tests/integration/test_health_compose.py`, `TKC-PAR-0012` | Unidade com mocks; integração somente sob `TKC_RUN_INTEGRATION=1`; matriz TST-01..10 | AGT-002 |
| Coordenação | `IA/tarefas/indice.md`, COM-001 e COM-002 | Pareceres, escopos e autorizações individualizados; claims cooperativos, não locks atômicos | AGT-001/HUMAN-001 |

**Observação importante:** `Dockerfile.backend` executa Uvicorn em `0.0.0.0` **dentro do container**, enquanto o Compose vincula a publicação de host a `127.0.0.1:8000`. Não confundir bind interno com exposição externa; validar publicação real antes do aceite.

## 3. Riscos, lacunas e decisões

### B01 — Falhas Bash no wrapper do menu — bloqueador para operações mutáveis

`run_menu_action()` executa `if ( action "$act" ); then`. Em Bash, executar funções em condição testada por `if` pode neutralizar `errexit` no interior, permitindo que um erro intermediário seja ignorado e comandos posteriores prossigam. O código suscita um risco técnico fundamentado; **não existe demonstração executada nesta análise**, e a conclusão depende do parecer `TKC-PAR-0010`.

- **Responsável:** AGT-003, tarefa `TKC-0010`.
- **Próxima entrega:** parecer integral com reprodução Bash sintética, abrangência nas opções mutáveis e correção mínima sugerida.
- **Arquivos possíveis sob futura autorização L2:** `scripts/infra/teamkit-lab.sh`; `scripts/infra/backend-lab.sh` apenas se demonstração de impacto exigir.
- **Gate:** AGT-001 revisa, HUMAN-001 decide eventual autorização específica L2; sem operação na VM nesta etapa.

### B02 — Revisão do backend e reprodutibilidade

`src/backend/requirements.txt` usa faixas de versões e `infra/docker/Dockerfile.backend` usa `python:3.12-slim` sem digest fixo. `tests/unit/test_health_unit.py` contém casos 200/503/recuperação com mocks, mas sua presença não prova execução. O arquivo de integração presente testa resposta 200 com a API já disponível, **não** substitui teste operacional completo do ciclo de falha e reconexão.

- **Responsável:** AGT-004, tarefa `TKC-0011`.
- **Próxima entrega:** `TKC-PAR-0011` distinguindo falhas comprovadas, hipóteses, pin/lock, segurança e testes mínimos.
- **Arquivos possíveis sob futura autorização L2:** `src/backend/requirements.txt`, `infra/docker/Dockerfile.backend`, `tests/`, ou código FastAPI somente conforme achado específico.
- **Gate:** revisão de AGT-001 e decisão de HUMAN-001 se alteração modificadora for necessária.

### B03 — Aceite QA sem evidência operacional

`TKC-PAR-0012` v2 foi publicado, e `TKC-0012` registra `APROVADO_COM_RESSALVAS` **documentalmente**. Testes TST-01..TST-10 continuam sem comprovação de execução por AGT-002 na VM. Persistência do PostgreSQL após reinício foi relatada anteriormente por HUMAN-001 em `TKC-0008` (`MEDIADO`), não é homologação do backend.

- **Responsável:** AGT-002 para avaliar evidências, HUMAN-001 ou executor explicitamente autorizado para operação.
- **Gate:** revisão B01/B02, autorização operacional própria e evidência sanitizada de HTTP, portas, segredos, idempotência, segurança de volume e reconexão.

### B04 — Preservação de recursos e recuperação da rede

Proibido presumir autorização para remover/recriar `tkc-postgres16` ou `tkc-postgres16-data`. O teste da opção 9 desconecta temporariamente o banco da rede `tkc-lab-net`; traps de shell não garantem recuperação sob `SIGKILL`, queda da VM ou falha do daemon.

- **Responsável:** AGT-003 no plano operacional e HUMAN-001 na autorização.
- **Gate:** procedimento de recuperação definido antes do teste; sem publicar 5432 no host, sem `docker volume rm` ou `docker compose down -v`.

## 4. Dependências e coordenação de arquivos

| Etapa | Responsável | Entrega verificável | Dependência / próximo destinatário |
|---|---|---|---|
| 1 — DevOps | AGT-003 | `TKC-PAR-0010` completo, com teste Bash sintético e diagnóstico | AGT-001 revisa; eventual L2 exige HUMAN-001 |
| 2 — Backend (paralelo) | AGT-004 | `TKC-PAR-0011` com análise dos contratos, código, testes, Dockerfile e riscos | AGT-001 revisa; eventual L2 exige HUMAN-001 |
| 3 — Consolidação | AGT-001 | Classificação de bloqueadores, caminhos sobrepostos e propostas separadas de correção | HUMAN-001 decide propostas específicas |
| 4 — Correções, se necessárias | Agente autorizado por caminho | Commit/testes e verificação independente, após claim COM-001 | AGT-002/revisor distinto confere |
| 5 — Homologação planejada | HUMAN-001 + executor autorizado | Registro de testes Fase B com respostas 200/503/200, rede, portas, dados e rollback | AGT-002 analisa evidências; AGT-001 integra |
| 6 — Aceite | HUMAN-001 | Decisão explícita documentada | Sem conclusão antecipada de Fase B ou M3-02 |

**Conflitos de caminhos:** DevOps deve controlar `scripts/infra/*` e `infra/docker/*`; Backend deve controlar `src/backend/*` e testes próprios sob escopo concedido. Dockerfile/requirements e testes de integração são fronteira compartilhada: AGT-001 coordena proposta/posse específica antes de duas edições concorrentes. AGT-002 não deve auditar mudanças que ele próprio executou.

## 5. Estado das evidências e limitações

- `VERIFICADO` por inspeção Git: arquivos e contratos citados, Compose limitado à API, casos unitários definidos, risco do contexto Bash condicional e publicação QA v2.
- `MEDIADO`/`RELATADO`: relato anterior de persistência do PostgreSQL em `TKC-0008`; AGT-003 declarou em conversa que `TKC-PAR-0010` estaria pronto, mas conteúdo integral não recebido.
- **Não localizado na base conferida:** `IA/despachos/retornos/TKC-PAR-0010.md` e `IA/despachos/retornos/TKC-PAR-0011.md` (consulta 404).
- `NÃO_EXECUTADO`: Bash sintético por AGT-001 nesta análise, Python/pytest, Docker/Compose, rede, VM, PostgreSQL e testes de homologação.
- Nenhuma ação na Oracle, nenhum custo incremental, nenhuma alteração de produto/infraestrutura.

## 6. Conclusão e próximos passos PA-01

**Parecer de arquitetura:** APTO PARA PLANEJAMENTO, NÃO APTO PARA HOMOLOGAÇÃO OPERACIONAL. A revisão independente do próprio parecer ainda é necessária antes de considerá-lo aceito.

**Ação P1 / TKC-0010:** HUMAN-001 encaminha referência ao AGT-003; AGT-003 apresenta parecer completo com reprodução sintética, riscos e proposta; AGT-001 recebe e revisa. **Conclusão:** documento integral acessível e criticado; sem patch automático.

**Ação P2 / TKC-0011:** HUMAN-001 transporta `TKC-REQ-0011` caso necessário; AGT-004 produz `TKC-PAR-0011` L0/L1; AGT-001 revisa. **Conclusão:** parecer integral verificável e bloqueadores listados.

**Ação P3 / TKC-0013:** AGT-001 registra este parecer na `main`; destinatário da revisão independente é revisor distinto a designar por HUMAN-001, sem autoacionamento. **Conclusão:** commit e tarefa reconciliados; revisão ainda pendente.

**Ação P4 / Fase B:** após P1/P2 e correções aprovadas, AGT-001 prepara plano operacional seguro e solicita decisão de HUMAN-001. Só o executor autorizado realiza comandos; AGT-002 avalia evidências. **Conclusão:** homologação formal baseada em testes reais, nunca só em pareceres.
