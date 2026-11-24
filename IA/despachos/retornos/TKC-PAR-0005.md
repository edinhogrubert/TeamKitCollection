# TKC-PAR-0005 — Parecer Técnico L0/L1 sobre o Primeiro Corte Vertical Executável do TeamKitCollection

| Campo | Valor |
|---|---|
| `message_id / return_id` | `TKC-PAR-0005` |
| `reply_to / order_id` | `TKC-REQ-0005` |
| `task_id` | `TKC-0005` |
| `claim_id` | `TKC-0005-C04` (reivindicação confirmada no remoto em `709cfffaabb7787191f605077144362f2835760c`) |
| `from_role / author` | `AGT-002` — Sessão Gemini no Google AI Studio (atuação em `L0/L1`: Arquitetura, Requisitos, Desenvolvimento, Infraestrutura/Docker, QA e Segurança) |
| `to_role` | `AGT-001` e `HUMAN-001` |
| `created_at` | `2026-11-24` |
| `base_commit` | `778cd59e0f80c405f40c8b211254591d4ef9fc5f` (análise inicial da REQ); `6b260064b8447d547c69c0cc85f0e944c7a90d83` (base da reivindicação `TKC-0005-C04` após Retificação C02/C03) |
| `claim_commit` | `709cfffaabb7787191f605077144362f2835760c` |
| `rules_checked_commit` | `6b260064b8447d547c69c0cc85f0e944c7a90d83` |
| `rules_scope` | `AGENTS.md`, `IA/regras/constituicao.md`, `IA/regras/seguranca.md`, `IA/regras/comunicacao.md`, `IA/despachos/README.md` (`COM-002.2` atualizado em `6b260064b8447d547c69c0cc85f0e944c7a90d83`) |
| `rules_check_status` | `ATUALIZADO` (`VERIFICADO` via `git diff e05420538e393293df04ea60c6ee3a9e01da9ce0..6b260064b8447d547c69c0cc85f0e944c7a90d83`) |
| `max_action_level` | `L1` para análise técnica do produto (zero alterações em código/infraestrutura); `L2` restrito exclusivamente aos arquivos de comunicação (`IA/tarefas/TKC-0005.md`, `IA/tarefas/indice.md` e `IA/despachos/retornos/TKC-PAR-0005.md`) |
| `authorization_state` | `TRUE` somente para publicar este parecer e atualizar posse em `TKC-0005.md` e `indice.md`; `PENDENTE` para qualquer código, teste ou infraestrutura |
| `authorization_provenance` | `MEDIADO` — decisão expressa por `HUMAN-001` no canal da sessão do `AGT-002` |
| `delivery_channel` | `PUBLICADO_NO_GIT` (`Modo A` de `COM-002.2` / `Retificação C03`) |
| `viability_classification` | `VIAVEL_COM_CONDICOES` |

---

## 1. Capacidade Real da Sessão e Evidências Consultadas (Matriz `C02-A04`)

### 1.1. Matriz de capacidade operacional desta sessão (`AGT-002` — Google AI Studio)

