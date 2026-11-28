# TKC-ROT-0010 — Roteiro Técnico L0/L1 para Validação Operacional do Laboratório (M3-02 / TKC-0010)

## 1. Identificação
- **task_id:** `TKC-0010`
- **return_id / doc_id:** `TKC-ROT-0010`
- **tipo:** `ROTEIRO TÉCNICO L0/L1` (preparação de validação operacional; **zero execução Docker ou VM**)
- **claim_id:** `TKC-0010-C05` (reivindicação cooperativa publicada em `origin/main` conforme COM-001)
- **agent_id / papel / ferramenta:** `AGT-003` — Engenheiro DevOps/SRE | Google AI Studio (`gemini-4-argon`)
- **origem da autorização:** `HUMAN-001` (autorização expressa para publicação do roteiro nos caminhos permitidos, sem execução de comandos na VM)
- **repositório / branch:** `edinhogrubert/TeamKitCollection` | `main`
- **base_commit:** `661c5d92be6b6969f54b74e9b067028210664198`
- **estado de saída:** `ENTREGUE` (`EM_REVISAO` por `AGT-001`)

---

## 2. Versão Atual dos Scripts e Revisões Fixadas

- **Orquestrador de Laboratório:** `scripts/infra/teamkit-lab.sh` (versão pós-patch `a2992ff` / `5426315`, contendo o isolamento de `errexit` em `run_menu_action()` e o endurecimento de `fetch_script()`).
- **Revisão Fixada de Scripts Auxiliares:** `SCRIPTS_REV="e26def6a4a2da84e57c88a4e384874e38c4cebc5"`
- **Revisão Fixada do Backend:** `BACKEND_REV="8d0cfa789f055f139c8f6efc06fe59f7ca71be8d"`
- **Parâmetros do Banco de Dados:** `PG_NAME="tkc-postgres16"`, `PG_VOLUME="tkc-postgres16-data"`, `PG_DB="teamkitcollection"`, `PG_USER="tkc_app"`.

---

## 3. Roteiro Integrado de Validação (Opções 7, 8 e 9) com a Matriz QA (`TKC-0012`)

O roteiro abaixo correlaciona as opções interativas do menu `teamkit-lab.sh` com os critérios da matriz de testes de `TKC-PAR-0012`:

| Opção do Menu | Ação Executada | Teste QA Correlacionado (`TKC-PAR-0012`) | Tipo de Operação |
|---|---|---|---|
| **7) Diagnosticar API e PostgreSQL** | `backend-check` | `TST-01`, `TST-04`, `TST-09` | Somente Leitura (Read-Only) |
| **8) Preparar rede e iniciar backend /health** | `backend-up` | `TST-03`, `TST-07` | Orquestração Controlada (Idempotente) |
| **9) Testar HTTP 503 e recuperação 200** | `backend-fault` | `TST-02`, `TST-10` | Simulação de Falha (State-Changing Temporário) |

---

## 4. Classificação de Comandos: Leitura vs. Alteradores de Estado

### A. Comandos Somente Leitura (Read-Only) — Opção 7 (`backend-check`)
1. Verifica a existência e permissão estricta `0600` do arquivo de credenciais `~/.config/teamkitcollection/postgres16.env`.
2. Executa `sudo docker inspect` e `docker port` para auditar o container `tkc-postgres16`.
3. Verifica se a interface de rede privada `tkc-lab-net` está ativa e se o banco está conectado a ela.
4. Realiza sonda passiva via `curl` no endpoint `http://127.0.0.1:8000/health`, verificando se a resposta HTTP é `200 OK` com carga `{"status":"ok","database":"up"}`.
- **Risco:** Zero. Nenhum container, arquivo ou dado é modificado.

### B. Comandos Alteradores de Estado / Orquestração — Opção 8 (`backend-up`)
1. Assegura a criação da bridge Docker isolada `tkc-lab-net`.
2. Conecta o container `tkc-postgres16` à rede privada (se ainda não conectado).
3. Avalia o estado do container Uvicorn (`tkc_lab-backend-1`):
   - Se saudável e respondendo `200`, reporta sucesso sem recompilar.
   - Se parado, executa `sudo docker start`.
   - Se ausente ou degradado, baixa a revisão imutável fixada (`BACKEND_REV`) e executa `docker compose up -d --build --no-deps backend`.
