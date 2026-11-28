# TKC-ROT-0010 (Revisão C06) — Roteiro Técnico L0/L1 Ajustado para Validação Operacional (M3-02 / TKC-0010)

## 1. Identificação
- **task_id:** `TKC-0010`
- **return_id / doc_id:** `TKC-ROT-0010` (Revisão C06)
- **tipo:** `ROTEIRO TÉCNICO L0/L1 AJUSTADO` (preparação de validação operacional; **zero execução Docker ou VM**)
- **claim_id:** `TKC-0010-C06` (reivindicação cooperativa publicada em `origin/main` conforme COM-001)
- **agent_id / papel / ferramenta:** `AGT-003` — Engenheiro DevOps/SRE | Google AI Studio (`gemini-4-argon`)
- **origem da autorização:** `HUMAN-001` (autorização expressa para publicação da revisão nos caminhos permitidos, sem execução na VM)
- **base_commit:** `95933819778aa8160986dcdf59eb792ce12e5e07`
- **estado de saída:** `ENTREGUE` (`EM_REVISAO` por `AGT-001`)

---

## 2. Versão Atual dos Scripts e Confronto com o Código Real (`BACKEND_REV`)

O escopo operacional proposto restringe-se estritamente aos scripts versionados na `main` e revisados por `AGT-001`:
- **Orquestrador:** `scripts/infra/teamkit-lab.sh` (com as opções 7, 8 e 9 delegando para `backend-lab.sh`).
- **Módulo de Backend:** `scripts/infra/backend-lab.sh` na revisão fixada `BACKEND_REV="8d0cfa789f055f139c8f6efc06fe59f7ca71be8d"` (`959745e5513e...`).
- **Exclusão Explícita:** A opção 5 (`pg-start` / `postgres16-lab.sh --start`) **está estritamente excluída** do escopo de futura autorização operacional, pois cria recursos de persistência e credenciais na VM.

---

## 3. Roteiro Operacional Ajustado por Opção do Menu (Confronto com `backend-lab.sh`)

### Opção 7) Diagnosticar API e PostgreSQL (`backend-check`) — Classificação: Leitura de Baixo Risco
- **Comportamento real no código (`check()` em `backend-lab.sh`, linhas 80–123):**
  - Executa inspecções passivas: `docker info`, `docker inspect` em `tkc-postgres16`, verificação de porta publicada no host (deve estar vazia), validação de montagem do volume `tkc-postgres16-data`, `pg_isready` interno, checagem estrita da permissão `0600` do arquivo `postgres16.env`, sondagem da rede `tkc-lab-net` e requisição `GET /health` (`curl --max-time 7`) na API local `127.0.0.1:8000`.
- **Impacto / Risco:** Nenhum. Não altera estado de containers, rede ou volumes.

### Opção 8) Preparar rede e iniciar backend /health (`backend-up`) — Classificação: Orquestração Controlada (Idempotente)
- **Comportamento real no código (`up()` em `backend-lab.sh`, linhas 155–204):**
  - Valida o PostgreSQL e o arquivo `postgres16.env` (modo `0600`).
  - Cria a bridge `tkc-lab-net` se ausente e conecta o PostgreSQL à rede privada sem recriar o container.
  - Verifica o label Docker Compose do container existente (`tkc_lab-backend-1`, exigindo projeto `tkc_lab`).
  - Se a API já estiver rodando e saudável (`HTTP 200`, `database: up`), encerra imediatamente com `0` sem recompilar. Se parada, executa `docker start`. Se ausente ou degradada, baixa o pacote imutável de `BACKEND_REV` e executa `docker compose up -d --build --no-deps backend` (atuando **exclusivamente** sobre o serviço de API, preservando intocados o PostgreSQL e o volume de dados).
- **Impacto / Risco:** Controlado. Atua unicamente sobre o container e imagem do backend.

### Opção 9) Testar HTTP 503 e recuperação 200 (`backend-fault`) — Classificação: Simulação de Falha com Restrições Estritas
- **Comportamento real no código (`fault()` em `backend-lab.sh`, linhas 206–253):**
  - Exige confirmação interativa explícita (`DIGITAR: TESTAR`).
  - Realiza preflight validando que a API responde `HTTP 200` com `database: up`.
  - Ativa o mecanismo de segurança `ATTEMPT_RECONNECT=1` e o `trap cleanup EXIT` (que reconecta o banco à rede caso o script seja interrompido abruptamente).
  - Executa `docker network disconnect tkc-lab-net tkc-postgres16`.
  - Aguarda e valida a transição para `HTTP 503` contendo exatamente o payload estático `{"error":"DB_UNAVAILABLE"}`.
  - Reconecta o PostgreSQL à rede (`docker network connect`) e aguarda a recuperação automática para `HTTP 200` (`database: up`).
- **Janela Exclusiva e Pré-requisitos:** O operador deve garantir janela de manutenção sem requisições concorrentes de produção na API.

---