| Dimensão (`C02-A04` / `TKC-0004`) | Classificação desta sessão | Evidência técnica verificada (`L0`) |
|---|---|---|
| **Leitura Git (`git_read_mode`)** | `DIRETA` (`VERIFICADO`) | Sincronização direta via `git fetch origin main` no container com `https://github.com/edinhogrubert/TeamKitCollection.git`, inspecionando os commits `778cd59e0f80c405f40c8b211254591d4ef9fc5f`, `4c6bd5fd29c3919ded794b4eef9927f364ce9b11` e `6b260064b8447d547c69c0cc85f0e944c7a90d83`. |
| **Escrita Git (`git_write_mode`)** | `DIRETA` (`VERIFICADO` com configuração local efêmera não versionada) | O container do Google AI Studio é efêmero e não possui integração nativa persistente de escrita Git com o GitHub; após reinício do container, a escrita direta (`git push`) depende de helper local não versionado (`.git/credential-helper.sh`, fora da árvore rastreada pelo Git) configurado na sessão sob determinação explícita do `HUMAN-001` (Nível 0). Confirmado pelo push da reivindicação `TKC-0005-C04` (`709cfffaabb7787191f605077144362f2835760c`). |
| **Execução de comandos/testes locais** | `PARCIAL / RESTRITA AO SANDBOX` (`VERIFICADO`) | Inspeção `L0` no container Linux do AI Studio:<ul><li>`git`: `DISPONIVEL (git version 2.34.1)`</li><li>`node`: `DISPONIVEL (v22.23.5)`</li><li>`npm`: `DISPONIVEL (10.9.9)`</li><li>`bun`: `DISPONIVEL (1.4.4)`</li><li>`python3`: `DISPONIVEL (Python 3.11.2)`</li><li>`curl`: `DISPONIVEL (curl 7.88.1)`</li><li>`docker`: **`AUSENTE` (`INDISPONÍVEL`)**</li><li>`psql`: **`AUSENTE` (`INDISPONÍVEL`)**</li><li>`pip`: **`AUSENTE` (`INDISPONÍVEL`)**</li><li>`pytest`: **`AUSENTE` (`INDISPONÍVEL`)**</li><li>`gh`: **`AUSENTE` (`INDISPONÍVEL`)**</li></ul> |
| **Pull Request** | `SEM_ACESSO` via CLI (`gh` ausente) | Possível criar/enviar branch via `git push` (quando autorizado em `L2`) para abertura de PR via interface web ou API HTTPS. |
| **Canal de recebimento** | `LINK_GITHUB` + `ID_CURTO` (`TKC-REQ-0005`) | Recebido do `HUMAN-001` e confrontado diretamente contra os arquivos versionados no Git (`778cd59e` e `6b260064`). |
| **Canal de retorno** | `PUBLICADO_NO_GIT` (`Modo A` — `COM-002.2`) | Publicado diretamente em `IA/despachos/retornos/TKC-PAR-0005.md` sob reivindicação `TKC-0005-C04`. |

### 1.2. Fontes e commits efetivamente inspecionados (`VERIFICADO`)

1. `IA/despachos/ordens/TKC-REQ-0005.md` (lido nos commits `778cd59e0f80c405f40c8b211254591d4ef9fc5f`, `4c6bd5fd29c3919ded794b4eef9927f364ce9b11` e `6b260064b8447d547c69c0cc85f0e944c7a90d83`).
2. `IA/tarefas/TKC-0005.md` (lido integralmente até a revisão `C03` em `6b260064b8447d547c69c0cc85f0e944c7a90d83`).
3. `IA/tarefas/indice.md` (lido integralmente em `6b260064b8447d547c69c0cc85f0e944c7a90d83`).
4. `IA/tarefas/TKC-0004.md` (187 linhas, `CONCLUIDA` em `e05420538e393293df04ea60c6ee3a9e01da9ce0` — matriz de acesso `C02-A04`, ficha de métricas `C02-A03` e protocolo `HND-T01`).
5. `README.md` (leitura integral das seções 1 a 10 — visão do produto, catálogo esportivo e seções 6 a 9 de arquitetura de infraestrutura, laboratório com 3 instâncias `App BR/EU/US` + Gateway + `PostgreSQL Primary/Replica`, migração e resiliência).
6. Documentos normativos: `AGENTS.md`, `IA/regras/constituicao.md`, `IA/regras/seguranca.md`, `IA/regras/comunicacao.md` e `IA/despachos/README.md` (incluindo a seção `COM-002.2` adicionada em `6b260064b8447d547c69c0cc85f0e944c7a90d83`).

---

## 2. Viabilidade Técnica e Comparação Arquitetural do Backend

