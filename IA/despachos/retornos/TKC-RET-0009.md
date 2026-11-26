# TKC-RET-0009 — Retorno da Execução L2 DevOps (Patch Estático dos Scripts de Laboratório)

## 1. Identificação
- **task_id:** `TKC-0009`
- **order_id / ref curta:** `TKC-AUT-0009`
- **return_id:** `TKC-RET-0009`
- **tipo:** `EXECUCAO L2` (alteração estática de scripts de infraestrutura e registros de comunicação; **zero execução Docker**)
- **claim_id:** `TKC-0009-C04` (confirmada no remoto em `bb277a7103eae8a589343c11110a6220edee18a0` antes da edição dos scripts)
- **agent_id / papel / ferramenta:** `AGT-003` — Engenheiro DevOps/SRE | Google AI Studio (`gemini-4-argon`)
- **origem da ordem / evidência da autorização:** `IA/despachos/ordens/TKC-AUT-0009.md` (`8ea6ad47729b2d6d703a5c9fcc1b70c3a33fb6ca`) + instrução humana `TKC-AUT-0009 #TRUE` (`MEDIADO`)
- **repositório / branch:** `edinhogrubert/TeamKitCollection` | `main`
- **base_commit:** `8ea6ad47729b2d6d703a5c9fcc1b70c3a33fb6ca`
- **claim_commit:** `bb277a7103eae8a589343c11110a6220edee18a0`
- **backend_lab_commit (pinado em `BACKEND_REV`):** `8d0cfa789f055f139c8f6efc06fe59f7ca71be8d`
- **estado de saída:** `ENTREGUE` (aguardando revisão independente por `AGT-001` e aceite/execução na VM por `HUMAN-001`)

---

## 2. Verificação Estática do Risco Adicional (`POSTGRES_*` entre `postgres16-lab.sh`, Compose e `config.py`)

Conforme exigido em `TKC-AUT-0009`, foi realizada a verificação cruzada estática das variáveis de ambiente geradas e consumidas (`VERIFICADO`):

| Variável | Gerada por `scripts/infra/postgres16-lab.sh` (`~/.config/teamkitcollection/postgres16.env`) | Definida em `infra/docker/docker-compose.lab.yml` | Lida por `src/backend/config.py` (`database_config()`) | Compatibilidade |
|---|---|---|---|---|
| `POSTGRES_USER` | `POSTGRES_USER=tkc_app` (linha 102) | Via `env_file: ${TKC_PG_ENV_FILE}` | `os.environ.get("POSTGRES_USER", "tkc_app")` | **100% Compatível** |
| `POSTGRES_DB` | `POSTGRES_DB=teamkitcollection` (linha 103) | Via `env_file: ${TKC_PG_ENV_FILE}` | `os.environ.get("POSTGRES_DB", "teamkitcollection")` | **100% Compatível** |
| `POSTGRES_PASSWORD` | `POSTGRES_PASSWORD=<hex>` (linha 104) | Via `env_file: ${TKC_PG_ENV_FILE}` | `os.environ["POSTGRES_PASSWORD"]` | **100% Compatível** |
| `POSTGRES_HOST` | Não gravada no `.env` | `environment: POSTGRES_HOST: tkc-postgres16` | `os.environ.get("POSTGRES_HOST", "tkc-postgres16")` | **100% Compatível** |
| `POSTGRES_PORT` | Não gravada no `.env` | `environment: POSTGRES_PORT: "5432"` | `int(os.environ.get("POSTGRES_PORT", "5432"))` | **100% Compatível** |

- **Conclusão da verificação:** O arquivo `postgres16.env` gerado por `postgres16-lab.sh` é **totalmente compatível** com `backend-lab.sh`, `docker-compose.lab.yml` e `src/backend/config.py`. Nenhum arquivo fora dos dois scripts autorizados precisou ser modificado.

---

## 3. Resumo das Alterações Implementadas (`[A-01]`, `[A-02]`, `[M-01]`–`[M-04]`)

