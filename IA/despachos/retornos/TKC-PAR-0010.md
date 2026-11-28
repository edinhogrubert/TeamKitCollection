# TKC-PAR-0010 — Parecer Técnico DevOps/SRE sobre Supressão de `errexit` (`set -e`) em `run_menu_action`

| Campo | Valor |
|---|---|
| `message_id / return_id` | `TKC-PAR-0010` |
| `reply_to / order_id` | `TKC-REQ-0010` |
| `task_id` | `TKC-0010` |
| `claim_id` | `TKC-0010-C02` (reivindicação confirmada no remoto em `58ba14c1da10abf95d241851f0f6b7fcda43b56d`) |
| `from_role / author` | `AGT-003` — Engenheiro DevOps/SRE (Sessão Gemini no Google AI Studio) |
| `to_role` | `AGT-001` e `HUMAN-001` |
| `created_at` | `2026-11-27` |
| `base_commit` | `5bb6ea624c342fbfa7bd9772411b0ca30ad25c3c` (revalidado a partir da base da REQ `90a09e6aa85f5b3d22fa6242d929ac78ea0f95bf`) |
| `claim_commit` | `58ba14c1da10abf95d241851f0f6b7fcda43b56d` |
| `rules_checked_commit` | `5bb6ea624c342fbfa7bd9772411b0ca30ad25c3c` |
| `sources_verified` | `IA/despachos/ordens/TKC-REQ-0010.md`, `IA/tarefas/TKC-0010.md`, `scripts/infra/teamkit-lab.sh`, `IA/despachos/retornos/TKC-RET-0009.md` (`VERIFICADO`) |
| `max_action_level` | `L0/L1` para análise técnica e testes sintéticos (zero alterações em scripts, código, Docker ou VM); `L2` restrito exclusivamente aos arquivos de comunicação autorizados (`IA/despachos/retornos/TKC-PAR-0010.md`, `IA/tarefas/TKC-0010.md`, `IA/tarefas/indice.md`) |
| `authorization_state / provenance` | `TRUE` exclusivamente para publicação documental deste parecer e atualização de posse (`MEDIADO` via `HUMAN-001`) |
| `finding_verdict` | **`CONFIRMADO`** |

---

## 1. Classificação Final e Diagnóstico do Risco de `errexit` em `run_menu_action()`

**Classificação Final:** **`CONFIRMADO`**

O achado apontado por `AGT-001` sobre a entrega `TKC-0009-C04` (`90a09e6aa85f5b3d22fa6242d929ac78ea0f95bf`) é **integralmente confirmado**.

1. **Causa raiz no GNU Bash / POSIX (`errexit` em contextos condicionais):**
   No arquivo `scripts/infra/teamkit-lab.sh` (linhas 134–143), `run_menu_action()` foi escrita como:
   ```bash
   run_menu_action() {
     local act="$1" rc=0
     if ( action "$act" ); then
       return 0
     else
       rc=$?
       printf '[ATENÇÃO] Ação "%s" finalizou com código %s. O menu permanece ativo para diagnóstico.\n' "$act" "$rc" >&2
       return 0
     fi
   }
   ```
   Segundo a especificação POSIX e o manual do GNU Bash para `set -e` (`errexit`), **o shell desativa `set -e` (e `trap ERR`) dentro de qualquer comando composto, subshell `( ... )` ou função cuja execução faça parte da condição de teste de um `if`, `while`, `until`, `&&` ou `||`**.
2. **Efeito real:**
   Quando `( action "$act" )` é avaliado diretamente na condição `if ( action "$act" ); then`, o subshell herda o contexto condicional do `if`. Com isso, **`set -e` fica completamente ignorado dentro de `action()` e de todas as funções Bash chamadas por ela no mesmo processo interpretador**.
   - Se uma linha interna falhar (retornar `!= 0`) e **não** tiver um `|| die ...` explícito (chamando `exit 1`), o Bash **não aborta** a função: ele continua executando os comandos seguintes da função.
   - Se o último comando da função retornar `0` (por exemplo, um `ok "..."` ou `info "..."`), a função inteira retorna `0`, mascarando a falha como sucesso.

---

## 2. Resultado do Teste Sintético Bash e Evidências (Sem Docker — `VERIFICADO`)