Conforme determinado em `TKC-REQ-0005`, a ausência de especialização humana em uma linguagem específica **não é utilizada como critério para simplificar a arquitetura**. A avaliação considera a evolução completa do `TeamKitCollection` descrita no `README.md` (§3 e §6): catálogo hierárquico relacional (`Esporte -> Liga -> Time -> Temporada -> Kit -> Variante/Mídia`), execução stateless multi-instância atrás de Gateway (`App Instance 1 BR`, `App Instance 2 EU`, `App Instance 3 US`) e banco de dados PostgreSQL com separação futura entre escrita (`Primary`) e leitura (`Replica`).

### 2.1. Matriz comparativa das tecnologias candidatas

| Critério | Opção A (Recomendada): **Python 3.12 + FastAPI + Psycopg 3 / SQLAlchemy 2.0 + Pydantic v2 + Pytest** | Opção B: **Node.js 22 LTS + TypeScript 5 + Fastify + `pg` / Drizzle + Vitest / `node:test`** | Opção C: **Python 3.12 + Django 5.1 + Django Ninja / DRF** |
|---|---|---|---|
| **Arquitetura evolutiva (`README.md` §3.1 e §6.3)** | **Excelente.** `README.md` §3.1 prevê Python (FastAPI/Django) para o backend. FastAPI é stateless por padrão, leve (~45–70 MB RAM por réplica em `python:3.12-slim`), ideal para rodar 3 réplicas regionais + Gateway + 2 containers PostgreSQL na mesma VM Linux local, e facilita configurar pools distintos `WRITER_DB_URL` (`Primary`) e `READER_DB_URL` (`Replica`). | **Muito boa.** Stateless, baixo consumo de memória em `node:22-alpine`, tipagem estática forte. Exige configuração manual mais cuidadosa de migrações e roteamento `Primary/Replica`. | **Moderada para o primeiro corte e laboratório multi-instância.** Carrega acoplamento monolítico maior (middlewares de sessão, admin, auth) e footprint superior por container desde o primeiro corte vertical. |
| **Confiabilidade e Operação** | Healthcheck determinístico (`SELECT 1` com `connect_timeout=2` via `psycopg`), pool de conexões com verificação prévia (`pool_pre_ping`), ciclo de vida ASGI (`lifespan`) limpo. | Muito boa com `pg.Pool` (`connectionTimeoutMillis: 2000`), porém requer cuidado no container do AI Studio para não colidir com o `package.json` raiz do preview da plataforma. | Robusta, mas menos transparente para testes didáticos de falha de socket/timeout em conexões curtas de laboratório. |
| **Segurança (`SEC-001` a `SEC-008`)** | Validação estrita no boot via `pydantic-settings` (falha imediata se variáveis obrigatórias faltarem, sem credenciais default hardcoded), queries parametrizadas e sanitização simples de erros no handler HTTP `503`. | Alta com `zod` / `@sinclair/typebox` e queries parametrizadas em `pg`. | Alta para CRUD web, porém exige endurecimento imediato (`DEBUG=False`, `SECRET_KEY`, `ALLOWED_HOSTS`) já no corte mínimo. |
| **Facilidade de verificação por múltiplas IAs** | **Muito alta em qualquer ambiente com Docker ou Python + venv.** Contratos tipados explícitos, `pytest` + `httpx` testam `200 OK` e `503 Service Unavailable` por injeção de dependência e contra o container real. | **Alta**, com vantagem pontual de `node`/`npm` já estarem instalados no container do AI Studio para testes unitários mockados, embora o Docker Compose continue exigindo a VM Linux / host com Docker. | **Média.** Maior número de arquivos de boilerplate inicial aumenta o custo de leitura de contexto (`COM-001` §10). |
| **Custo financeiro efetivo (`P7` / `SEC-007`)** | **`R$ 0,00`** (100% open-source, licenças MIT/BSD/PSF, imagens oficiais gratuitas `python:3.12-slim` e `postgres:16-alpine`). | **`R$ 0,00`** (100% open-source). | **`R$ 0,00`** (100% open-source). |

