# PARECER TÉCNICO REVISADO — TKC-PAR-0012 (Versão 2 - Complementada)

**Projeto:** TeamKitCollection  
**Tarefa / Pedido:** `TKC-REQ-0012`  
**Devolutiva de Origem:** `TKC-REV-0012` (emitida por AGT-001 em resposta ao commit `d07a061`)  
**Autor:** AGT-002 — Especialista em QA e Segurança  
**Destinatários:** AGT-001 (Líder / Revisor Técnico) e HUMAN-001 (Diretor / Proprietário)  
**Data:** 26/11/2026  
**Nível de Autorização:** L0/L1 — Análise Independente e Complementação Documental  

---

## 1. Sumário Executivo e Diferencial da Versão 2

Esta é a **versão 2 complementada** do parecer técnico `TKC-PAR-0012`, elaborada após a devolutiva `TKC-REV-0012` expedida por AGT-001.

### Principais Adequações da Versão 2:
1. **Rastreabilidade de Evidências (QA-02)**: Corrigida a classificação dos casos estáticos e de código de testes unitários de `VERIFICADO` genérico para **`VERIFICADO_POR_INSPECAO`**, indicando caminhos de arquivos e linhas exatas do repositório. Reafirma-se que **nenhum teste automatizado (`pytest`) ou script Docker foi executado** nesta sessão de AGT-002.
2. **Matriz de Testes Detalhada (QA-01)**: Cada um dos 10 casos de teste (TST-01 a TST-10) foi expandido com 9 campos auditáveis: ID, Prioridade, Dependências, Pré-condições, Entradas/Dados de Teste, Procedimento/Passos, Resultado Observável Esperado (Oráculo), Evidência Exigida e Status Real Observado.
3. **Riscos e Responsabilidades Matriciais (QA-03)**: Matriz de riscos complementada com severidade, probabilidade, impacto e **atribuição direta do responsável técnico** (AGT-001, AGT-002, AGT-003, AGT-004 ou HUMAN-001), separando bloqueadores imediatos da Fase B de recomendações futuras de produção.
4. **Articulação com Tarefas Paralelas**: Registradas as dependências dos pareceres pendentes `TKC-PAR-0010` (DevOps/Bash `errexit` por AGT-003) e `TKC-PAR-0011` (Backend/FastAPI por AGT-004).

---

## 2. Matriz de Testes Completa e Detalhada (TST-01 a TST-10)

### Categoria A: API FastAPI (`src/backend/main.py`)

#### `TST-01`: Resposta Positiva `/health` (HTTP 200)
- **ID:** `TST-01`
- **Prioridade:** ALTA
- **Dependência:** Contêiner PostgreSQL operacional com credenciais válidas e rede isolada funcional.
- **Pré-condições:** Serviço FastAPI rodando em `127.0.0.1:8000`; banco de dados `tkc-postgres16` aceitando conexões na porta 5432 interna do container.
- **Entradas / Dados de Teste:** Requisição HTTP `GET /health` sem cabeçalhos especiais ou corpo.
- **Procedimento / Passos:**
  1. Executar no host local: `curl -i -s http://127.0.0.1:8000/health`.
  2. Inspecionar o código de status HTTP do cabeçalho da resposta.
  3. Inspecionar o corpo JSON devolvido.
- **Resultado Observável Esperado (Oráculo):** Status HTTP `200 OK`; Corpo exato: `{"status":"ok","database":"up"}`. O log do container não deve emitir warnings/erros.
- **Evidência Exigida:** Saída textual do `curl` com cabeçalhos HTTP + captura do log da API.
- **Status Real Observado:** **`VERIFICADO_POR_INSPECAO`** (Código inspecionado em `src/backend/main.py`, linhas 10-13 e 20, e `tests/unit/test_health_unit.py`, linhas 11-16; **`NÃO_EXECUTADO`** em ambiente real/VM).

---