- **Risco:** Baixo. Atua **exclusivamente** sobre o serviço de API, mantendo o PostgreSQL e o volume `tkc-postgres16-data` intocados.

### C. Comandos de Simulação de Falha — Opção 9 (`backend-fault`)
1. Realiza preflight sondando o endpoint `/health` (`HTTP 200`).
2. Desconecta temporariamente o container `tkc-postgres16` da rede `tkc-lab-net` (`docker network disconnect`).
3. Testa o endpoint `/health` sob falha, exigindo resposta estática `HTTP 503` (`{"status":"unhealthy","database":"down","error":"DB_UNAVAILABLE"}`).
4. Restaura automaticamente a conectividade da rede (`docker network connect`) após ~5 segundos.
5. Valida o retorno à normalidade com nova sonda `/health` (`HTTP 200`).
- **Risco:** Baixo/Controlado. A interrupção de rede no banco é transiente e reversível por script ou comando manual.

---

## 5. Pré-condições, Resultados Esperados, Evidências e Critérios de Interrupção

- **Pré-condições operacionais:**
  - Operador `HUMAN-001` autenticado na VM Ubuntu 24.04 com privilégios `sudo` e acesso ao daemon Docker.
  - Instância PostgreSQL `tkc-postgres16` previamente iniciada (Opção 5 do menu ou `postgres16-lab.sh --start`).
- **Resultados Esperados:**
  - Sete testes integrados sem vazamento de stack traces, credenciais ou portas públicas desprotegidas no host.
- **Coleta de Evidências Exigidas:**
  - Captura textual das saídas de `bash scripts/infra/teamkit-lab.sh menu` para as opções 7, 8 e 9.
  - Logs consolidados do container backend (`sudo docker logs tkc_lab-backend-1`).
- **Critérios de Interrupção (Abort Criteria):**
  - Qualquer falha de sintaxe Bash, erro inesperado de `errexit`, vazamento de variáveis de ambiente no corpo HTTP 503, ou tentativa de execução de comandos de remoção de volumes (`docker volume rm`, `down -v`).

---

## 6. Procedimento de Recuperação (Disaster Recovery e Preservação de Volume)

Caso ocorra interrupção abrupta (ex: queda de energia, `SIGKILL` ou interrupção de rede durante a Opção 9):
1. **Verificar integridade do banco e volume:**
   ```bash
   sudo docker ps -a --filter name=tkc-postgres16
   sudo docker volume inspect tkc-postgres16-data
   ```
2. **Garantir conectividade de rede privada:**
   ```bash
   sudo docker network connect tkc-lab-net tkc-postgres16 || true
   ```
3. **Reiniciar a API de forma segura sem tocar nos dados:**
   ```bash
   bash scripts/infra/teamkit-lab.sh backend-up
   ```
4. **Validar o sistema:**
   ```bash
   bash scripts/infra/teamkit-lab.sh backend-check
   ```
*Nota:* O volume `tkc-postgres16-data` e o container `tkc-postgres16` permanecem preservados em qualquer cenário de falha do script de laboratório.

---

## 7. Proposta de Autorização Operacional Específica (`TKC-AUT-0010-OP`)

Para a futura execução deste roteiro na VM por `HUMAN-001`, propõe-se a emissão da ordem de autorização restrita contendo:
- **Escopo Autorizado:** Execução interativa ou direta exclusivamente das opções **7 (`backend-check`)**, **8 (`backend-up`)** e **9 (`backend-fault`)** do script `scripts/infra/teamkit-lab.sh`.
- **Proibições Expressas:** Proibido executar comandos de reset, remoção de volumes, alteração de código Python, exposição de portas no host ou desativação de controles TLS.

### Caminhos Documentais Necessários para Futuro Registro de Execução:
1. `IA/despachos/ordens/TKC-AUT-0010-OP.md`
2. `IA/despachos/logs/TKC-EXE-0010-OP.md`
3. `IA/despachos/retornos/TKC-RET-0010-OP.md`
4. `IA/tarefas/TKC-0010.md` e `IA/tarefas/indice.md`