### 2.2. Recomendação concreta de arquitetura, componentes e versões (`PROPOSTO`)

Recomenda-se a **Opção A (Python 3.12 + FastAPI + Psycopg 3 + PostgreSQL 16 em Docker Compose)** com versões fixadas (`pinned`):

- **Imagem base da API:** `python:3.12.8-slim-bookworm` (executando com usuário não-root `appuser`, `UID 10001`).
- **Imagem do Banco de Dados:** `postgres:16.6-alpine3.20` (com `healthcheck` nativo via `pg_isready`).
- **Pacotes Python fixados (`requirements.txt`):**
  - `fastapi==0.115.6`
  - `uvicorn[standard]==0.34.0`
  - `psycopg[binary,pool]==3.2.3`
  - `pydantic==2.10.3`
  - `pydantic-settings==2.7.0`
  - `pytest==8.3.4`
  - `httpx==0.28.1`
- **Contrato comportamental do endpoint `GET /health`:**
  - **Caso saudável (`HTTP 200 OK`):** a aplicação está ativa e executa `SELECT 1;` no PostgreSQL dentro do timeout (`DB_CONNECT_TIMEOUT=2` segundos). Retorna:
    ```json
    {
      "status": "ok",
      "service": "teamkitcollection-api",
      "instance_id": "app_local_01",
      "region": "lab-local",
      "checks": {
        "application": "up",
        "database": "up"
      }
    }
    ```
  - **Caso de falha/indisponibilidade do banco (`HTTP 503 Service Unavailable`):** quando o container do PostgreSQL está parado, pausado ou inacessível, o endpoint captura a exceção de conexão/timeout, sanitiza qualquer detalhe sensível (jamais expondo DSN, senha, usuário ou stacktrace) e retorna em `<= 2–3s`:
    ```json
    {
      "status": "degraded",
      "service": "teamkitcollection-api",
      "instance_id": "app_local_01",
      "region": "lab-local",
      "checks": {
        "application": "up",
        "database": "down"
      },
      "error": {
        "code": "DB_UNAVAILABLE",
        "message": "Database connectivity check failed."
      }
    }
    ```

---

## 3. Escopo Futuro de Arquivos (`IA/` vs. `docs/`) e Autorizações (`L2` vs. `L3`)

### 3.1. Caminhos exatos propostos para a futura fase de implementação (`AGENTS.md` §4 e §4.1)

Respeitando a separação obrigatória entre método (`IA/`) e produto (`docs/`, `src/`, `tests/`, `infra/`):

1. **Documentação tradicional de engenharia do produto (`docs/` — compreensível por equipe humana sem ler `IA/`):**
   - `docs/arquitetura.md`: arquitetura do primeiro corte vertical (`api` + `db_primary`) e sua evolução para a topologia completa do `README.md` §6 (`Gateway + 3 instâncias regionais + Primary/Replica`).
   - `docs/contratos-api.md`: especificação formal do endpoint `GET /health` (`200 OK` e `503 Service Unavailable`).
   - `docs/infraestrutura.md`: especificação do Docker Compose de laboratório, rede bridge isolada `tkc_lab_net`, volume nomeado `tkc_pgdata_lab` e variáveis de ambiente.
   - `docs/testes.md`: roteiro determinístico de verificação (testes unitários, subida do Compose, teste saudável `200`, teste de persistência, simulação controlada de queda do banco `503` e recuperação).
   - `docs/operacao.md`: procedimentos seguros de subida, parada, inspeção de logs sanitizados e rollback sem perda de volume.
2. **Código da aplicação (`src/backend/` — isolado em subpasta para evitar qualquer colisão com arquivos locais de preview de ferramentas):**
   - `src/backend/__init__.py`
   - `src/backend/config.py`
   - `src/backend/db.py`
   - `src/backend/main.py`
   - `src/backend/requirements.txt`
