# TKC-PAR-0009 — Parecer Técnico de Prontidão DevOps/SRE (Opções 7, 8 e 9 / Fase B)

| Campo | Valor |
|---|---|
| `message_id / return_id` | `TKC-PAR-0009` |
| `reply_to / order_id` | `TKC-REQ-0009` |
| `task_id` | `TKC-0009` |
| `claim_id` | `TKC-0009-C02` (reivindicação confirmada no remoto em `16c6562ba1556705bd662cca08b328bf3a3a51f6`) |
| `from_role / author` | `AGT-003` — Engenheiro DevOps/SRE (Sessão Gemini no Google AI Studio) |
| `to_role` | `AGT-001` e `HUMAN-001` |
| `created_at` | `2026-11-26` |
| `base_commit` | `017b7c976f74ba48e4daa18b21c2b19951c2ee84` (revalidado a partir da base da REQ `0a66b5958e1526a11ad92dacaae9443ef96b8694`) |
| `claim_commit` | `16c6562ba1556705bd662cca08b328bf3a3a51f6` |
| `rules_checked_commit` | `017b7c976f74ba48e4daa18b21c2b19951c2ee84` |
| `rules_scope` | `AGENTS.md`, `IA/regras/constituicao.md`, `IA/regras/seguranca.md`, `IA/regras/comunicacao.md` (`COM-001`), `IA/despachos/README.md` (`COM-002`) |
| `rules_check_status` | `ATUALIZADO` (`VERIFICADO` por leitura direta do repositório sincronizado em `origin/main`) |
| `max_action_level` | `L0/L1` para análise técnica de infraestrutura/scripts (zero alterações em código, scripts ou containers); `L2` restrito exclusivamente aos arquivos de comunicação (`IA/tarefas/TKC-0009.md`, `IA/tarefas/indice.md` e `IA/despachos/retornos/TKC-PAR-0009.md`) |
| `authorization_state` | `TRUE` somente para publicar este parecer e atualizar posse `TKC-0009-C02` em `TKC-0009.md` e `indice.md`; `PENDENTE` para qualquer edição de script ou operação Docker na VM |
| `authorization_provenance` | `MEDIADO` — decisão e orientação expressas por `HUMAN-001` na sessão de `AGT-003` |
| `delivery_channel` | `PUBLICADO_NO_GIT` (`COM-002.2`, via `GITHUB_TOKEN` em memória e helper `GIT_ASKPASS` temporário, sem exposição de segredo conforme `SEC-003`) |
| `readiness_classification` | `APTO_COM_CONDICOES` |

---

## 1. Veredito de Prontidão

**Veredito:** `APTO_COM_CONDICOES`

1. **Segurança do banco de dados e isolamento de rede (`VERIFICADO` por inspeção estática):** Os scripts `scripts/infra/teamkit-lab.sh` e `scripts/infra/backend-lab.sh` e o Compose `infra/docker/docker-compose.lab.yml` **preservam integralmente** o container `tkc-postgres16` e o volume `tkc-postgres16-data`, não publicam a porta `5432` no host, restringem o backend a `127.0.0.1:8000` e não expõem o conteúdo de `~/.config/teamkitcollection/postgres16.env` em logs ou no Git.
2. **Condição para execução na VM:** As opções **7 (`check`)**, **8 (`up`)** e **9 (`fault`)** podem ser executadas com segurança quanto aos dados, **desde que** o operador observe as condições de contorno dos achados **[A-01]** e **[A-02]** (não há idempotência automática caso a opção 8 seja executada duas vezes seguidas, e qualquer retorno diferente de zero em subcomando encerra o loop do menu `teamkit-lab.sh`) ou autorize previamente o patch mínimo de 2 arquivos detalhado na Seção 5.

---

## 2. Classificação das Fontes e Evidências Consultadas

