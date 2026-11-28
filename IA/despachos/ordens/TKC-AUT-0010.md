# TKC-AUT-0010 — Proposta de autorização L2 para correção de `errexit` e endurecimento de download em `scripts/infra/teamkit-lab.sh`

**order_id:** `TKC-AUT-0010`  
**task_id:** `TKC-0010`  
**sender:** AGT-003 (DevOps/SRE — preparação da proposta técnica após revisão de `TKC-PAR-0010` por AGT-001)  
**recipient / executor proposto:** AGT-003 — DevOps/SRE (a confirmar no recebimento de decisão humana válida)  
**authorization_state:** `PENDENTE` — **proposta técnica aguardando decisão de `HUMAN-001`; NÃO autoriza execução L2**  
**human_decision:** `PENDENTE` (nenhuma autorização L2 emitida até decisão explícita `#TRUE` ou `#FALSE` de `HUMAN-001`)  
**proposal_basis:** `TKC-PAR-0010` (publicado no commit `65f94ba64c586a1de3be678d8d6d19f3ebf6be1d`, veredito `CONFIRMADO`, revisado e aceito por AGT-001)  
**preparation_claim:** `TKC-0010-C03`, AGT-003, exclusivamente publicação documental da proposta em `PENDENTE`; reivindicação confirmada em `2182fde691403018c0c9aacc52d5050dbfc2e74c`  
**base_commit_for_executor:** verificar `main` no momento do recebimento; base documental desta proposta: `2182fde691403018c0c9aacc52d5050dbfc2e74c` (parecer `65f94ba64c586a1de3be678d8d6d19f3ebf6be1d`)  
**product_paths:** exclusivamente `scripts/infra/teamkit-lab.sh`  
**communication_paths:** `IA/despachos/ordens/TKC-AUT-0010.md`, `IA/tarefas/TKC-0010.md`, `IA/tarefas/indice.md`, `IA/despachos/logs/TKC-EXE-0010.md`, `IA/despachos/retornos/TKC-RET-0010.md`  
**state:** `PENDENTE` — **documento em estado de proposta; sua presença no Git NÃO autoriza modificar `scripts/infra/teamkit-lab.sh` sem decisão humana posterior e nova reivindicação COM-001 (`TKC-0010-C04`)**

---

## 1. Escopo técnico proposto (L2 estático — quando autorizado por `HUMAN-001`)

Aplicar correção mínima e pontual exclusivamente em `scripts/infra/teamkit-lab.sh` para eliminar a supressão de `errexit` (`set -e`) no modo interativo do menu e endurecer `fetch_script()`, sem alterar nenhum outro script do repositório:

1. **Corrigir a propagação de falhas em `run_menu_action()` (`scripts/infra/teamkit-lab.sh`, linhas 97–108):**
   - **Problema confirmado (`TKC-PAR-0010`):** a construção `if ( action "$act" ); then` executa o subshell dentro da lista de teste do `if`. Pela regra POSIX / GNU Bash, `errexit` é desativado em toda a árvore de chamadas dentro da condição do `if` (incluindo `action()`, `fetch_script()` e `bash "$s" ...`), fazendo com que comandos intermediários que falhem não abortem a função e retornem o exit status do último comando executado (`0` se o comando final for `echo`).
   - **Correção proposta:** retirar o subshell da lista condicional do `if`, suspender `set -e` apenas no shell pai do menu (`set +e`), executar `( set -Eeuo pipefail; action "$act" )` fora de qualquer contexto condicional `if`/`while`/`||`/`&&`, capturar `rc=$?`, restaurar `set -e` imediatamente no shell pai e exibir `[AVISO] A ação '${act}' falhou (código ${rc}). O menu continuará ativo.` quando `rc -ne 0`:
     ```bash
     run_menu_action() {
       local act="$1"
       local rc=0
       set +e
       (
         set -Eeuo pipefail
         action "$act"
       )
       rc=$?
       set -e
       if [[ "$rc" -ne 0 ]]; then
         echo "[AVISO] A ação '${act}' falhou (código ${rc}). O menu continuará ativo." >&2
       fi
       return 0
     }
     ```
2. **Endurecer `fetch_script()` contra download malsucedido, arquivo residual ou payload vazio (`scripts/infra/teamkit-lab.sh`, linhas 59–69):**
   - Remover previamente qualquer arquivo residual no destino temporário (`rm -f -- "${TMP_DIR}/${name}"`).
   - Proteger a invocação de `curl -fsSL "$url" -o "${TMP_DIR}/${name}"` com `|| die "Falha ao baixar ${name} (${rev})."` (defesa em profundidade mesmo se chamado em contexto onde `errexit` esteja suprimido).
   - Validar explicitamente que o arquivo baixado existe e não está vazio (`[[ -s "${TMP_DIR}/${name}" ]] || die "Arquivo baixado para ${name} está vazio."`) antes de `chmod 700`.