Os testes abaixo foram executados no container Linux (`GNU bash, version 5.2.15(1)-release (x86_64-pc-linux-gnu)`) exclusivamente com funções sintéticas em memória, sem tocar no Docker ou nos arquivos do projeto.

### 2.1. Teste Sintético 1 — Reprodução da Falha no Padrão Atual `if ( action "$act" ); then`

**Comando executado:**
```bash
bash -c '
set -Eeuo pipefail
inner_step() {
  echo "  [inner_step] starting"
  false
  echo "  [inner_step] UNSAFE_CONTINUED_AFTER_FALSE"
}
action() {
  inner_step
  echo "  [action] UNSAFE_CONTINUED_IN_ACTION"
}
if ( action ); then
  echo "RESULT: if-branch (exit 0) - ERROR WAS MASKED!"
else
  echo "RESULT: else-branch (exit $?)"
fi
'
```

**Saída literal obtida (`VERIFICADO`):**
```text
  [inner_step] starting
  [inner_step] UNSAFE_CONTINUED_AFTER_FALSE
  [action] UNSAFE_CONTINUED_IN_ACTION
RESULT: if-branch (exit 0) - ERROR WAS MASKED!
```

**Evidência:** Mesmo com `set -Eeuo pipefail` ativo, a falha (`false`) dentro de `inner_step` foi ignorada, os comandos seguintes (`UNSAFE_CONTINUED_AFTER_FALSE` e `UNSAFE_CONTINUED_IN_ACTION`) foram executados, e o `if` avaliou a ação como sucesso (`exit 0`).

### 2.2. Teste Sintético 2 — Demonstração da Correção com Subshell Fora de Contexto Condicional (`set +e; ( set -Eeuo pipefail; action "$act" ); rc=$?; set -e`)

**Comando executado:**
```bash
bash -c '
set -Eeuo pipefail
inner_step() {
  echo "  [inner_step] starting"
  false
  echo "  [inner_step] UNSAFE_CONTINUED_AFTER_FALSE"
}
action() {
  inner_step
  echo "  [action] UNSAFE_CONTINUED_IN_ACTION"
}
run_menu_action_fixed() {
  local rc=0
  set +e
  (
    set -Eeuo pipefail
    action
  )
  rc=$?
  set -e
  if (( rc != 0 )); then
    printf "[ATENÇÃO] Ação finalizou com código %s. O menu permanece ativo.\n" "$rc"
  fi
}
run_menu_action_fixed
echo "MENU_LOOP_STILL_ALIVE"
'
```

**Saída literal obtida (`VERIFICADO`):**
```text
  [inner_step] starting
[ATENÇÃO] Ação finalizou com código 1. O menu permanece ativo.
MENU_LOOP_STILL_ALIVE
```

**Evidência:** Quando o subshell `( set -Eeuo pipefail; action "$act" )` é executado **fora** de `if`/`||`/`&&` (usando `set +e` no shell pai apenas para aguardar o término do subshell), o Bash preserva `errexit` integralmente dentro do subshell: a execução abortou imediatamente no `false` (nenhum `UNSAFE_CONTINUED` foi executado), retornou `rc=1` e o loop do menu continuou vivo (`MENU_LOOP_STILL_ALIVE`).

---

## 3. Caminhos Afetados e Proposta Mínima de Correção

### 3.1. Inspeção dos Caminhos em `scripts/infra/teamkit-lab.sh` (`90a09e6`)

1. **`persist` (Opção 6 — Linhas 83–111) — RISCO ALTO (Operação Modificadora no Mesmo Processo Bash):**
   - `persist()` roda como função Bash diretamente dentro do subshell de `teamkit-lab.sh`.
   - As linhas 22 (`sudo -v` dentro de `require_sudo`), 94 (`token="tkc-$(openssl rand -hex 16)"`), 95 (`pg_sql 'CREATE TABLE ...'`), 96 (`pg_sql "INSERT INTO ..."`), 97 (`before="$(pg_sql ...)"`), 101 (`sudo docker restart "$PG_NAME"`) e 107 (`after="$(pg_sql ...)"`) **não possuem `|| die`** porque foram escritas assumindo que `set -e` abortaria imediatamente em caso de erro.
   - Com o `if ( action "$act" ); then` atual, se `sudo -v` falhar, ou se `CREATE TABLE` / `INSERT` falharem antes do `before`, a função **não aborta na linha da falha** e continua executando as etapas seguintes (podendo inclusive reiniciar `tkc-postgres16` na linha 101 se a falha ocorrer após o check `before`, ou falhar apenas adiante com mensagem enganosa).