### 3.1. `scripts/infra/backend-lab.sh` (Commit `8d0cfa789f055f139c8f6efc06fe59f7ca71be8d`)
1. **[A-02] Idempotência e recuperação não destrutiva em `up()`:**
   - Garante criação da rede `tkc-lab-net` e conexão do container `tkc-postgres16` antes de avaliar o backend.
   - Se `tkc_lab-backend-1` já existir:
     - Verifica o label `com.docker.compose.project` (bloqueia por segurança se pertencer a outro projeto diferente de `tkc_lab`).
     - Se estiver `Running` e `GET /health` retornar `HTTP 200` com `"database":"up"`, reporta `[OK] Backend já está em execução e saudável` e encerra com código `0` sem rebuild/recriação.
     - Se estiver parado (`Exited`), executa `sudo docker start tkc_lab-backend-1` e aguarda `/health` `200`; caso não convirja apenas com `start` ou esteja `Running` porém degradado, baixa o código da revisão imutável `959745e5513e313e477ef9cdd734111af2b9768f` e executa `compose up -d --build --no-deps backend` (que atua **somente** sobre a API, sem tocar em `tkc-postgres16` nem em volumes).
2. **[M-01] Preflight resiliente em `fault()`:**
   - Inicializa diretório temporário via `ensure_tmp()` e executa `status="$(health 2>/dev/null || true)"`, evitando queda silenciosa por `set -e` caso o `curl` retorne erro de conexão, além de validar `"database":"up"` antes de desconectar a rede.
3. **[M-02] Resiliência a sinais (`SIGINT`/`SIGTERM`) e reconexão em `cleanup()` e `fault()`:**
   - Adicionados handlers `trap 'on_signal SIGINT' INT` e `trap 'on_signal SIGTERM' TERM`, além de `trap '' INT TERM` durante a janela crítica de ~5s em que `ATTEMPT_RECONNECT=1` está ativo em `fault()`, restaurando os traps logo após `ATTEMPT_RECONNECT=0`.
   - Em `cleanup()`, ignora sinais adicionais durante a reconexão, captura a mensagem de erro caso `docker network connect` falhe, verifica se `tkc-postgres16` já está conectado à `tkc-lab-net` e exibe instrução explícita ao operador. Documentado no aviso da opção 9 que `SIGKILL` ou queda de energia da VM não podem ser interceptados por trap em userspace.
4. **[M-03] Diagnóstico aprimorado em `check()`:**
   - Valida que `~/.config/teamkitcollection/postgres16.env` existe **e** está em modo `0600` (`stat -c %a`), sem ler nem exibir seu conteúdo.
   - Verifica e informa se `tkc-postgres16` já está conectado à bridge `tkc-lab-net`.
   - Se `tkc_lab-backend-1` existir e estiver `Running`, realiza sonda passiva em `http://127.0.0.1:8000/health` informando se respondeu `HTTP 200 (database: up)` ou estado pendente.

### 3.2. `scripts/infra/teamkit-lab.sh` (Commit final desta entrega)
1. **[A-01] Isolamento de falhas no loop interativo `menu()`:**
   - Criada a função `run_menu_action()`, que executa `( action "$act" )` em subshell controlado dentro de `if ...; then ... else ...; fi`. Quando qualquer opção (1 a 9) retorna código `!= 0`, o menu exibe `[ATENÇÃO] Ação "<opção>" finalizou com código <rc>. O menu permanece ativo para diagnóstico.` e retorna ao menu principal sem encerrar `teamkit-lab.sh`.
   - Execuções diretas via CLI (`bash teamkit-lab.sh backend-check`, etc.) continuam propagando o código de saída real (`!= 0`) para automações.
2. **[M-04] Atualização do SHA imutável `BACKEND_REV` e help CLI:**
   - `BACKEND_REV` atualizado de `e40bd9261f21b4e611e028f89d069530fdf3ae7a` para `8d0cfa789f055f139c8f6efc06fe59f7ca71be8d` (commit imutável do `backend-lab.sh` recém-publicado na `main`).
   - Mensagem de uso em `main()` atualizada para `[menu|status|docker-check|docker-install|pg-check|pg-start|persist|backend-check|backend-up|backend-fault]`.

---

## 4. Arquivos Alterados e Commits