3. **Preservar SHAs imutáveis e comportamento da CLI direta:**
   - Manter inalterados `SCRIPTS_REV="e26def6a4a2da84e57c88a4e384874e38c4cebc5"` e `BACKEND_REV="8d0cfa789f055f139c8f6efc06fe59f7ca71be8d"` em `scripts/infra/teamkit-lab.sh`.
   - Preservar o comportamento da CLI não-interativa (`teamkit-lab.sh <ação>`), que invoca `action "$1"` diretamente no nível superior sob `set -Eeuo pipefail` e propaga o código de saída diferente de zero ao chamador.

---

## 2. Testes sintéticos obrigatórios (sem Docker)

A execução L2 (quando autorizada) deverá comprovar, em `IA/despachos/logs/TKC-EXE-0010.md` e `IA/despachos/retornos/TKC-RET-0010.md`, os seguintes testes estáticos e sintéticos em Bash sem invocar o daemon Docker:

- **`TN-00` — Sintaxe Bash:** `bash -n scripts/infra/teamkit-lab.sh` deve retornar `exit_code=0`.
- **`TN-01` — Falha intermediária em `run_menu_action()` (ex.: etapa 1 de `persistence-test` ou `full-bootstrap` falha com código `42`):**
  - *Expectativa:* execução da ação aborta imediatamente na etapa que falhou; etapas seguintes **não** são executadas; `[AVISO] A ação '...' falhou (código 42). O menu continuará ativo.` é emitido em `stderr`; o loop do menu permanece vivo (`run_menu_action` retorna `0` ao loop).
- **`TN-02` — Falha de download ou arquivo vazio em `fetch_script()` dentro do menu:**
  - *Expectativa:* `fetch_script()` aborta imediatamente via `die` com código `1`; `bash "$s"` **nunca** é executado sobre arquivo ausente, truncado ou antigo; o menu captura `rc=1`, emite `[AVISO]` e continua ativo.
- **`TN-03` — Invocação via CLI direta (`teamkit-lab.sh <ação>`):**
  - *Expectativa:* falha em qualquer etapa de `action "$1"` encerra o processo imediatamente com código de saída diferente de zero (`rc != 0`), sem engolir o erro.

---

## 3. Riscos e limites operacionais

| ID | Risco identificado | Mitigação proposta |
|---|---|---|
| `R-01` | Reativação de `set -e` dentro do subshell de `run_menu_action` encerrar o loop principal do menu por engano | `set +e` é aplicado no shell pai apenas ao redor do subshell `( set -Eeuo pipefail; action "$act" )`, capturando `rc=$?` e restaurando `set -e` logo em seguida; `run_menu_action` retorna `0` ao loop `while true` |
| `R-02` | Alteração acidental de `SCRIPTS_REV` ou `BACKEND_REV` quebrar a rastreabilidade com `TKC-0009` | Critério de aceite exige `git diff` comprovando que os SHAs `e26def6a4a2da84e57c88a4e384874e38c4cebc5` e `8d0cfa789f055f139c8f6efc06fe59f7ca71be8d` permanecem idênticos |
| `R-03` | Execução de comandos Docker na VM durante a validação do patch | Proibição expressa: todos os testes de validação L2 devem usar stubs/subshells sintéticos em memória ou `/tmp`, sem invocar `docker` ou `docker compose` |

---

## 4. Restrições mandatórias

- **Proibido:**
  - Executar este patch L2 enquanto `authorization_state` estiver `PENDENTE` ou sem decisão explícita `#TRUE` de `HUMAN-001`.
  - Alterar `scripts/infra/backend-lab.sh`, `scripts/infra/postgres16-lab.sh`, `scripts/infra/install-docker-ubuntu.sh`, código Python/FastAPI, Dockerfile, Compose ou normas (`AGENTS.md`, `IA/regras/*`, `IA/PROJETO.md`).
  - Executar Docker, Docker Compose, criar/remover containers, redes, volumes (`tkc-postgres16-data`) ou tocar na instância PostgreSQL `tkc-postgres16`.
  - Expor tokens, credenciais ou variáveis sensíveis em logs, commits ou documentos (SEC-003).
- **Custo financeiro:** R$ 0,00.

---

## 5. Critérios objetivos de aceite (para futura execução L2 após `#TRUE`)

1. Reivindicação de posse `TKC-0010-C04` publicada e confirmada em `origin/main` **antes** de qualquer edição em `scripts/infra/teamkit-lab.sh` (COM-001).
2. `git diff` de produto restrito **exclusivamente** a `scripts/infra/teamkit-lab.sh`, contendo apenas o ajuste de `run_menu_action()` e o endurecimento de `fetch_script()`, com `SCRIPTS_REV` e `BACKEND_REV` preservados.
3. Evidências completas e sanitizadas de `bash -n` (`TN-00`) e dos testes negativos `TN-01`, `TN-02` e `TN-03` registradas em `IA/despachos/logs/TKC-EXE-0010.md` e `IA/despachos/retornos/TKC-RET-0010.md`.
4. Declaração explícita de que testes operacionais com Docker na VM permanecem `NÃO_EXECUTADOS` pelo agente.
5. Reconciliação final de `IA/tarefas/TKC-0010.md` e `IA/tarefas/indice.md` liberando a posse (`ENTREGUE` / `EM_REVISAO`) para revisão independente de `AGT-001`.