2. **`fetch_script` / `run_existing` (Pré-etapa de `docker-install`, `pg-start`, `backend-up`, `backend-fault` e `*-check` — Linhas 23–34 e 60–64) — RISCO ALTO:**
   - `fetch_script()` roda como função Bash no subshell de `teamkit-lab.sh` antes de invocar o novo processo `bash "${TMP_DIR}/${script}" "$mode"`.
   - Nas linhas 30–31, o download `curl --fail --silent --show-error --location --proto '=https' --tlsv1.2 ... -o "${TMP_DIR}/${name}"` **não possui `|| die`**.
   - Com `errexit` suprimido pelo `if ( action "$act" )`, se o `curl` falhar, `fetch_script` **continua** para a linha 32 (`bash -n "${TMP_DIR}/${name}" || die ...`). Se houver um arquivo vazio ou residual em `${TMP_DIR}/${name}`, `bash -n` retorna `0` (arquivo vazio tem sintaxe válida em Bash) e a linha 63 executa um script vazio que retorna `0`, mascarando a falha de download como sucesso!
3. **Execução Interna dos Scripts Filhos (`docker-install`, `pg-start`, `backend-up`, `backend-fault` após o download) — RISCO MITIGADO PELO `execve` DO FILHO:**
   - Na linha 63 (`bash "${TMP_DIR}/${script}" "$mode"`), `teamkit-lab.sh` cria um **novo processo Sistema Operacional (`bash`)**. Dentro desse novo processo, o estado condicional do `if` do processo pai não existe, portanto o `set -Eeuo pipefail` interno de `backend-lab.sh`, `postgres16-lab.sh` e `install-docker-ubuntu.sh` funciona normalmente. O problema está concentrado em `teamkit-lab.sh` (em `run_menu_action`, `fetch_script`, `persist` e `status`).
4. **`status` (Opção 1 — Linhas 36–58) — RISCO BAIXO:**
   - Roda como função Bash interna; falhas intermediárias não tratadas prosseguem até o fim da função e retornam `0`.

### 3.2. Proposta Mínima de Correção

- **Arquivos que precisam de alteração (quando autorizado em `L2`):**
  - **Código de infraestrutura:** **Exclusivamente `scripts/infra/teamkit-lab.sh`** (nenhuma alteração é necessária em `scripts/infra/backend-lab.sh`, mantendo intocado o `BACKEND_REV="8d0cfa789f055f139c8f6efc06fe59f7ca71be8d"`).
  - **Registros de comunicação (quando autorizado em L2):** `IA/tarefas/TKC-0010.md`, `IA/tarefas/indice.md`, `IA/despachos/logs/TKC-EXE-0010.md` e `IA/despachos/retornos/TKC-RET-0010.md`.

- **Alteração exata recomendada em `scripts/infra/teamkit-lab.sh`:**
  1. Em **`run_menu_action()`** (substituir `if ( action "$act" ); then` por subshell fora de condição):
     ```bash
     run_menu_action() {
       local act="$1" rc=0
       set +e
       (
         set -Eeuo pipefail
         action "$act"
       )
       rc=$?
       set -e
       if (( rc != 0 )); then
         printf '[ATENÇÃO] Ação "%s" finalizou com código %s. O menu permanece ativo para diagnóstico.\n' "$act" "$rc" >&2
       fi
       return 0
     }
     ```
  2. Em **`fetch_script()`** (defesa em profundidade com remoção prévia do arquivo destino, `|| die` explícito no `curl` e verificação de arquivo não-vazio `[[ -s ... ]]`):
     ```bash
     fetch_script() {
       command -v curl >/dev/null 2>&1 || die 'curl é necessário para baixar instaladores versionados.'
       if [[ -z "$TMP_DIR" ]]; then TMP_DIR="$(mktemp -d)"; chmod 700 "$TMP_DIR"; fi
       local name="$1"
       case "$name" in install-docker-ubuntu.sh|postgres16-lab.sh|backend-lab.sh) ;; *) die 'Nome de script não permitido.' ;; esac
       local script_ref="$SCRIPTS_REV"
       if [[ "$name" == backend-lab.sh ]]; then script_ref="$BACKEND_REV"; fi
       rm -f -- "${TMP_DIR}/${name}"
       curl --fail --silent --show-error --location --proto '=https' --tlsv1.2 \
         "https://raw.githubusercontent.com/edinhogrubert/TeamKitCollection/${script_ref}/scripts/infra/${name}" -o "${TMP_DIR}/${name}" \
         || die "Falha ao baixar instalador: $name"
       [[ -s "${TMP_DIR}/${name}" ]] || die "Instalador baixado está vazio: $name"
       bash -n "${TMP_DIR}/${name}" || die "Sintaxe inválida: $name"
       info "Instalador revisionado: ${name} @ ${script_ref:0:12}"
     }
     ```

