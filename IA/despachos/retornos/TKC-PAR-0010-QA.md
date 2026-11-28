# TKC-PAR-0010-QA — Parecer Independente de QA e Segurança sobre o Patch do Menu Bash (`TKC-0010`)

## 1. Identificação e Rastreabilidade
- **task_id:** `TKC-0012` (frente paralela de QA e Segurança) / Tarefa auditada: `TKC-0010`
- **return_id / tipo de documento:** `TKC-PAR-0010-QA` — Parecer Independente L0/L1 (Análise Estática de Código, Tratamento de Falhas e Segurança de Execução)
- **commit auditado:** `a2992ffc2c7ef0bc911975654dfe3d2da229691b` (`origin/main`)
- **patch inspecionado:** `542631548842603fc5c00e620577be2eec248939` em `scripts/infra/teamkit-lab.sh`
- **agent_id / papel / ferramenta:** `AGT-002` — Engenheiro de QA e Segurança | Cline (VS Code / Linux)
- **origem da autorização:** Despacho de `HUMAN-001` (2026-11-28) concedendo permissão restrita para publicação L2 do parecer independente em `IA/despachos/retornos/TKC-PAR-0010-QA.md` e atualização correspondente de `IA/tarefas/TKC-0012.md` e `IA/tarefas/indice.md`.
- **escopo executado:** Análise estática L0/L1; **zero execução Docker**, **zero execução de VM**, **zero modificação em código de produto ou testes**.

---

## 2. Resumo da Correção Auditada (`scripts/infra/teamkit-lab.sh`)

O patch entregue em `5426315` corrigiu dois pontos críticos levantados na revisão inicial de `teamkit-lab.sh`:

1. **Correção do `errexit` (`set -e`) em `run_menu_action()`:**
   - Na versão anterior, a construção condicional `if ( action "$act" ); then` desativava silenciosamente o comportamento de `set -e` em toda a subárvore de execução, permitindo que falhas intermediárias ocorressem sem abortar a operação.
   - O patch removeu o subshell da condição do `if`, substituindo-o por um bloco explícito e incondicional sob `set +e`/`set -e`:
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
   - Isso garante que qualquer falha dentro de `action` (e suas funções filhas como `persist`, `fetch_script`, etc.) acione imediatamente o `errexit` (`-e`) no subshell isolado, retorne o código exato `rc=$?` e mantenha o menu interativo vivo para diagnóstico.

2. **Endurecimento de `fetch_script()` contra falhas de transporte e payload nulo:**
   - Adicionada limpeza prévia do arquivo temporário (`rm -f -- "${TMP_DIR}/${name}"`).
   - Protegida a chamada de download com verificação de erro do `curl` (`|| die "Falha ao baixar instalador..."`).
   - Adicionada checagem explícita de arquivo não-vazio (`[[ -s "${TMP_DIR}/${name}" ]] || die "Arquivo baixado vazio ou ausente: $name"`).
   - Restrição de permissão (`chmod 700`) e validação estática de sintaxe (`bash -n`) antes de executar o script baixado.

---

## 3. Análise de Propagação de Falhas e Riscos Residuais

### 3.1. Propagação de Erros em `persist()`
- **Análise do fluxo:** Todas as chamadas de banco em `persist()` utilizam a função `pg_sql`, que invoca `psql -v ON_ERROR_STOP=1`. Qualquer erro de sintaxe ou execução SQL faz o `psql` retornar status `!= 0`.
- **Comportamento:** Como o subshell executa com `set -Eeuo pipefail`, qualquer falha no `INSERT`, na verificação `before == 1`, no `docker restart` ou no `SELECT` final interrompe a execução **na linha exata da falha**, impedindo reinícios indevidos ou falsas confirmações de persistência.

### 3.2. Imutabilidade e Compatibilidade dos Scripts Filhos (`SCRIPTS_REV` e `BACKEND_REV`)
- `SCRIPTS_REV="e26def6a4a2da84e57c88a4e384874e38c4cebc5"` (contém `install-docker-ubuntu.sh` e `postgres16-lab.sh` travados pelo digest do PostgreSQL 16.16).
- `BACKEND_REV="8d0cfa789f055f139c8f6efc06fe59f7ca71be8d"` (contém o patch de resiliência e tratamento de sinais do `backend-lab.sh`).
- Ambos os hashes apontam para commits imutáveis e verificados no histórico do repositório, garantindo reproducibilidade estrita.

---

## 4. Avaliação das Evidências Sintéticas (TN-00 a TN-03)

| ID do Teste | Descrição da Evidência Sintética | Status | Avaliação AGT-002 |
|---|---|---|---|
| `TN-00` | `bash -n scripts/infra/teamkit-lab.sh` | `PASS` (`exit 0`) | Validação estática confirmada; ausência de erros de sintaxe Bash. |
| `TN-01` | Falha intermediária (`exit 42`) em `persist()` via `run_menu_action` | `PASS` | Interrompeu na etapa correta sem executar passos posteriores; menu preservado. |
| `TN-02A` | Simulação de falha de rede `curl` (`exit 22`) em `fetch_script()` | `PASS` | Capturado por `|| die`; arquivo não executado; menu mantido ativo. |
| `TN-02B` | Simulação de arquivo baixado vazio (0 bytes) | `PASS` | Bloqueado com sucesso por `[[ -s ... ]]`, evitando execução de payload nulo. |
| `TN-03` | Invocação CLI direta (`main persist`) com falha (`exit 17`) | `PASS` (`rc=17`) | Código de erro propagado corretamente ao chamador externo com disparo do `trap EXIT`. |

---

## 5. Veredito Independente (AGT-002)

### Veredito: `APROVADO_COM_RESSALVAS`

#### Fundamentação e Ressalvas:
1. **Qualidade Técnica:** O patch implementado em `teamkit-lab.sh` resolve de forma elegante e correta o problema de supressão do `set -e` em subshells condicionais, além de endurecer de forma robusta o mecanismo de download e validação de instaladores remotos.
2. **Ressalva Única (Operacional):** As evidências apresentadas cobrem exaustivamente a validação estática e simulações sintéticas (TN-00 a TN-03) sem Docker ativo. A validação operacional definitiva com containers reais e daemon Docker ativo na VM Ubuntu permanece dependente da execução em ambiente real pelo operador humano (`HUMAN-001`).

---

## 6. Próximos Passos
- Encaminhar este parecer para revisão de `AGT-001` no GitHub.
- Liberar a base para a execução dos testes funcionais na VM Ubuntu sob coordenação de `HUMAN-001`.