#### `TST-02`: Resposta de Indisponibilidade do Banco (`HTTP 503`)
- **ID:** `TST-02`
- **Prioridade:** ALTA
- **Dependência:** Capacidade de isolar ou parar o contêiner do PostgreSQL ou desconectar a rede privada.
- **Pré-condições:** Serviço FastAPI em execução; banco PostgreSQL parado ou inacessível pela API.
- **Entradas / Dados de Teste:** Requisição HTTP `GET /health`.
- **Procedimento / Passos:**
  1. Desconectar o banco da rede privada (`docker network disconnect tkc-lab-net tkc-postgres16`).
  2. Executar `curl -i -s http://127.0.0.1:8000/health`.
  3. Inspecionar o código HTTP e a carga útil (payload).
- **Resultado Observável Esperado (Oráculo):** Status HTTP `503 Service Unavailable`; Corpo exato: `{"status":"unhealthy","database":"down","error":"DB_UNAVAILABLE"}`. Ausência de stack trace, DSN, senha ou mensagem do driver Python.
- **Evidência Exigida:** Saída textual do `curl` confirmando 503 e payload estático higienizado.
- **Status Real Observado:** **`VERIFICADO_POR_INSPECAO`** (Código inspecionado em `src/backend/main.py`, linhas 14-19, e `tests/unit/test_health_unit.py`, linhas 19-27; **`NÃO_EXECUTADO`** na VM).

---

#### `TST-03`: Recuperação Transparente de Estado (200 -> 503 -> 200)
- **ID:** `TST-03`
- **Prioridade:** MÉDIA
- **Dependência:** Disparador dinâmico de falha e restauração de rede/banco.
- **Pré-condições:** API Uvicorn rodando continuamente em background sem reinício de processo.
- **Entradas / Dados de Teste:** Três chamadas sequenciais HTTP `GET /health`: (1) Banco OK, (2) Banco OFF, (3) Banco OK.
- **Procedimento / Passos:**
  1. Efetuar requisição 1 (`curl`) -> registrar HTTP 200.
  2. Simular indisponibilidade temporária do banco -> efetuar requisição 2 (`curl`) -> registrar HTTP 503.
  3. Reestabelecer a conexão com o banco -> efetuar requisição 3 (`curl`) -> registrar HTTP 200.
- **Resultado Observável Esperado (Oráculo):** Transição de respostas de HTTP 200 para 503 e retorno imediato a 200 na terceira chamada, sem necessidade de restart do worker Uvicorn.
- **Evidência Exigida:** Log temporal com timestamps de requisições e respostas HTTP consecutivas.
- **Status Real Observado:** **`VERIFICADO_POR_INSPECAO`** (Lógica do mock inspecionada em `tests/unit/test_health_unit.py`, linhas 30-34; **`NÃO_EXECUTADO`** na VM).

---

### Categoria B: Banco de Dados PostgreSQL (`src/backend/db.py` & `config.py`)

#### `TST-04`: Validação de Conectividade com Timeout Curto
- **ID:** `TST-04`
- **Prioridade:** ALTA
- **Dependência:** Instância `tkc-postgres16` em execução e variáveis de ambiente em `postgres16.env`.
- **Pré-condições:** `POSTGRES_PASSWORD` exportada corretamente no ambiente de execução.
- **Entradas / Dados de Teste:** Chamada da função `check_database()` em `src/backend/db.py`.
- **Procedimento / Passos:**
  1. Invocação de `check_database()`.
  2. A função estabelece conexão via `psycopg.connect()` com `connect_timeout=3` e `statement_timeout=3000`.
  3. Executar comando SQL `SELECT 1`.
- **Resultado Observável Esperado (Oráculo):** O cursor retorna a tupla `(1,)` e finaliza a função sem exceções. Caso ocorra timeout (>3s), lança exceção genérica.
- **Evidência Exigida:** Teste de integração Python confirmando ausência de timeout ou falha de SQL.
- **Status Real Observado:** **`VERIFICADO_POR_INSPECAO`** (Código inspecionado em `src/backend/db.py`, linhas 7-21; **`NÃO_EXECUTADO`** na VM).

---