| Fonte / Objeto | Estado da Informação | Evidência / Observação |
|---|---|---|
| `IA/despachos/ordens/TKC-REQ-0009.md` e `IA/tarefas/TKC-0009.md` | `VERIFICADO` | Lidos diretamente de `origin/main` (`017b7c976f74ba48e4daa18b21c2b19951c2ee84`) |
| `scripts/infra/teamkit-lab.sh`, `scripts/infra/backend-lab.sh`, `scripts/infra/postgres16-lab.sh` | `VERIFICADO` | Código-fonte integral inspecionado na `main` (`017b7c976f74ba48e4daa18b21c2b19951c2ee84`) |
| `infra/docker/docker-compose.lab.yml` e `infra/docker/Dockerfile.backend` | `VERIFICADO` | Inspecionados na `main` e compatíveis com a revisão pinada `959745e5513e` |
| `src/backend/main.py`, `src/backend/db.py`, `src/backend/config.py`, `src/backend/requirements.txt` | `VERIFICADO` | Inspecionados na `main` |
| `IA/tarefas/TKC-0005.md`, `IA/tarefas/TKC-0007.md`, `IA/tarefas/TKC-0008.md` | `VERIFICADO` | Histórico, decisões, SHAs pinados e limites inspecionados na `main` |
| `docs/infraestrutura.md`, `docs/operacao.md`, `docs/testes.md` | `VERIFICADO` | Documentação de produto e operação da Fase B inspecionada na `main` |
| Ambiente da VM: Ubuntu 24.04.5, Docker 29.10.1, Compose v5.8.0, `tkc-postgres16` (PostgreSQL 16.16) `Up`, sem porta `5432` e persistência validada (`INSERT/RESTART/SELECT`) | `RELATADO` (`MEDIADO`) | Documentado em `IA/tarefas/TKC-0008.md` (C02); `AGT-003` não possui acesso SSH à VM |
| Execução real das opções 7, 8 e 9 na VM e testes automatizados `pytest` | `NÃO EXECUTADO` | Nenhuma ação operacional executada nesta etapa L0/L1 |

---

## 3. Achados Técnicos por Severidade (Opções 7, 8 e 9)

### Severidade ALTA (Impacto direto no fluxo operacional das Opções 7, 8 e 9)

#### [A-01] `teamkit-lab.sh` encerra abruptamente o menu interativo quando qualquer opção falha (`set -e` sem captura no loop do menu)
- **Arquivo / Linhas:** `scripts/infra/teamkit-lab.sh` (`run_existing()` linhas 60–64 e `menu()` linhas 136–146).
- **Análise técnica:** `teamkit-lab.sh` ativa `set -Eeuo pipefail`. No loop `while true` de `menu()`, a seleção das opções 1 a 9 chama `action ...` diretamente, sem proteção condicional (`if ! action ...; then ...`). Quando `run_existing` executa `bash "${TMP_DIR}/${script}" "$mode"` e o script filho retorna código `!= 0` (ex.: `backend-lab.sh` chamando `fail` porque o backend já existe, ou porque o usuário cancelou a confirmação `TESTAR`), o shell pai (`teamkit-lab.sh`) aborta imediatamente e dispara o `trap EXIT` com `[ERRO] Operação interrompida (código 1)`.
- **Consequência operacional:** O operador é expulso do menu a cada condição de bloqueio/aviso dos sub-scripts.
- **Correção mínima:** Em `menu()`, envolver o despacho em `if ! action ...; then info "Operação concluída com status != 0 (verifique as mensagens acima)."; fi`.

#### [A-02] Opção 8 (`backend-lab.sh up`) não é idempotente e trava reexecuções se o container `tkc_lab-backend-1` já existir
- **Arquivo / Linhas:** `scripts/infra/backend-lab.sh` (`up()` linhas 75–96).
- **Análise técnica:** As linhas 78–79 verificam:
  ```bash
  existing="$(sudo docker ps -a --filter name='^/tkc_lab-backend-1$' --format '{{.ID}}')"
  [[ -z "$existing" ]] || fail 'Backend já existe. Não recriar automaticamente; usar check.'
  ```
  Se o operador executar a Opção 8 uma vez (com sucesso ou com falha no `health` após o `compose up -d`), o container `tkc_lab-backend-1` passará a existir (`Up` ou `Exited`). Qualquer tentativa subsequente de rodar a Opção 8 abortará com `[BLOQUEADO] Backend já existe`, e o menu **não possui opção** para iniciar um container `tkc_lab-backend-1` parado ou convergir o serviço via Compose.