3. **Testes automatizados (`tests/`):**
   - `tests/unit/test_health_unit.py` (testes com injeção de dependência para `200 OK` e `503 Service Unavailable` + asserção de ausência de vazamento de segredos).
   - `tests/integration/test_health_compose.py` (teste HTTP contra `http://127.0.0.1:8000/health` no laboratório Docker).
4. **Infraestrutura de laboratório (`infra/docker/` e `.gitignore`):**
   - `infra/docker/Dockerfile.backend`
   - `infra/docker/docker-compose.lab.yml`
   - `infra/docker/.env.lab.example`
   - `.gitignore` (garantindo exclusão de `.env`, `infra/docker/.env.lab`, `.venv/`, `__pycache__/`, `.pytest_cache/`).
5. **Registros do método (`IA/`):**
   - `IA/tarefas/TKC-0005.md`, `IA/tarefas/indice.md`, `IA/despachos/logs/TKC-EXE-0005.md` e `IA/despachos/retornos/TKC-RET-0005.md`.

### 3.2. Operações que exigem autorização separada (`L2` vs. `L3` — `GOV-001` §7 e `SEC-002`)

| Operação futura | Nível (`SEC-002`) | Autorização exigida |
|---|---|---|
| Criação/edição de arquivos em `src/backend/`, `tests/`, `infra/docker/`, `docs/`, `.gitignore` e registros em `IA/` | **`L2`** | Proposta `TKC-AUT-0005` publicada + decisão humana `TKC-AUT-0005 #TRUE` + reivindicação `claim_id` prévia confirmada no remoto. |
| Execução de testes unitários em memória (`pytest tests/unit/test_health_unit.py`) sem containers nem abertura de portas | **`L2`** | Coberta pela autorização `L2` de desenvolvimento/teste local em ambiente com Python/pytest. |
| **Build e subida de containers Docker, criação da rede `tkc_lab_net`, criação do volume `tkc_pgdata_lab` e bind local `127.0.0.1:8000:8000` (`docker compose up / stop / start / down`)** | **`L2/L3` (Fronteira de Infraestrutura e Rede Local — `SEC-002` / `SEC-006`)** | **Autorização nominal e explícita dentro de `TKC-AUT-0005`** para os comandos Docker Compose no ambiente de laboratório local, proibindo exposição em `0.0.0.0`. |
| **Exclusão de volume persistente (`docker compose down -v` ou `docker volume rm tkc_pgdata_lab`)** | **`L3` Estrito (Destrutivo de dados — `SEC-006`)** | **Proibido por padrão** em `TKC-0005`; exigiria autorização humana `L3` específica e separada. |

---

## 4. Segurança, Isolamento e Reversão (`SEC-003` a `SEC-006`)

1. **Credenciais não versionadas (`SEC-003`):**
   - Apenas `infra/docker/.env.lab.example` será versionado no Git, com placeholders não secretos (`DB_PASSWORD=CHANGE_ME_LOCAL_LAB_ONLY`).
   - O arquivo real `infra/docker/.env.lab` ficará bloqueado no `.gitignore`.
   - O `docker-compose.lab.yml` usará interpolação obrigatória (`${DB_PASSWORD:?DB_PASSWORD obrigatorio em .env.lab}`), impedindo subida com senha vazia ou default implícito.
2. **Exposição mínima de portas (`SEC-002` / `SEC-006`):**
   - O serviço `db_primary` (`postgres:16.6-alpine3.20`) **não publicará nenhuma porta no host** (sem mapeamento `ports:` para `5432`), sendo acessível unicamente dentro da rede interna `tkc_lab_net` pelo container `app`.
   - O serviço `app` fará bind **exclusivamente no loopback local**: `127.0.0.1:8000:8000`.