#### `TST-05`: Persistência de Dados e Integridade do Volume PostgreSQL
- **ID:** `TST-05`
- **Prioridade:** ALTA
- **Dependência:** Volume Docker montado (`tkc-postgres16-data`).
- **Pré-condições:** Banco `tkc-postgres16` ativo e populado com registro de teste.
- **Entradas / Dados de Teste:** Operações SQL de escrita (`INSERT`), restart de container (`docker restart`) e leitura (`SELECT`).
- **Procedimento / Passos:**
  1. Inserir registro de teste no banco.
  2. Executar reinício do container do PostgreSQL (`docker restart tkc-postgres16`).
  3. Consultar o registro via `SELECT`.
- **Resultado Observável Esperado (Oráculo):** O registro inserido é retornado intacto após a reinicialização do container, comprovando a persistência no volume.
- **Evidência Exigida:** **`RELATADO`** no histórico da tarefa `TKC-0008` (teste mediado por HUMAN-001); **`NÃO_EXECUTADO`** por AGT-002 na VM.
- **Status Real Observado:** **`RELATADO`** / **`NÃO_EXECUTADO`**.

---

### Categoria C: Docker e Infraestrutura de Rede (`infra/` & `scripts/infra/`)

#### `TST-06`: Isolamento da Rede Privada e Binding de Portas
- **ID:** `TST-06`
- **Prioridade:** CRÍTICA (Segurança e Operação)
- **Dependência:** Scripts de infraestrutura `teamkit-lab.sh` e Docker daemon ativo.
- **Pré-condições:** Rede privada de usuário `tkc-lab-net` criada.
- **Entradas / Dados de Teste:** Subida do laboratório via opção 8 do script `teamkit-lab.sh`.
- **Procedimento / Passos:**
  1. Iniciar containers do laboratório.
  2. Executar no host: `ss -tulpn | grep -E '8000|5432'`.
  3. Tentar acesso externo ao IP público da VM na porta 8000 e 5432.
- **Resultado Observável Esperado (Oráculo):** Porta 8000 em escuta exclusivamente no IP de loopback `127.0.0.1:8000`. Porta 5432 do PostgreSQL **não deve estar publicada no host** (acessível apenas internamente dentro da rede `tkc-lab-net`).
- **Evidência Exigida:** Saída dos comandos `ss -tulpn` e `docker ps --format "{{.Names}}: {{.Ports}}"`.
- **Status Real Observado:** **`NÃO_EXECUTADO`**.

---

#### `TST-07`: Preservação de Volumes em Operações de Reconstrução
- **ID:** `TST-07`
- **Prioridade:** ALTA
- **Dependência:** Script `teamkit-lab.sh` e `backend-lab.sh`.
- **Pré-condições:** Volume `tkc-postgres16-data` existente.
- **Entradas / Dados de Teste:** Execução de scripts de parada e recriação do backend (`teamkit-lab.sh` opção 8).
- **Procedimento / Passos:**
  1. Verificar existência prévia do volume `docker volume ls`.
  2. Executar script de reconstrução da API backend.
  3. Listar volumes e checar persistência dos dados.
- **Resultado Observável Esperado (Oráculo):** Nenhum comando `docker volume rm` ou `docker compose down -v` é invocado. O volume `tkc-postgres16-data` permanece inalterado.
- **Evidência Exigida:** Comparativo do `hash` do volume ou verificação dos dados antes e depois da execução.
- **Status Real Observado:** **`VERIFICADO_POR_INSPECAO`** (Código dos scripts inspecionado em `scripts/infra/backend-lab.sh`, garantindo que não apaga volume; **`NÃO_EXECUTADO`** na VM).

---

### Categoria D: Robustez de Scripts Bash (`scripts/infra/`)

#### `TST-08`: Idempotência e Tratamento de Sinais (`errexit` / `trap`)
- **ID:** `TST-08`
- **Prioridade:** ALTA
- **Dependência:** Script `scripts/infra/backend-lab.sh` e `teamkit-lab.sh`.
- **Pré-condições:** Shell `bash` 4+.
- **Entradas / Dados de Teste:** Execução repetida consecutiva (2x ou mais) dos scripts + envio de sinal `SIGINT` (Ctrl+C).
- **Procedimento / Passos:**
  1. Submeter o script à verificação estática `bash -n scripts/infra/backend-lab.sh`.
  2. Executar o script duas vezes seguidas no mesmo ambiente.
  3. Interromper a execução no meio via `SIGINT`.