- **Consequência operacional:** Quebra a idempotência da Opção 8. Se o healthcheck inicial der timeout na primeira subida ou se a VM for reiniciada com o container em estado `Exited`, o operador não conseguirá recuperar o backend pelo menu.
- **Correção mínima:** Em `up()`, se `tkc_lab-backend-1` já existir e estiver `Running` + respondendo `HTTP 200` com `"database":"up"`, reportar `[OK] Backend já em execução e saudável (idempotente)` após garantir que a rede `tkc-lab-net` está conectada; se existir mas estiver parado ou não saudável, permitir que `compose up -d --build --no-deps backend` convirja o container da API (sem jamais tocar em `tkc-postgres16`).

---

### Severidade MÉDIA (Traps, Sinais, Diagnóstico Prévio e Pinagem de Revisões)

#### [M-01] Pré-checagem HTTP na Opção 9 (`fault`) não tolera erro do `curl` sob `set -e`
- **Arquivo / Linha:** `scripts/infra/backend-lab.sh` (`fault()` linha 115: `status="$(health)"`).
- **Análise técnica:** A função `health()` executa `curl --silent --show-error --max-time 7 ... http://127.0.0.1:8000/health`. Nos loops das linhas 92, 120 e 130, a chamada está protegida com `status="$(health 2>/dev/null || true)"`. Porém, na linha 115, foi escrito apenas `status="$(health)"`. Se o backend não estiver respondendo na porta 8000 no início da Opção 9, o `curl` retorna código `7` (Failed to connect) e o `set -e` aborta o script na linha 115 antes de exibir a mensagem explicativa da linha 116 (`fail "Antes do teste API não respondeu 200: $status"`).
- **Correção mínima:** Alterar a linha 115 para `status="$(health 2>/dev/null || true)"`.

#### [M-02] Vulnerabilidade a `SIGINT` (`Ctrl+C`) durante a janela de desconexão da Opção 9 (`fault`)
- **Arquivo / Linhas:** `scripts/infra/backend-lab.sh` (`cleanup()` linhas 21–35 e `fault()` linhas 117–128).
- **Análise técnica:** Entre `ATTEMPT_RECONNECT=1` (linha 117) e `ATTEMPT_RECONNECT=0` (linha 128), `tkc-postgres16` fica desconectado de `tkc-lab-net`. Se o operador pressionar `Ctrl+C` durante o loop de 5 segundos, o `trap cleanup EXIT` tenta executar `sudo docker network connect "$NET" "$DB" 2>/dev/null`. Contudo, um `SIGINT` no grupo de processos do terminal pode interromper o `sudo`/cliente Docker dentro do handler `EXIT`, e o redirecionamento `2>/dev/null` suprime a mensagem de erro real do Docker.
- **Mitigação presente:** O `cleanup()` ao menos imprime `[ATENÇÃO] Não consegui reconectar; executar: sudo docker network connect tkc-lab-net tkc-postgres16` e define `rc=1`.
- **Correção mínima:** Ignorar `SIGINT`/`SIGTERM` temporariamente (`trap '' INT TERM`) apenas durante o bloco crítico de ~5s entre `docker network disconnect` e `docker network connect`, restaurando `trap - INT TERM` logo após `ATTEMPT_RECONNECT=0`.

#### [M-03] Opção 7 (`check`) não valida o modo `0600` do `postgres16.env` nem a conexão de rede/HTTP existente
- **Arquivo / Linhas:** `scripts/infra/backend-lab.sh` (`check()` linhas 46–56).
- **Análise técnica:**
  1. `check()` valida apenas `[[ -f "$ENV_PATH" ]]`, mas `up()` exige `[[ "$(stat -c %a "$ENV_PATH")" == 600 ]]`. Se as permissões de `~/.config/teamkitcollection/postgres16.env` estiverem incorretas, a Opção 7 reporta `[OK]`, mas a Opção 8 falha.
  2. `check()` não informa se `tkc-postgres16` já está conectado à rede `tkc-lab-net` nem faz sonda HTTP em `http://127.0.0.1:8000/health` quando `tkc_lab-backend-1` está ativo.
- **Correção mínima:** Adicionar em `check()` a verificação de `stat -c %a "$ENV_PATH"`, a verificação de associação de `tkc-postgres16` à rede `tkc-lab-net` e, caso `tkc_lab-backend-1` esteja `Up`, exibir o resultado de `/health`.