3. **Persistência e reversão sem perda involuntária de volumes (`SEC-006`):**
   - Persistência em volume nomeado `tkc_pgdata_lab:/var/lib/postgresql/data`.
   - O comando padrão de encerramento e rollback operacional será `docker compose -f infra/docker/docker-compose.lab.yml down --remove-orphans` (**sem `-v`**), preservando os dados do volume.
4. **Logs e respostas sanitizadas (`SEC-003`):**
   - Falhas de conexão ao banco nunca imprimem a string de conexão com senha nos logs nem no corpo do erro HTTP `503`.

---

## 5. Plano de Verificação Concreta e Reproduzível

1. **Teste 1 — Contrato unitário e sanitização (`pytest` sem Docker):**
   - Execução de `pytest tests/unit/test_health_unit.py -v` validando `200 OK` (quando o probe do banco retorna sucesso) e `503 Service Unavailable` (quando o probe lança erro contendo credencial simulada, provando que o payload de saída não vaza o segredo).
2. **Teste 2 — Subida do Compose e saúde real (`HTTP 200 OK`):**
   - `docker compose -f infra/docker/docker-compose.lab.yml --env-file infra/docker/.env.lab up -d --build --wait`
   - `curl -i -s http://127.0.0.1:8000/health` -> deve retornar `HTTP/1.1 200 OK` com `"status": "ok"` e `"database": "up"`.
3. **Teste 3 — Persistência no volume `tkc_pgdata_lab`:**
   - Criar tabela/registro de verificação via `docker compose exec -T db_primary psql ...`, executar `docker compose restart db_primary` e confirmar via `SELECT COUNT(*)` que o dado persiste após reinício do container.
4. **Teste 4 — Falha controlada do banco sem expor o servidor (`HTTP 503 Service Unavailable`):**
   - Executar `docker compose -f infra/docker/docker-compose.lab.yml stop db_primary`.
   - Executar `curl -i -s http://127.0.0.1:8000/health` em loopback local -> deve retornar em até ~2–3s **`HTTP/1.1 503 Service Unavailable`** com `"status": "degraded"`, `"database": "down"` e `"code": "DB_UNAVAILABLE"`.
5. **Teste 5 — Recuperação automática (`Self-healing`):**
   - Executar `docker compose -f infra/docker/docker-compose.lab.yml start db_primary`, aguardar `pg_isready` e repetir `curl -i -s http://127.0.0.1:8000/health` -> deve voltar a `HTTP/1.1 200 OK` sem reiniciar o container `app`.

---

## 6. Recuperabilidade e Handoff (`HND-T01`)

Para permitir continuidade por qualquer sessão sucessora sem histórico de chat (`P5` e `TKC-0004` `HND-T01`):

- **`task_id`:** `TKC-0005`
- **`base_commit` / `claim_commit`:** `6b260064b8447d547c69c0cc85f0e944c7a90d83` / `709cfffaabb7787191f605077144362f2835760c`
- **`deliverable_published`:** `IA/despachos/retornos/TKC-PAR-0005.md`
- **`environment_constraint_verified`:** O sandbox Google AI Studio (`AGT-002`) possui `git`, `python3`, `node` e `curl`, mas **não possui `docker`, `psql`, `pip` ou `pytest`**.
- **`next_action` determinístico para a sucessão:**
  1. `AGT-001` lê `IA/despachos/retornos/TKC-PAR-0005.md` diretamente no Git (`Modo A` de `COM-002.2`).
  2. Caso o desenho seja aprovado, `AGT-001` publica a proposta `IA/despachos/ordens/TKC-AUT-0005.md` em estado `PENDENTE`, especificando os caminhos autorizados (`src/backend/`, `tests/`, `infra/docker/`, `docs/`, `.gitignore`) e a autorização de execução local do Docker Compose (`127.0.0.1:8000`).
  3. Após decisão `TKC-AUT-0005 #TRUE` do `HUMAN-001`, a sessão executora reivindica `TKC-0005-C05`, implementa os arquivos e a verificação Docker Compose é executada em ambiente com daemon Docker disponível (VM Linux local / host do operador ou agente local com Docker), registrando logs em `TKC-EXE-0005.md` e retorno em `TKC-RET-0005.md`.