---

## 4. Testes Negativos Sem Docker e Critérios de Aprovação

Para validar o futuro patch L2 sem depender de Docker nem da VM:

1. **Teste Negativo TN-01 (Fail-fast em falha intermediária dentro de função chamada por `run_menu_action`):**
   - Injetar/simular em subshell de teste uma função chamada por `run_menu_action` contendo `false; echo UNSAFE_AFTER_FAIL; return 0`.
   - **Critério:** A string `UNSAFE_AFTER_FAIL` **não pode** ser impressa; `run_menu_action` deve capturar `rc=1`, imprimir `[ATENÇÃO] Ação ... finalizou com código 1. O menu permanece ativo para diagnóstico.` e manter o menu ativo.
2. **Teste Negativo TN-02 (Falha de download no `curl` dentro de `fetch_script` via menu):**
   - Simular falha do `curl` (ex.: `PATH` com mock `curl` que cria arquivo vazio e retorna `exit 22`) ao acionar a opção `7` no menu (`printf "7\n0\n"`).
   - **Critério:** `fetch_script` deve abortar imediatamente no `curl` com `[BLOQUEADO] Falha ao baixar instalador: backend-lab.sh`, **sem** executar `bash -n` nem o script filho, exibindo o alerta do menu e saindo limpo na opção `0`.
3. **Teste Negativo TN-03 (Propagação de código `!= 0` na execução direta via CLI):**
   - Executar `bash scripts/infra/teamkit-lab.sh backend-check` e `bash scripts/infra/teamkit-lab.sh persist` diretamente via linha de comando (sem Docker).
   - **Critério:** Ambas as chamadas diretas devem abortar na primeira pré-condição falha e retornar exit code `1` (`!= 0`) ao shell chamador.
4. **Critérios Gerais de Aprovação:**
   - `bash -n scripts/infra/teamkit-lab.sh` retorna `0`.
   - `git diff` restrito exclusivamente a `scripts/infra/teamkit-lab.sh` e aos registros de comunicação de `TKC-0010`.
   - Zero execução Docker, zero alterações em `backend-lab.sh`, PostgreSQL, volumes ou redes.

---

## 5. Limitações e Estado de Verificação

- **O que foi efetivamente verificado (`VERIFICADO` em `L0/L1`):**
  - Leitura direta de `TKC-REQ-0010.md`, `TKC-0010.md`, `scripts/infra/teamkit-lab.sh` e `TKC-RET-0009.md` na `main` (`5bb6ea624c342fbfa7bd9772411b0ca30ad25c3c`).
  - Reprodução sintética em GNU Bash `5.2.15(1)-release` comprovando a falha de `if ( action "$act" ); then` e a eficácia da correção `set +e; ( set -Eeuo pipefail; action "$act" ); rc=$?; set -e`.
  - Confirmação de que nenhum script, código, container, banco ou volume foi modificado nesta etapa.
- **O que permanece pendente (`PENDENTE` / `NÃO_EXECUTADO`):**
  - Revisão deste parecer `TKC-PAR-0010` por `AGT-001` e emissão/autorização de `TKC-AUT-0010` para aplicar o patch L2 em `scripts/infra/teamkit-lab.sh`.
  - Execução operacional das opções 7, 8 e 9 na VM Ubuntu `Container` por `HUMAN-001`.