#### [M-04] Mensagem de ajuda CLI de `teamkit-lab.sh` omite os comandos `backend-*` e encadeia SHAs fixos
- **Arquivo / Linhas:** `scripts/infra/teamkit-lab.sh` (linha 9 e linha 152).
- **Análise técnica:**
  1. A linha 152 (`die 'Uso: bash teamkit-lab.sh [menu|status|docker-check|docker-install|pg-check|pg-start|persist]'`) omite `backend-check|backend-up|backend-fault`, embora a função `action()` (linhas 115–117) os aceite.
  2. Como `teamkit-lab.sh` baixa `backend-lab.sh` do commit fixo `BACKEND_REV="e40bd9261f21b4e611e028f89d069530fdf3ae7a"`, qualquer atualização em `backend-lab.sh` exige atualizar `BACKEND_REV` em `teamkit-lab.sh` e rebaixar `teamkit-lab.sh` na VM.

---

### Severidade BAIXA (Avaliação de Segurança, Docker, Rede e FastAPI)

#### [B-01] Avaliação de Privilégios Docker, Secrets e Não Recriação do PostgreSQL (`APROVADO`)
- **Privilégios e isolamento:** `Dockerfile.backend` cria e utiliza usuário não-root (`uid 10001`, `/usr/sbin/nologin`); `docker-compose.lab.yml` aplica `security_opt: [no-new-privileges:true]`, `mem_limit: 512m`, `cpus: 1.0` e bind estrito em `127.0.0.1:8000:8000`.
- **Proteção de secrets:** `TKC_PG_ENV_FILE` aponta para `~/.config/teamkitcollection/postgres16.env` (fora do diretório de build e fora do Git). `compose config --quiet` valida a sintaxe do Compose sem imprimir variáveis de ambiente no terminal.
- **Preservação de `tkc-postgres16`:** O Compose define **exclusivamente** o serviço `backend` e a rede externa `tkc-lab-net`. O comando `compose up -d --build --no-deps backend` e o `docker network connect tkc-lab-net tkc-postgres16` operam a quente, sem reiniciar, recriar ou expor a porta `5432` do PostgreSQL.

#### [B-02] Comportamento da API FastAPI e Driver `psycopg` durante Falha e Restauração (`APROVADO`)
- **Mecanismo:** `src/backend/main.py` define `def health():` (função síncrona executada pelo FastAPI em threadpool externa ao event loop) que chama `check_database()` em `src/backend/db.py`.
- **Durante o corte (`docker network disconnect`):** `psycopg.connect` possui `connect_timeout=3` e `statement_timeout=3000`. Sem rota/DNS na bridge `tkc-lab-net`, a conexão falha imediatamente (ou em no máximo 3s), entra em `except Exception:` e retorna `HTTP 503` com `{"status": "unhealthy", "database": "down", "error": "DB_UNAVAILABLE"}`, sem vazar stacktrace, IP, usuário ou senha.
- **Na restauração (`docker network connect`):** Como não há pool de conexões mantendo sockets mortos em cache, a primeira requisição após `docker network connect` abre nova conexão TCP na bridge `tkc-lab-net`, executa `SELECT 1` e retorna `HTTP 200` com `{"status": "ok", "database": "up"}` sem reiniciar nenhum container.

#### [B-03] Imagem Base Python sem Digest SHA-256 e `requirements.txt` sem Lockfile
- **Análise:** `Dockerfile.backend` usa `FROM python:3.12-slim` (sem `@sha256:...`) e `requirements.txt` usa faixas (`fastapi>=0.115,<1`, etc.). Como o build da Fase B ocorre apenas localmente na VM de laboratório sem dados reais e a custo zero, este item **não bloqueia** o teste da Fase B (já ressalvado em `TKC-0005`), devendo ser endereçado antes de qualquer ambiente compartilhado/produção.

---

## 4. Testes Estáticos (sem Docker) vs. Testes Operacionais na VM