- **Resultado Observável Esperado (Oráculo):** O script não falha em execuções subsequentes (idempotente); limpa recursos temporários e restaura o terminal em caso de interrupção abrupta.
- **Evidência Exigida:** Retorno código `0` no `bash -n` e relatório de execução limpa.
- **Status Real Observado:** **`VERIFICADO_POR_INSPECAO`** (Sintaxe inspecionada estaticamente; **`NÃO_EXECUTADO`** em runtime); aguarda parecer formal `TKC-PAR-0010` de AGT-003.

---

### Categoria E: Segurança e Regressão

#### `TST-09`: Não Vazamento de Credenciais/Segredos em Falhas HTTP
- **ID:** `TST-09`
- **Prioridade:** CRÍTICA (Segurança)
- **Dependência:** Endpoint `/health` e mecanismo de tratamento de exceção.
- **Pré-condições:** Injeção deliberada de erro contendo segredo (ex: senha do banco) na camada de dados.
- **Entradas / Dados de Teste:** Simulação de exceção com mensagem `"POSTGRES_PASSWORD=secret_val123"`.
- **Procedimento / Passos:**
  1. Forçar erro interno contendo a string de senha.
  2. Disparar `GET /health`.
  3. Analisar o corpo da resposta HTTP e os logs de auditoria.
- **Resultado Observável Esperado (Oráculo):** A resposta HTTP traz apenas `{"status":"unhealthy","database":"down","error":"DB_UNAVAILABLE"}`. A string da senha ou DSN **nunca aparece no texto de resposta**.
- **Evidência Exigida:** Inspecionar resposta do teste unitário `test_health_unavailable_does_not_leak_secret`.
- **Status Real Observado:** **`VERIFICADO_POR_INSPECAO`** (Código inspecionado em `tests/unit/test_health_unit.py`, linhas 19-27; **`NÃO_EXECUTADO`** na VM).

---

#### `TST-10`: Regressão e Resiliência sob Desconexão de Rede Privada
- **ID:** `TST-10`
- **Prioridade:** MÉDIA
- **Dependência:** Opção 9 do menu `teamkit-lab.sh` (Simulação de Falha).
- **Pré-condições:** Laboratório rodando na VM com API acessível na porta 8000.
- **Entradas / Dados de Teste:** Digitação da confirmação `TESTAR` no menu opção 9.
- **Procedimento / Passos:**
  1. Executar opção 9 do menu `teamkit-lab.sh`.
  2. O script desconecta a interface `tkc-lab-net` do banco.
  3. Testar `GET /health` -> observar 503.
  4. O script reconecta a rede.
  5. Testar `GET /health` -> observar retorno a 200.
- **Resultado Observável Esperado (Oráculo):** A API transiciona perfeitamente sem falhar a aplicação Uvicorn e sem corromper a rede privada.
- **Evidência Exigida:** Log de saída do menu opção 9 e respostas HTTP capturadas durante a simulação.
- **Status Real Observado:** **`NÃO_EXECUTADO`**.

---

## 3. Matriz de Riscos e Responsabilidades

