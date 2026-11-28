# TKC-RET-0010 — Retorno da Execução L2 DevOps (Correção de `errexit` e Endurecimento de `fetch_script` em `scripts/infra/teamkit-lab.sh`)

## 1. Identificação
- **task_id:** `TKC-0010`
- **order_id / ref curta:** `TKC-AUT-0010`
- **return_id:** `TKC-RET-0010`
- **tipo:** `EXECUCAO L2` (alteração estática exclusiva de `scripts/infra/teamkit-lab.sh` e registros documentais autorizados; **zero execução Docker**)
- **claim_id:** `TKC-0010-C04` (publicada e confirmada em `origin/main` no commit `9dd81a8755a723f5e0d0473114b5dd61ab77272e` antes da edição do script)
- **agent_id / papel / ferramenta:** `AGT-003` — Engenheiro DevOps/SRE | Google AI Studio (`gemini-4-argon`)
- **origem da ordem / evidência da autorização:** `IA/despachos/ordens/TKC-AUT-0010.md` (`89ca4115ea5cf9187dce0dde39a92948a63cc168`) + decisão humana `TKC-AUT-0010 #TRUE` transmitida diretamente por `HUMAN-001` (`MEDIADO`)
- **repositório / branch:** `edinhogrubert/TeamKitCollection` | `main`
- **base_commit:** `aab1f29085a058bf2755392eb08885f4d0752cb2`
- **claim_commit:** `9dd81a8755a723f5e0d0473114b5dd61ab77272e`
- **estado de saída:** `ENTREGUE` (`EM_REVISAO` por `AGT-001` antes de qualquer validação operacional na VM)

---

## 2. Resumo das Alterações Implementadas em `scripts/infra/teamkit-lab.sh`

1. **Restauração de `errexit` (`set -e`) dentro de `run_menu_action()` (linhas 138–151):**
   - Retirada a chamada `( action "$act" )` do contexto condicional `if ( action "$act" ); then`, que desativava silenciosamente `set -e` em toda a árvore de chamadas do menu interativo (`action()`, `persist()`, `run_existing()` e `fetch_script()`).
   - O shell pai do menu suspende `set -e` localmente (`set +e`), executa o subshell isolado `( set -Eeuo pipefail; action "$act" )` fora de contexto condicional, captura `rc=$?`, restaura imediatamente `set -e` no shell pai e emite `[ATENÇÃO] Ação "<act>" finalizou com código <rc>. O menu permanece ativo para diagnóstico.` em `stderr` quando `(( rc != 0 ))`, mantendo o loop `menu()` vivo (`return 0`).
2. **Endurecimento de `fetch_script()` contra falha de download, arquivo residual ou payload vazio (linhas 23–38):**
   - Adicionada limpeza prévia `rm -f -- "${TMP_DIR}/${name}"` antes do download.
   - Protegida a invocação de `curl --fail --silent --show-error --location --proto '=https' --tlsv1.2` com `|| die "Falha ao baixar instalador: ${name} @ ${script_ref:0:12}"`.
   - Adicionada verificação explícita de arquivo não-vazio `[[ -s "${TMP_DIR}/${name}" ]] || die "Arquivo baixado vazio ou ausente: $name"` e permissão restrita `chmod 700 "${TMP_DIR}/${name}"` antes de `bash -n "${TMP_DIR}/${name}"`.
3. **Preservação integral de SHAs fixados, controles TLS e compatibilidade da CLI:**
   - `SCRIPTS_REV="e26def6a4a2da84e57c88a4e384874e38c4cebc5"` preservado sem alteração.
   - `BACKEND_REV="8d0cfa789f055f139c8f6efc06fe59f7ca71be8d"` preservado sem alteração.
   - Flags TLS `--fail --silent --show-error --location --proto '=https' --tlsv1.2` preservadas sem alteração.
   - Modo CLI direto (`bash teamkit-lab.sh <ação>`) preservado sem alteração (`if [[ "$choice" == menu ]]; then menu; else action "$choice"; fi`), propagando qualquer código de saída `!= 0` ao processo chamador.

---

## 3. Evidências dos Testes Sintéticos Bash Executados Sem Docker (`VERIFICADO`)

Ambiente de verificação: `GNU bash, version 5.2.15(1)-release (x86_64-pc-linux-gnu)`. Nenhum comando Docker ou operação em VM foi executado.

### 3.1. Resultados Consolidados