---

## 7. Coleta e Registro de Métricas (`C02-A03`)

| Métrica (`C02-A03` / `TKC-0004`) | Valor nesta etapa (`TKC-PAR-0005` — L0/L1) | `metodo_medicao` | Protocolo para a execução futura (`TKC-AUT-0005` -> `TKC-RET-0005`) |
|---|---|---|---|
| `horas_estimadas` | `0,50 h` (parecer L0/L1) / `2,50 h` (estimativa para futura implementação L2 + bateria Docker L2/L3) | `ESTIMADO` | Fixar estimativa prévia em `TKC-AUT-0005` antes do início da codificação. |
| `horas_reais_construcao` | `0,00 h` (nenhum código ou infraestrutura construído em L0/L1) | `MEDIDO` | Medir por timestamps de início/fim da codificação e execução de testes (ou declarar `ESTIMADO` / `NÃO MEDIDO` caso não haja relógio contínuo). |
| `horas_reais_metodo` | `0,40 h` (~24 min somando leitura, inspeção L0 do container, elaboração do parecer e ciclo de retificação/publicação Git C02–C04) | `ESTIMADO` | Medir tempo gasto em sincronização de regras, reivindicação de posse e publicação de `TKC-EXE-0005` / `TKC-RET-0005`. |
| `intervencoes_humanas` | `4` (1: envio inicial de `TKC-REQ-0005`; 2: aviso da Retificação C02; 3: esclarecimento de acesso Git; 4: autorização Nível 0 `AUTORIZO OPCAO 1 #TRUE` para escrita via helper local) | `MEDIDO` | Contabilizar cada mensagem ou comando manual executado por `HUMAN-001`. |
| `tentativas_retrabalho` | `1` (primeira entrega em texto no chat antes da Retificação C02/C03; segunda entrega publicada no Git sob `TKC-0005-C04`) | `MEDIDO` | Contabilizar cada ciclo adicional de tentativa (`claim_id`) ou correção pós-falha. |
| `custo_financeiro` | `R$ 0,00` | `VERIFICADO` | Manter `R$ 0,00` em todas as imagens, pacotes e ferramentas (`P7` / `SEC-007`). |

---

## 8. Parecer Final de Viabilidade

- **Veredito:** **`VIAVEL_COM_CONDICOES`**

### 8.1. Bloqueadores e Condições Reais para a Execução (`L2/L3`)
1. **Autorização formal `TKC-AUT-0005` + `#TRUE` humano:** obrigatória antes de criar qualquer arquivo de código, teste, documentação `docs/` ou manifesto Docker (`GOV-001`, `COM-001`, `COM-002`, `SEC-002`).
2. **Ambiente com daemon Docker para validação dinâmica (`VERIFICADO`):** como o container do Google AI Studio (`AGT-002`) **não possui `docker`, `psql`, `pip` nem `pytest`**, o código e os manifestos podem ser gerados e versionados via Git por `AGT-002` (ou outro agente designado), mas a **execução real do `docker compose up`, persistência e simulação de queda do PostgreSQL (`200` vs. `503`) precisa rodar na VM Linux local / host do operador humano ou em agente local com Docker**, sem jamais declarar testes de container como `VERIFICADO` sem evidência real de execução (`P4`).

### 8.2. Melhorias Posteriores (Não bloqueantes para o primeiro corte)
1. Expansão para as 3 instâncias regionais (`App BR/EU/US`), container de Gateway/Load Balancer e réplica de leitura do PostgreSQL (`README.md` §6.3).
2. Migrações de esquema de negócio do catálogo de camisas (`Alembic`) e endpoints CRUD do domínio.
3. Pipeline automatizado de CI no GitHub Actions (sujeito à verificação de cotas gratuitas `P7` e autorização específica).
