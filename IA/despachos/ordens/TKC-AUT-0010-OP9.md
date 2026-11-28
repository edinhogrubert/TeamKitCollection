# TKC-AUT-0010-OP9 — Proposta de Autorização Operacional para Execução da Opção 9 (`backend-fault` / Teste 200→503→200)

**order_id:** `TKC-AUT-0010-OP9`  
**task_id:** `TKC-0010`  
**sender:** AGT-003 (DevOps/SRE — preparação da proposta de autorização após sucesso OP8)  
**recipient / executor proposto:** HUMAN-001 / AGT-003 (a confirmar em decisão humana válida)  
**authorization_state:** `PENDENTE` — **proposta técnica aguardando decisão explícita de `HUMAN-001` (`#TRUE` ou `#FALSE`); NÃO autoriza execução na VM**  
**human_decision:** `PENDENTE`  
**proposal_basis:** `TKC-ROT-0010` (Consolidação C07) + sucesso relatado em OP8 (`TKC-RET-0010-OP8`)  
**preparation_claim:** `TKC-0010-C11`, AGT-003, exclusivamente publicação documental da proposta em `PENDENTE`  
**base_commit:** `c988aba97720b184ef44040a0f014c3ef29f447a`  
**product_paths:** exclusivamente a execução da opção **9 (`backend-fault`)** via `scripts/infra/teamkit-lab.sh`  
**communication_paths:** `IA/despachos/ordens/TKC-AUT-0010-OP9.md`, `IA/tarefas/TKC-0010.md`, `IA/tarefas/indice.md`, `IA/despachos/logs/TKC-EXE-0010-OP9.md`, `IA/despachos/retornos/TKC-RET-0010-OP9.md`  

---

## 1. Escopo Autorizado Proposto (Opção 9 — `backend-fault`)

Quando autorizada por decisão `#TRUE` de `HUMAN-001`, a execução abrangerá exclusivamente:
1. Validação pré-vôo (preflight) confirmando que a API Uvicorn (`tkc_lab-backend-1`) responde `HTTP 200` com `database: up`.
2. Confirmação interativa obrigatória (`DIGITAR: TESTAR`).
3. Desconexão temporária e controlada do container `tkc-postgres16` da rede interna `tkc-lab-net` (`docker network disconnect`).
4. Verificação de que o endpoint `/health` transiciona para `HTTP 503` com o payload estático exato `{"error":"DB_UNAVAILABLE"}`.
5. Reconectividade automática e manual determinística do PostgreSQL à rede `tkc-lab-net` (`docker network connect`), restaurando a sonda `/health` para `HTTP 200` (`database: up`).
6. Preservação integral do container do banco, credenciais (`0600`) e do volume `tkc-postgres16-data`.

---

## 2. Restrições e Proibições Absolutas

- **Proibido expressamente:** 
  - Executar comandos de reset, remoção de volumes (`docker volume rm`, `docker compose down -v`) ou remoção de containers.
  - Alterar código fonte, scripts de infraestrutura, normas ou tarefas de outros agentes.
- **Custo financeiro:** R$ 0,00.