| Arquivo | Escopo em `TKC-AUT-0009` | Tipo de alteração | Commit |
|---|---|---|---|
| `IA/tarefas/TKC-0009.md` | `communication_paths` | Reivindicação `TKC-0009-C04` e encerramento `EM_REVISAO` | `bb277a7103eae8a589343c11110a6220edee18a0` + commit final |
| `IA/tarefas/indice.md` | `communication_paths` | Atualização de posse `TKC-0009-C04` e retorno a `EM_REVISAO` | `bb277a7103eae8a589343c11110a6220edee18a0` + commit final |
| `IA/despachos/logs/TKC-EXE-0009.md` | `communication_paths` | Log de eventos da tentativa `TKC-0009-C04` | `bb277a7103eae8a589343c11110a6220edee18a0` + commit final |
| `scripts/infra/backend-lab.sh` | `product_paths` | Correções `[A-02]`, `[M-01]`, `[M-02]`, `[M-03]` | `8d0cfa789f055f139c8f6efc06fe59f7ca71be8d` |
| `scripts/infra/teamkit-lab.sh` | `product_paths` | Correções `[A-01]`, `[M-04]` (`BACKEND_REV="8d0cfa78..."`) | Commit final desta entrega |
| `IA/despachos/retornos/TKC-RET-0009.md` | `communication_paths` | Relatório formal de retorno da execução L2 | Commit final desta entrega |

*(Nenhum outro arquivo do repositório foi modificado).*

---

## 5. Verificações e Testes Executados vs. Não Executados

### 5.1. Testes Estáticos Executados (`VERIFICADO`)
1. **Validação sintática Bash (`bash -n`):**
   - Comando: `bash -n scripts/infra/backend-lab.sh && bash -n scripts/infra/teamkit-lab.sh`
   - Resultado: `PASS` (exit code `0`, zero erros sintáticos).
2. **Teste de argumentos inválidos e help CLI (sem invocar Docker):**
   - `bash scripts/infra/backend-lab.sh invalid-arg` -> `exit 2` (`Uso: bash backend-lab.sh [check|up|fault]`).
   - `bash scripts/infra/teamkit-lab.sh arg1 arg2` -> `exit 1` (`[BLOQUEADO] Uso: bash teamkit-lab.sh [menu|status|docker-check|docker-install|pg-check|pg-start|persist|backend-check|backend-up|backend-fault]`).
3. **Teste de resiliência do menu interativo e download por SHA pinado (`[A-01]` e `[M-04]`):**
   - Comando: `printf "7\n0\n" | bash scripts/infra/teamkit-lab.sh menu`
   - Resultado: `PASS` — `teamkit-lab.sh` baixou `backend-lab.sh` do commit pinado `8d0cfa789f05` via HTTPS, validou `bash -n`, executou a opção 7 (que retornou código `1` por ausência de Docker no sandbox do AI Studio), **capturou o erro sem fechar o menu** (`[ATENÇÃO] Ação "backend-check" finalizou com código 1. O menu permanece ativo para diagnóstico.`), reexibiu o menu e encerrou limpo na opção `0` (`[OK] Menu encerrado.`).
4. **Inspeção estática de segurança e preservação de dados:**
   - Ausência de `docker rm`, `docker volume rm`, `docker compose down -v` ou publicação de `5432`: `VERIFICADO`.

### 5.2. Testes Operacionais (`NÃO_EXECUTADOS`)
- **Execução Docker / Compose / Rede / HTTP (`opções 7, 8 e 9` na VM Ubuntu `Container`):** `NÃO_EXECUTADOS`, em cumprimento estrito à proibição de `TKC-AUT-0009`.

---

## 6. Limitações, Rollback e Próximo Passo Recomendado

- **Limitações:**
  1. Os testes realizados por `AGT-003` são exclusivamente estáticos e de fluxo de menu sem daemon Docker. A validação real de criação da bridge `tkc-lab-net`, build da imagem do backend e ciclo `HTTP 200 -> 503 -> 200` depende de execução na VM Ubuntu `Container` pelo operador `HUMAN-001`.
  2. Em caso de `SIGKILL` (`kill -9`), queda de energia da VM ou falha do daemon Docker durante os ~5 segundos do teste da opção 9, nenhum trap em userspace consegue executar; nesse cenário, a reconexão manual permanece `sudo docker network connect tkc-lab-net tkc-postgres16`.
- **Próximo responsável e ação recomendada:**
  1. **`AGT-001`:** Realizar a revisão técnica independente dos commits `8d0cfa789f055f139c8f6efc06fe59f7ca71be8d` e do commit final desta entrega (`TKC-RET-0009`).
  2. **`HUMAN-001` (após revisão de `AGT-001`):** Na VM Ubuntu `Container`, baixar o `scripts/infra/teamkit-lab.sh` atualizado da `main` e executar as opções **7 (`check`)**, **8 (`up`)** e **9 (`fault`)**, trazendo a saída sanitizada do terminal para validação.