| ID | Teste sintético | Resultado | Saída / Evidência observada |
|---|---|---|---|
| `TN-00` | Validação sintática: `bash -n scripts/infra/teamkit-lab.sh` | `PASS` | `TN-00_EXIT=0` (zero erros de sintaxe) |
| `TN-01` | Falha intermediária (`exit 42`) dentro de `persist()` chamada via `run_menu_action persist` | `PASS` | Abortou imediatamente na etapa 1 (`[STEP-1] CREATE TABLE / INSERT falha com rc=42`); **não** executou etapa 2 nem emitiu falso `[OK]`; imprimiu `[ATENÇÃO] Ação "persist" finalizou com código 42. O menu permanece ativo para diagnóstico.` e manteve o loop do menu ativo (`[MENU-LOOP] Loop do menu continuou vivo após falha intermediária capturada`). |
| `TN-02A` | Falha de download (`curl` retornando `22`) em `fetch_script()` chamada via `run_menu_action docker-check` | `PASS` | Abortou em `fetch_script()` com `[BLOQUEADO] Falha ao baixar instalador: install-docker-ubuntu.sh @ e26def6a4a2d`; **não** executou `bash "${TMP_DIR}/${script}"`; emitiu `[ATENÇÃO] Ação "docker-check" finalizou com código 1. O menu permanece ativo para diagnóstico.` e manteve o menu ativo. |
| `TN-02B` | Download vazio (`0 bytes`, `curl` retornando `0`) em `fetch_script()` chamada via `run_menu_action backend-check` | `PASS` | Bloqueado por `[[ -s "${TMP_DIR}/${name}" ]]` com `[BLOQUEADO] Arquivo baixado vazio ou ausente: backend-lab.sh`; **não** executou `bash -n` nem `bash "${TMP_DIR}/${script}"` sobre arquivo vazio; emitiu `[ATENÇÃO] Ação "backend-check" finalizou com código 1. O menu permanece ativo para diagnóstico.` e manteve o menu ativo. |
| `TN-03` | Invocação via CLI direta (`main persist`) com falha intermediária (`exit 17`) | `PASS` | Abortou imediatamente na etapa 1, acionou o `trap EXIT` (`[ERRO] Operação interrompida (código 17); nenhum recurso de banco foi removido.`) e encerrou o processo com `TN-03_CLI_EXIT_CODE=17`. |

### 3.2. Transcrição da Saída Sanitizada dos Testes

```text
=== [TN-00] bash -n scripts/infra/teamkit-lab.sh ===
TN-00_EXIT=0
=== [VERIFICAÇÃO DE SHAs E CONTROLES TLS] ===
8:SCRIPTS_REV="e26def6a4a2da84e57c88a4e384874e38c4cebc5"
10:BACKEND_REV="8d0cfa789f055f139c8f6efc06fe59f7ca71be8d"
31:  curl --fail --silent --show-error --location --proto '=https' --tlsv1.2 \
=== [TN-01] Falha intermediária em run_menu_action() (sem Docker) ===
[STEP-1] CREATE TABLE / INSERT falha com rc=42
[ATENÇÃO] Ação "persist" finalizou com código 42. O menu permanece ativo para diagnóstico.
[MENU-LOOP] Loop do menu continuou vivo após falha intermediária capturada
=== [TN-02A] Falha de curl (exit 22) em fetch_script() via run_menu_action() ===
[BLOQUEADO] Falha ao baixar instalador: install-docker-ubuntu.sh @ e26def6a4a2d
[ATENÇÃO] Ação "docker-check" finalizou com código 1. O menu permanece ativo para diagnóstico.
[MENU-LOOP] Loop do menu continuou vivo após falha de download
=== [TN-02B] Download vazio (0 bytes) em fetch_script() via run_menu_action() ===
[BLOQUEADO] Arquivo baixado vazio ou ausente: backend-lab.sh
[ATENÇÃO] Ação "backend-check" finalizou com código 1. O menu permanece ativo para diagnóstico.
[MENU-LOOP] Loop do menu continuou vivo após bloqueio de arquivo vazio
=== [TN-03] Propagação de código de saída na CLI direta (main <ação>) ===
[CLI-STEP-1] Falha intermediária rc=17
[ERRO] Operação interrompida (código 17); nenhum recurso de banco foi removido.
TN-03_CLI_EXIT_CODE=17
TN-03=PASS
```

---

## 4. Arquivos Alterados e Escopo (`COM-001` / `TKC-AUT-0010 #TRUE`)

| Arquivo | Categoria | Tipo de alteração | Commit |
|---|---|---|---|
| `IA/tarefas/TKC-0010.md` | `communication_paths` | Reivindicação `TKC-0010-C04` e encerramento `ENTREGUE` (`EM_REVISAO`) | `9dd81a8755a723f5e0d0473114b5dd61ab77272e` + commit final |
| `IA/tarefas/indice.md` | `communication_paths` | Atualização da linha `TKC-0010` (posse `C04` e encerramento `EM_REVISAO`) | `9dd81a8755a723f5e0d0473114b5dd61ab77272e` + commit final |
| `scripts/infra/teamkit-lab.sh` | `product_paths` | Correção de `run_menu_action()` e endurecimento de `fetch_script()` | Commit final desta entrega |
| `IA/despachos/logs/TKC-EXE-0010.md` | `communication_paths` | Log de eventos da execução `TKC-0010-C04` | Commit final desta entrega |
| `IA/despachos/retornos/TKC-RET-0010.md` | `communication_paths` | Relatório formal de retorno da execução L2 | Commit final desta entrega |

*(Nenhum outro arquivo do repositório foi modificado).*

---

## 5. Limitações e O Que Permanece Pendente

- **Operações em VM / Docker / PostgreSQL (`NÃO_EXECUTADAS`):** Em cumprimento estrito às restrições de `TKC-AUT-0010 #TRUE`, nenhum comando Docker, Docker Compose, criação/remoção de containers, redes ou volumes foi executado.
- **Próximo passo:** Revisão técnica independente do diff por `AGT-001` antes de qualquer validação operacional na VM Ubuntu `Container` por `HUMAN-001`.
