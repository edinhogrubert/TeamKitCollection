# TKC-ROT-0010 (Consolidação Final C07) — Roteiro Técnico L0/L1 para Validação Operacional (M3-02 / TKC-0010)

## 1. Identificação
- **task_id:** `TKC-0010`
- **return_id / doc_id:** `TKC-ROT-0010` (Consolidação C07)
- **tipo:** `ROTEIRO TÉCNICO L0/L1 CONSOLIDADO` (preparação de validação operacional; **zero execução Docker ou VM**)
- **claim_id:** `TKC-0010-C07` (reivindicação cooperativa publicada em `origin/main` conforme COM-001)
- **agent_id / papel / ferramenta:** `AGT-003` — Engenheiro DevOps/SRE | Google AI Studio (`gemini-4-argon`)
- **origem da autorização:** `HUMAN-001` (autorização expressa para publicação da consolidação C07 nos caminhos permitidos, sem execução na VM)
- **base_commit:** `7abdf84df648ef76532c56fad65b2ec6a8a6e1b3`
- **estado de saída:** `ENTREGUE` (`EM_REVISAO` por `AGT-001`)

---

## 2. Versão Atual dos Scripts e Confronto com o Código Real (`BACKEND_REV`)

- **Orquestrador:** `scripts/infra/teamkit-lab.sh` (com as opções 7, 8 e 9 delegando para `backend-lab.sh`).
- **Módulo de Backend:** `scripts/infra/backend-lab.sh` na revisão fixada `BACKEND_REV="8d0cfa789f055f139c8f6efc06fe59f7ca71be8d"` (`959745e5513e...`).
- **Proibições Absolutas:** A opção 5 (`pg-start` / `postgres16-lab.sh --start`), o reinício manual do PostgreSQL (`docker restart tkc-postgres16`) e a remoção de volumes (`docker volume rm`, `docker compose down -v`) **estão expressamente proibidas** no escopo da futura autorização operacional.

---

## 3. Roteiro Operacional Consolidado por Opção do Menu

### Opção 7) Diagnosticar API e PostgreSQL (`backend-check`) — Classificação: Leitura de Baixo Risco
- **Comportamento real no código (`check()` em `backend-lab.sh`, linhas 80–123):**
  - Executa inspeções passivas: `docker info`, `docker inspect` em `tkc-postgres16`, verificação de porta publicada no host (deve estar vazia), validação de montagem do volume `tkc-postgres16-data`, `pg_isready` interno, checagem estrita da permissão `0600` do arquivo `postgres16.env`, sondagem da rede `tkc-lab-net` e requisição `GET /health` (`curl --max-time 7`) na API local `127.0.0.1:8000`.
- **Risco:** Baixo risco de leitura (não há risco zero em operações de inspection em runtime, mas a operação é estritamente não-intrusiva, sem modificação de estado).

### Opção 8) Preparar rede e iniciar backend /health (`backend-up`) — Classificação: Orquestração Controlada (Idempotente)
- **Comportamento real no código (`up()` em `backend-lab.sh`, linhas 155–204):**
  - Assegura a bridge `tkc-lab-net` e conecta o PostgreSQL à rede privada sem recriar o container do banco.
  - Valida o projeto Docker Compose (`tkc_lab`), inicia container parado (`docker start`) ou recompila/converge **exclusivamente** a API via `docker compose up -d --build --no-deps backend` utilizando o pacote imutável de `BACKEND_REV`.
- **Risco:** Controlado. O banco de dados e o volume de persistência permanecem isolados e intocados.

### Opção 9) Testar HTTP 503 e recuperação 200 (`backend-fault`) — Classificação: Simulação de Falha com Janela Exclusiva
- **Comportamento real no código (`fault()` em `backend-lab.sh`, linhas 206–253):**
  - Exige confirmação interativa explícita (`DIGITAR: TESTAR`).
  - Realiza preflight validando que a API responde `HTTP 200` com `database: up`.
  - Desconecta temporariamente o PostgreSQL da rede (`docker network disconnect`).
  - Valida a transição para `HTTP 503` com `{"error":"DB_UNAVAILABLE"}`.
  - Reconecta o PostgreSQL à rede (`docker network connect`) e valida o retorno a `HTTP 200`.