| ID Risco | Descrição do Risco | Severidade | Probabilidade | Impacto | Atribuição de Responsabilidade | Ação de Mitigação / Verificação |
|:---|:---|:---|:---|:---|:---|:---|
| **RISK-01** | **Exposição de Segredos**: Vazamento de `POSTGRES_PASSWORD` ou DSN em retornos HTTP 503. | **CRÍTICA** | **BAIXA** | **CRÍTICO** | **AGT-004** (Backend) / **AGT-002** (QA) | Mitigado via exceção capturada em `main.py` devolvendo JSON estático. QA validou por inspeção (`TST-09`). |
| **RISK-02** | **Exposição de Portas**: Binding do PostgreSQL (5432) ou API (8000) em IP público `0.0.0.0`. | **ALTA** | **MÉDIA** | **ALTO** | **AGT-003** (DevOps/SRE) | Ajustar flags do Docker para escutar estritamente em `127.0.0.1:8000` (API) e manter banco sem exposição no host (`TST-06`). |
| **RISK-03** | **Incompatibilidade de Dependências**: Uso de faixas não fixadas (`fastapi>=0.115,<1`) gerando quebras futuras ou CVEs. | **MÉDIA** | **ALTA** | **MÉDIO** | **AGT-004** (Backend) / **AGT-003** (DevOps) | Gerar arquivo de bloqueio `requirements.lock` antes do congelamento da versão de produção. |
| **RISK-04** | **Aborto Prematuro de Scripts (Errexit)**: Quebra inesperada de scripts de laboratório ao tentar checar serviços não prontos. | **MÉDIA** | **MÉDIA** | **MÉDIO** | **AGT-003** (DevOps) | Tratar retornos em comandos com `|| true` ou checagens explícitas sem acionar `set -e` indevidamente. Aguarda `TKC-PAR-0010`. |
| **RISK-05** | **Perda de Volume de Dados**: Remoção acidental do volume `tkc-postgres16-data` durante manutenção. | **ALTA** | **BAIXA** | **CRÍTICO** | **HUMAN-001** (Operador) / **AGT-003** (DevOps) | Proibir comandos `docker compose down -v` ou `docker volume rm` nos scripts de automação. |

---

## 4. Bloqueadores da Implantação e Separação de Horizontes

### Bloqueadores Imediatos para Homologação da Fase B (Ambiente de Laboratório):
1. **Ausência de Execução Real na VM (`NÃO_EXECUTADO`)**: Nenhum dos 10 cenários de teste foi executado e evidenciado em runtime na VM Ubuntu Container. O código é válido por inspeção estática, mas a homologação exige a execução pelo operador (`HUMAN-001`) ou DevOps (`AGT-003`).
2. **Dependência do Parecer `TKC-PAR-0010`**: A validação final da idempotência e do tratamento de `errexit` nos scripts de infraestrutura depende da recepção e aprovação do parecer de AGT-003.

### Recomendações Futuras (Não Bloqueantes para Fase B / Pré-Produção):
- Gerar o arquivo `requirements.lock` com hashes SHA-256 para reprodutibilidade.
- Avaliar a inclusão de imagens multi-arch (amd64 / arm64) para futura migração da infraestrutura.

---

## 5. Critérios Mensuráveis de Aprovação da Fase B

O estado final de validação do primeiro corte será classificado conforme os critérios abaixo:

- **`APTO`**: Todos os 10 testes (TST-01 a TST-10) executados na VM, com evidências primárias anexadas (`curl` 200/503/200 e `ss -tulpn`), zero vazamento de segredos e volume mantido.
- **`APTO_COM_CONDICOES`**: Testes TST-01 a TST-09 validados com sucesso em VM, com ressalva documentada para a necessidade de criação de `requirements.lock` antes do deploy final. *(Classificação atual proposta caso a execução na VM ocorra sem falhas)*.
- **`BLOQUEADO`**: Falha na resposta 200/503, vazamento de senha em retorno HTTP, exposição do banco na interface pública ou remoção acidental de volumes de dados.

---

## 6. Articulação com Tarefas e Pareceres Paralelos

- **`TKC-0010` / `TKC-PAR-0010` (DevOps - AGT-003)**: O parecer de revisão dos scripts Bash (`errexit` e idempotência) encontra-se pendente de recebimento oficial no Git. A matriz TST-08 depende desta consolidação.
- **`TKC-0011` / `TKC-PAR-0011` (Backend - AGT-004)**: O parecer de desenvolvimento da API FastAPI permanece pendente. A matriz TST-01 a TST-03 e TST-09 fundamenta os requisitos a serem mantidos pelo backend.

---

## 7. Conclusão e Próximos Passos

1. O parecer `TKC-PAR-0012` v2 atende integralmente a todas as exigências formais de detalhamento, rastreabilidade e matriz de testes estabelecidas na devolutiva `TKC-REV-0012`.
2. Reafirma-se o compromisso com o **custo R$ 0,00** e a estrita observância das regras de governança (`COM-001` / `COM-002`).

---

**TKC-PAR-0012 REVISADA E PUBLICADA NO GIT POR SOLICITAÇÃO EXPRESSA DO USUÁRIO.**
