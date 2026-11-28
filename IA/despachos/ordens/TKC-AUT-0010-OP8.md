# TKC-AUT-0010-OP8 — Proposta de Autorização Operacional para Execução da Opção 8 (`backend-up`)

**order_id:** `TKC-AUT-0010-OP8`  
**task_id:** `TKC-0010`  
**sender:** AGT-003 (DevOps/SRE — preparação da proposta de autorização após verificação OP7)  
**recipient / executor proposto:** HUMAN-001 / AGT-003 (a confirmar em decisão humana válida)  
**authorization_state:** `PENDENTE` — **proposta técnica aguardando decisão explícita de `HUMAN-001` (`#TRUE` ou `#FALSE`); NÃO autoriza execução na VM**  
**human_decision:** `PENDENTE`  
**proposal_basis:** `TKC-ROT-0010` (Consolidação C07, commit `89749678177c26b9dbf6d614caf22d59e2689e13`) + verificação OP7 aprovada  
**preparation_claim:** `TKC-0010-C08`, AGT-003, exclusivamente publicação documental da proposta em `PENDENTE`  
**base_commit:** `89749678177c26b9dbf6d614caf22d59e2689e13`  
**product_paths:** exclusivamente a execução da opção **8 (`backend-up`)** via `scripts/infra/teamkit-lab.sh`  
**communication_paths:** `IA/despachos/ordens/TKC-AUT-0010-OP8.md`, `IA/tarefas/TKC-0010.md`, `IA/tarefas/indice.md`, `IA/despachos/logs/TKC-EXE-0010-OP8.md`, `IA/despachos/retornos/TKC-RET-0010-OP8.md`  

---

## 1. Escopo Autorizado Proposto (Opção 8 — `backend-up`)

Quando autorizada por decisão `#TRUE` de `HUMAN-001`, a execução abrangerá exclusivamente:
1. Criação da bridge interna `tkc-lab-net` (caso ausente).
2. Conexão do container existente `tkc-postgres16` à rede `tkc-lab-net` via `docker network connect`, **sem recriar nem reiniciar o PostgreSQL**.
3. Obtenção do código imutável do backend na revisão fixada `BACKEND_REV="8d0cfa789f055f139c8f6efc06fe59f7ca71be8d"` (`959745e5513e...`).
4. Construção e subida **exclusiva** do container de API (`tkc_lab-backend-1`) via `docker compose up -d --build --no-deps backend`, utilizando o compose file versionado (`infra/docker/docker-compose.lab.yml`), que restringe a exposição da API estritamente ao loopback do host (`127.0.0.1:8000:8000`).
5. Validação de prontidão via sonda `GET /health` esperando `HTTP 200` com `{"status":"ok","database":"up"}`.

---

## 2. Checklist Pré e Pós-Execução Obrigatório (Ressalvas de AGT-001)

Antes e após acionar a Opção 8, o operador deverá validar:
1. **Identidade e Execução do PostgreSQL:** `sudo docker inspect -f '{{.Name}} | Running: {{.State.Running}}' tkc-postgres16`
2. **Integridade do Volume de Dados:** `sudo docker inspect -f '{{range .Mounts}}Destination: {{.Destination}} | Name: {{.Name}}{{end}}' tkc-postgres16` (confirmar montagem do volume `tkc-postgres16-data`).
3. **Conectividade de Rede do Banco:** `sudo docker inspect tkc-postgres16 --format '{{json .NetworkSettings.Networks}}'` (confirmar presença de `tkc-lab-net`).
4. **Zero Exposição de Portas do Banco:** `sudo docker port tkc-postgres16` (deve retornar vazio).
5. **Exposição Restrita da API:** `sudo docker port tkc_lab-backend-1` (deve retornar exclusivamente `127.0.0.1:8000`).

---

## 3. Restrições e Proibições Absolutas

- **Proibido expressamente:** 
  - Executar a opção 5 (`pg-start` / `postgres16-lab.sh --start`).
  - Executar a opção 9 (`backend-fault`) nesta autorização.
  - Executar `docker restart tkc-postgres16` ou qualquer comando de reinício/remoção do PostgreSQL.
  - Executar remoção de volumes (`docker volume rm`, `docker compose down -v`).
  - Alterar código fonte, scripts de infraestrutura, normas ou tarefas de outros agentes.
- **Custo financeiro:** R$ 0,00.
