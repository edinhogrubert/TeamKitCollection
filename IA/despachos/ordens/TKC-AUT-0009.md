# TKC-AUT-0009 — Autorização humana L2 para patch mínimo DevOps

**order_id:** `TKC-AUT-0009`  
**task_id:** `TKC-0009`  
**sender:** AGT-001 (preparação do despacho)  
**recipient / executor atribuído:** AGT-003 — DevOps/SRE, sessão receptora deverá revalidar sua identidade e capacidade Git  
**authorization_state:** `TRUE` para o escopo L2 EXATO descrito abaixo, recebido diretamente de HUMAN-001 nesta conversa; origem no repositório `MEDIADO`  
**human_decision:** "TKC-AUT-0009 #TRUE — Autorizo AGT-003 a corrigir somente scripts/infra/backend-lab.sh e scripts/infra/teamkit-lab.sh, com registros de comunicação da tarefa, testes estáticos e publicação no GitHub. Não autorizo executar Docker nem alterar PostgreSQL, volumes ou dados."  
**proposal_basis:** `TKC-PAR-0009` (publicado em `68813cd606570d8872f7cffaefe12e2d71c6c47b`, `APTO_COM_CONDICOES`)  
**preparation_claim:** `TKC-0009-C03`, AGT-001, somente despacho documental; reivindicação confirmada em `c1bf61086ed6194a4500c3283596e213b72cd127`  
**base_commit_for_executor:** verificar `main` no recebimento; base documental do despacho: `c1bf61086ed6194a4500c3283596e213b72cd127`; não confiar em SHA antigo após commits subsequentes  
**communication_paths:** `IA/tarefas/TKC-0009.md`, `IA/tarefas/indice.md`, `IA/despachos/logs/TKC-EXE-0009.md`, `IA/despachos/retornos/TKC-RET-0009.md` (somente registros da execução, progresso e resultados)  
**product_paths:** exclusivamente `scripts/infra/backend-lab.sh` e `scripts/infra/teamkit-lab.sh`  
**state:** `AUTORIZADA`, mas **ainda NÃO RECEBIDA pelo AGT-003**; não equivale a reivindicação nem execução iniciada.

## Missão técnica L2 — apenas alterações estáticas no GitHub

Corrigir os achados do parecer `TKC-PAR-0009`, sem ampliar o escopo:
1. **[A-01]** O menu deve continuar após uma opção retornar erro; preservar código e diagnóstico da falha para o operador. Não deixar `set -e` encerrar o menu inteiro indevidamente.
2. **[A-02]** Tornar `backend-up` idempotente: se a API estiver saudável, comunicar `OK` sem build/recriação; se existir mas estiver parada/falha, propor recuperação apenas da API, sem alterar PostgreSQL, sem excluir containers/volumes; evitar operações destrutivas e alterações irreversíveis. Quando a recuperação segura não puder ser assegurada, interromper com diagnóstico claro.
3. **[M-01]** Tratar falhas de `curl` no preflight de `backend-fault` sem queda silenciosa.
4. **[M-02]** Robustecer recuperação da rede `tkc-lab-net` ao receber `SIGINT`/`SIGTERM`, garantindo tentativa de reconexão, mensagem legível e cautela com sinais; reconhecer que SIGKILL, perda de energia e falha do daemon não podem ser corrigidos pelo trap.
5. **[M-03]** Diagnóstico precisa conferir modo `0600` das credenciais locais, conectividade da rede e retorno HTTP da API quando existir, sem imprimir segredo.
6. **[M-04]** Atualizar help do menu e revisão SHA imutável do script filho; evitar download de versão móvel, atualizar referências corretamente.

**Atenção a risco adicional:** identificar de forma estática se `backend-lab.sh` consegue operar com o env realmente gerado por `postgres16-lab.sh` (nomes de variáveis `POSTGRES_*`, correspondência com `config.py`), sem ler o segredo real. Se houver incompatibilidade que dependa de arquivo fora dos dois scripts autorizados, registrar `BLOQUEADA` e propor novo escopo, não editar outros caminhos.

## Restrições mandatórias

- **Proibido:** executar Docker, Compose ou mudanças de rede/containers na VM; modificar/excluir PostgreSQL `tkc-postgres16`, volume `tkc-postgres16-data` ou dados; abrir 5432; apagar ou recriar serviços; testar opções 8 e 9 operacionais; executar reset; usar Oracle, cloud externa ou gerar despesas; alterar backend, Dockerfile, Compose, governança, `AGENTS.md` e `IA/PROJETO.md`.
- **Permitido:** inspeção L0/L1, editar apenas dois scripts e registros de comunicação listados, `bash -n`, testes estáticos controlados que não invoquem daemon Docker e publicação no GitHub, após confirmação de posse.
- Custo adicional máximo: R$ 0,00. Jamais publicar credenciais, hashes de segredo, tokens ou conteúdo do env.
- Revisão independente e execução real na VM pertencem a etapas posteriores, com decisão humana própria.

## COM-001 — sequência obrigatória

1. AGT-003 recebe esta referência pela pessoa HUMANO-001, consulta a `main`, lê regras aplicáveis e revalida que os caminhos da tarefa estão livres. AGT-001 concluiu sua C03 documental antes de transferir.
2. Criar claim **`TKC-0009-C04`** (ou o próximo ID efetivamente livre), com estado `EM_EXECUCAO`, AGT-003, escopo e base, somente nos registros de comunicação; **publicar e confirmar** na `main` antes de editar os dois scripts.
3. Implementar patch nos dois scripts; executar `bash -n` e demais testes estáticos pertinentes, registrando comandos e saídas sanitizadas. Nunca declarar teste Docker ou HTTP como executado.
4. Publicar patch e evidência `TKC-EXE-0009` e `TKC-RET-0009`, atualizar índice e tarefa para `EM_REVISAO` com posse liberada. Documentar claramente limitações e o SHA exato publicado.
5. Encerrar para o humano: `TKC-RET-0009 PUBLICADA NO GIT — commit: <SHA>`. AGT-001 fará revisão dos commits.

**Critérios de aceite:** diff somente nos dois scripts e registros comunicacionais permitidos; sintaxe Bash PASS demonstrada; ausência de exclusão de volumes/containers do DB, publicação de 5432 ou uso de segredos; menu apresenta e recupera erros; reexecução idempotente sem mexer no banco; testes Docker na VM `NÃO_EXECUTADOS`; revisão independente ainda pendente.

**Estado de entrega:** ordem disponível no GitHub, mas AGT-003 somente a receberá quando HUMAN-001 transportar `TKC-AUT-0009` à sessão dele, conforme COM-002.