## 4. Procedimento de Recuperação Ajustado (Sem Ocultar Falhas)

Em conformidade com a diretriz de **não ocultar falhas com `|| true` cego**:
1. Se a execução for interrompida por `SIGINT` (Ctrl+C) ou falha de rede durante a Opção 9, o script aciona a função `cleanup()`, que verifica se o PostgreSQL foi desconectado e tenta reconectá-lo explicitamente via `sudo docker network connect tkc-lab-net tkc-postgres16`.
2. O operador **nunca** deve assumir sucesso automático; deve verificar explicitamente o estado final através de comandos de auditoria atômica:
   - Estado do container: `sudo docker inspect -f '{{.State.Running}}' tkc-postgres16`
   - Conectividade de rede: `sudo docker inspect tkc-postgres16 --format '{{json .NetworkSettings.Networks}}'`
   - Prontidão do banco: `sudo docker exec tkc-postgres16 pg_isready -U tkc_app -d teamkitcollection`
   - Sonda da API: `curl -i -s http://127.0.0.1:8000/health`

---

## 5. Coleta Mínima de Evidências Sanitizadas

Para auditoria por `AGT-001`, a coleta de evidências na futura execução operacional deverá limitar-se estritamente a:
1. Código de saída (`exit code`) do script (`0` ou `1`).
2. Status codes HTTP obtidos nas sondas (`200`, `503`).
3. Chaves estruturadas do payload JSON (ex: `status`, `database`, `error`), **proibindo expressamente** a reprodução de senhas, hashes de tokens, caminhos absolutos do host, variáveis de ambiente ou logs completos da aplicação que contenham dados sensíveis (SEC-003).

---

## 6. Diferenciação Clara entre Resultados Esperados e Resultados Comprovados (Matriz QA)

| ID do Teste (`TKC-PAR-0012`) | Descrição da Operação | Resultado Esperado (Oráculo Teórico) | Resultado Comprovado (Estado Atual) |
|---|---|---|---|
| `TST-01` | Sonda `/health` com banco íntegro | HTTP 200 (`{"status":"ok","database":"up"}`) | `VERIFICADO_POR_INSPECAO` (código estático); `NÃO_EXECUTADO` em runtime na VM. |
| `TST-02` | Sonda `/health` com banco desconectado | HTTP 503 (`{"status":"unhealthy","database":"down","error":"DB_UNAVAILABLE"}`) | `VERIFICADO_POR_INSPECAO` (lógica em `main.py` e `backend-lab.sh`); `NÃO_EXECUTADO` na VM. |
| `TST-03` | Recuperação translúcida (200 -> 503 -> 200) | Transição imediata sem restart do worker Uvicorn | `VERIFICADO_POR_INSPECAO` (testes unitários); `NÃO_EXECUTADO` na VM. |
| `TST-04` | Conectividade com timeout curto (`SELECT 1`) | Retorno tupla `(1,)` com connect_timeout/statement_timeout=3s | `VERIFICADO_POR_INSPECAO` (`db.py`); `NÃO_EXECUTADO` na VM. |
| `TST-05` | Persistência e volume PostgreSQL (`INSERT` / `RESTART` / `SELECT`) | Dados preservados no volume `tkc-postgres16-data` | `RELATADO` (ensaio anterior por HUMAN-001); `NÃO_EXECUTADO` por AGT-003. |
| `TST-06` | Isolamento de rede e binding em `127.0.0.1` | Porta 8000 em loopback; porta 5432 não publicada no host | `VERIFICADO_POR_INSPECAO` (compose/scripts); `NÃO_EXECUTADO` na VM. |
| `TST-07` | Preservação de volumes durante rebuild da API | Volume `tkc-postgres16-data` intocado (`--no-deps backend`) | `VERIFICADO_POR_INSPECAO` (`backend-lab.sh`, linha 198); `NÃO_EXECUTADO` na VM. |
| `TST-08` | Idempotência e tratamento de sinais (`errexit` / `trap`) | Scripts encerram ou recuperam sem corromper estado | `VERIFICADO_POR_INSPECAO` (`bash -n` e testes sintéticos Bash); `NÃO_EXECUTADO` na VM. |
| `TST-09` | Ausência de vazamento de segredos em erros | Nenhuma senha ou DSN no payload de erro | `VERIFICADO_POR_INSPECAO` (testes unitários); `NÃO_EXECUTADO` na VM. |
| `TST-10` | Execução integrada do cenário de falha (Opção 9) | Desconexão e reconexão bem-sucedidas via script | `NÃO_EXECUTADO` (aguardando autorização operacional). |

---

## 7. Escopo da Futura Autorização Operacional Proposta para HUMAN-001

- **Permitido exclusivamente:** Execução das opções **7 (`backend-check`)**, **8 (`backend-up`)** e **9 (`backend-fault`)** em janela exclusiva na VM Ubuntu.
- **Proibido estritamente:** Opção 5 (`pg-start`), reset de volumes, alteração de código ou infraestrutura fora dos scripts autorizados.