---

## 4. Checklist Pré e Pós-Execução (Auditoria de Integridade)

Antes e após cada execução operacional autorizada, o operador deverá registrar os seguintes checkpoints atômicos:
1. **Identidade do container PostgreSQL:** `sudo docker inspect -f '{{.Name}} (Image: {{.Config.Image}})' tkc-postgres16`
2. **Volume e montagem:** `sudo docker inspect -f '{{range .Mounts}}Destination: {{.Destination}} | Name: {{.Name}} (Type: {{.Type}}){{end}}' tkc-postgres16` (deve confirmar `tkc-postgres16-data`).
3. **Conectividade de rede:** `sudo docker inspect tkc-postgres16 --format '{{json .NetworkSettings.Networks}}'` (deve incluir `tkc-lab-net`).
4. **Portas publicadas no host:** `sudo docker port tkc-postgres16` (deve retornar vazio, provando zero exposição externa).
5. **Estado e identidade do backend:** `sudo docker inspect -f '{{.Name}} | State: {{.State.Status}} | Running: {{.State.Running}}' tkc_lab-backend-1`.

---

## 5. Limitações de Sinais, Interrupção e Recuperação Verificável

- **Limitações de Trap:** O script implementa `trap cleanup EXIT` e manipulação de `SIGINT`/`SIGTERM`. Contudo, **sinais `SIGKILL` (`kill -9`) e quedas abruptas de energia da VM não garantem a execução de traps em userspace**.
- **Critérios Objetivos de Interrupção (Abort Criteria):**
  - *Fase Pre-flight:* Abortar imediatamente se `pg_isready` falhar ou se houver porta 5432 publicada no host.
  - *Fase de Execução (Opção 9):* Abortar imediatamente se a API não retornar `HTTP 503` em até 5 segundos após a desconexão ou se o preflight 200 falhar.
- **Procedimento de Recuperação Manual Verificável (Caso a reconexão automática falhe):**
  1. Conectar manualmente o banco à rede: `sudo docker network connect tkc-lab-net tkc-postgres16`
  2. Verificar estado no Docker: `sudo docker inspect tkc-postgres16 --format '{{json .NetworkSettings.Networks}}'`
  3. Verificar saúde do banco: `sudo docker exec tkc-postgres16 pg_isready -U tkc_app -d teamkitcollection`
  4. Sintonizar/reiniciar API sem tocar no banco: `bash scripts/infra/teamkit-lab.sh backend-up`

---

## 6. Distinção entre Execução Diagnóstica e Homologação Formal (`TKC-0011`)

- **Execução Diagnóstica (Laboratório Local):** As opções 7, 8 e 9 do script de laboratório constituem testes de fumaça e resiliência pontual da infraestrutura (`tkc-lab-net`, container `tkc-postgres16`, volume de dados e Uvicorn).
- **Homologação Formal (`TKC-0011` / QA):** A homologação definitiva do backend FastAPI exige a suíte unitária e de integração em ambiente isolado (`pytest` em `tests/unit/`), que possui escopo normativo e aprovação independentes em `TKC-0011` e `TKC-PAR-0012`.

---

## 7. Coleta Mínima de Evidências Sanitizadas e Histórico

- **Evidências permitidas:** Exit codes de script, códigos HTTP resumidos (`200`, `503`) e chaves estáticas de erro do JSON (`error: DB_UNAVAILABLE`).
- **Proibido:** Reprodutibilidade de senhas, chaves privadas, variáveis de ambiente ou logs completos contendo dados sensíveis (SEC-003).
- **Preservação de Histórico:** O histórico completo das tentativas C01 a C06 permanece gravado nos commits anteriores da `main` e no registro de tarefas.