| Categoria | Teste / Verificação | Onde pode rodar | Estado Atual |
|---|---|---|---|
| **Estático (sem Docker)** | Inspeção de ausência de comandos destrutivos (`rm`, `down -v`, `volume rm`), preservação de `5432` fechada e `127.0.0.1:8000` | Qualquer ambiente / Revisão L0 | `VERIFICADO` por `AGT-003` |
| **Estático (sem Docker)** | Inspeção de não exposição de `postgres16.env` em `stdout`/logs e tratamento de erro 503 sem vazamento de DSN | Qualquer ambiente / Revisão L0 | `VERIFICADO` por `AGT-003` |
| **Estático (sem Docker)** | Checagem sintática Bash: `bash -n scripts/infra/teamkit-lab.sh scripts/infra/backend-lab.sh` | Ambiente com `bash` (sem Docker) | `VERIFICADO` (`bash -n` sem erros) |
| **Estático (sem Docker)** | Testes unitários da API com mocks (`pytest -q tests/backend/test_health.py` para `200`, `503` e recuperação) | Ambiente Python com `fastapi`, `psycopg`, `httpx`, `pytest` (sem Docker) | `NÃO EXECUTADO` (sandbox sem `pytest` instalado) |
| **Operacional (exige VM)** | **Opção 7 (`backend-check`):** Validar daemon Docker, container `tkc-postgres16` `Running`, porta vazia, volume `tkc-postgres16-data`, `pg_isready` e existência de `postgres16.env` | Exclusivamente na VM Ubuntu `Container` | `NÃO EXECUTADO` |
| **Operacional (exige VM)** | **Opção 8 (`backend-up`):** Criar `tkc-lab-net`, anexar `tkc-postgres16` a quente, buildar `teamkitcollection/backend:lab`, subir `tkc_lab-backend-1` e confirmar `GET /health` -> `200` (`"database":"up"`) | Exclusivamente na VM Ubuntu `Container` | `NÃO EXECUTADO` |
| **Operacional (exige VM)** | **Opção 9 (`backend-fault`):** Confirmar `TESTAR`, desconectar `tkc-postgres16` de `tkc-lab-net`, validar `HTTP 503` (`DB_UNAVAILABLE`), reconectar e validar retorno a `HTTP 200` | Exclusivamente na VM Ubuntu `Container` | `NÃO EXECUTADO` |

---

## 5. Proposta de Menor Correção Possível (Opcional Antes do Teste ou Pós-Primeiro Ciclo)

Caso `AGT-001` e `HUMAN-001` optem por corrigir os achados **[A-01]**, **[A-02]**, **[M-01]**, **[M-02]**, **[M-03]** e **[M-04]** antes da execução na VM, os únicos arquivos de código a alterar (sob nova autorização L2 específica) são:

1. **`scripts/infra/backend-lab.sh`**:
   - Em `check()`: validar `[[ "$(stat -c %a "$ENV_PATH")" == 600 ]]`; checar se `tkc-postgres16` já integra `tkc-lab-net`; se `tkc_lab-backend-1` estiver `Up`, consultar `/health` informativamente.
   - Em `up()`: substituir o bloqueio fatal quando `tkc_lab-backend-1` já existe por convergência idempotente (`compose up -d --build --no-deps backend` + validação `/health` `200`), mantendo intocado o `tkc-postgres16`.
   - Em `fault()`: alterar linha 115 para `status="$(health 2>/dev/null || true)"` e proteger o trecho entre `ATTEMPT_RECONNECT=1` e `ATTEMPT_RECONNECT=0` com `trap '' INT TERM`.
2. **`scripts/infra/teamkit-lab.sh`**:
   - Atualizar `BACKEND_REV` para o novo commit SHA de `scripts/infra/backend-lab.sh`.
   - Em `menu()`: proteger chamadas com `if ! action ...; then info "Ação finalizada com alerta/erro."; fi` para não derrubar o menu interativo.
   - Em `main()`: atualizar string de `Uso:` incluindo `backend-check|backend-up|backend-fault`.

---

## 6. Roteiro Seguro da Primeira Execução na VM e Rollback Sem Exclusões

Se `HUMAN-001` decidir executar imediatamente as Opções 7, 8 e 9 na VM com os scripts já publicados em `main` (`abf054f83d36ff15afdf4b44f72aa02bb5d15611`), seguir este roteiro:

### 6.1. Roteiro Passo a Passo (para `HUMAN-001` na VM Ubuntu `Container`)
1. **Baixar a versão atualizada do menu (`teamkit-lab.sh` do commit `abf054f83d36ff15afdf4b44f72aa02bb5d15611`):**
   ```bash
   curl -fsSL https://raw.githubusercontent.com/edinhogrubert/TeamKitCollection/abf054f83d36ff15afdf4b44f72aa02bb5d15611/scripts/infra/teamkit-lab.sh -o teamkit-lab.sh
   bash -n teamkit-lab.sh
   ```
2. **Pré-verificação de permissão do arquivo de credenciais (evita falha na Opção 8):**
   ```bash
   stat -c '%a %U:%G %n' "${XDG_CONFIG_HOME:-$HOME/.config}/teamkitcollection/postgres16.env"
   ```
   *(Deve exibir `600` e pertencer ao usuário da VM; o comando acima não exibe o conteúdo do arquivo).*
3. **Executar Opção 7 (`Diagnosticar API e PostgreSQL`):**
   - Rodar `bash teamkit-lab.sh` e escolher `7`.
   - Confirmar: `Docker Engine: 29.10.1`, `accepting connections`, `[OK] Credenciais locais presentes` e `Nenhuma alteração realizada no check.`
4. **Executar Opção 8 (`Preparar rede e iniciar backend /health`):**
   - No menu, escolher `8` (uma única vez).
   - Confirmar: `[OK] Rede interna criada: tkc-lab-net`, `[OK] Banco conectado à nova rede privada, sem recriação`, build da imagem do backend, `[OK] GET /health retornou HTTP 200; consulta PostgreSQL realizada` e `[OK] Backend publicado somente em 127.0.0.1:8000`.
5. **Executar Opção 9 (`Testar HTTP 503 e recuperação 200`):**
   - No menu, escolher `9`, digitar `TESTAR` e aguardar a conclusão (~5 segundos) **sem pressionar `Ctrl+C`**.
   - Confirmar: `[OK] Falha induzida: HTTP 503 e DB_UNAVAILABLE.` seguido de `[OK] Recuperação: HTTP 200 sem reiniciar backend nem PostgreSQL.`
6. **Coletar evidência sanitizada para retorno:**
   - Copiar a saída das opções `7`, `8`, `9` e o comando:
     ```bash
     sudo docker ps -a --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'
     ```

### 6.2. Rollback Seguro (Sem Exclusão de Dados, Volumes ou Containers do Banco)
Em caso de falha durante a Opção 8 ou Opção 9:
1. **Garantir reconexão do PostgreSQL à rede do laboratório (seguro e idempotente):**
   ```bash
   sudo docker network connect tkc-lab-net tkc-postgres16 2>/dev/null || true
   ```
2. **Inspecionar logs da API (sem expor `postgres16.env`):**
   ```bash
   sudo docker logs --tail 50 tkc_lab-backend-1
   ```
3. **Parar apenas o container da API caso necessário:**
   ```bash
   sudo docker stop tkc_lab-backend-1 2>/dev/null || true
   ```
   *(Nota: se for necessário reexecutar a Opção 8 com o `backend-lab.sh` atual sem patch, será preciso remover apenas o container efêmero da API com `sudo docker rm tkc_lab-backend-1`. **Jamais** executar `docker rm` em `tkc-postgres16`, `docker volume rm` ou `docker compose down -v`).*
4. **Confirmar que o PostgreSQL e o volume permanecem íntegros:**
   ```bash
   sudo docker exec tkc-postgres16 pg_isready -U tkc_app -d teamkitcollection
   sudo docker port tkc-postgres16
   ```

---

## 7. Limitações e Próximo Passo
- **Limitações:** Este parecer baseia-se na inspeção estática (`L0/L1`) dos arquivos versionados em `main` (`017b7c976f74ba48e4daa18b21c2b19951c2ee84`). `AGT-003` não possui acesso direto à VM Ubuntu do operador nem executou containers ou testes de rede.
- **Próximo responsável:** `AGT-001` e `HUMAN-001` (revisão técnica deste parecer `TKC-PAR-0009` e decisão entre autorizar o patch mínimo da Seção 5 em `TKC-AUT-0009` ou executar diretamente o roteiro da Seção 6 na VM).
