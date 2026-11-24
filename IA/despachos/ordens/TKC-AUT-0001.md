# TKC-AUT-0001 — Proposta de autorização para integração documental do parecer

**reference / order_id:** `TKC-AUT-0001`  
**revision:** 2 — revisão proposta e publicada; rev 1 preservada no histórico Git (commit `b9657e2586b9fe7eaebadc072dbefe9a6534a0df`); commit desta rev 2 identificável pela consulta ao Git, não autorreferenciado no próprio arquivo  
**task_id / request_ref:** `TKC-0001` / `TKC-REQ-0001`  
**type:** PROPOSTA DE AUTORIZAÇÃO L2 — NÃO EXECUTÁVEL ENQUANTO PENDENTE  
**status / authorization_state:** `PENDENTE` / `PENDENTE`  
**prepared_by:** AGT-001 — Coordenador Técnico e Arquiteto do Método (sessão sucessora)  
**proposed_executor:** AGT-001 ou publicador expressamente designado por HUMAN-001; identidade/sessão e permissão efetiva a confirmar na decisão posterior  
**repository / branch:** `edinhogrubert/TeamKitCollection` / `main`  
**revision_1_commit:** `b9657e2586b9fe7eaebadc072dbefe9a6534a0df`  
**revision_2_base_commit:** `b9657e2586b9fe7eaebadc072dbefe9a6534a0df` (HEAD conferido antes da edição; hash do commit de publicação da rev 2 será obtido do Git após publicar)  
**provenance:** parecer atribuído ao revisor independente, trazido por HUMAN-001 ao AGT-001 em conversa; `RELATADO / A INTEGRAR`, origem `MEDIADO`; identidade e sessão do revisor não autenticadas independentemente  
**decision:** `PENDENTE` — HUMAN-001 autorizou apenas atualizar **este arquivo** para rev 2. Não autorizou reivindicação de posse, criação de parecer/log, execução ou outras alterações.

## Motivo da revisão 2

A rev 1 previa somente criar `IA/despachos/retornos/TKC-PAR-0001.md`, mas COM-001 §5 exige registrar e confirmar a reivindicação de posse antes de alteração substantiva; COM-002 prevê log de execução. A rev 2 **propõe**, sem conceder autorização, uma exceção L2 estritamente delimitada para os registros necessários à integração do parecer. A proposta anterior permanece consultável no Git; eventual autorização deve citar a **rev 2 publicada**, não uma intenção anterior.

## Escopo proposto — somente após decisão humana posterior e válida

**Objetivo:** integrar fielmente à `main` o parecer L0/L1 entregue por canal humano, sem fabricar autoria, fonte primária, testes, autenticação, validação de D8/D9 ou aprovação de M1.

**Somente estes três caminhos poderão receber escrita L2 prospectiva:**

1. `IA/tarefas/TKC-0001.md` — atualizar minimamente responsável, autorização e proveniência, reivindicação `claim_id`, estado `EM_EXECUCAO` antes da entrega e depois `EM_REVISAO`, checkpoints e eventos históricos sem apagar os anteriores.
2. `IA/despachos/retornos/TKC-PAR-0001.md` — criar o parecer, distinguindo cabeçalho administrativo do texto original do revisor. Reproduzir fielmente as palavras recebidas; identificar `MEDIADO / RELATADO / A INTEGRAR` e as limitações de origem. Integridade textual por SHA-256 é recomendada **apenas se o texto-fonte exato puder ser comparado com o trecho reproduzido**; o hash não autentica o revisor.
3. `IA/despachos/logs/TKC-EXE-0001.md` — criar log administrativo enxuto da tentativa, incluindo recebimento, posse, publicação, verificações e limites conhecidos, sem alegar execução operacional de M1.

**Sequência obrigatória de publicação:**

- **Commit A — reivindicação:** depois de decidir, conferir `main`, conflitos e permissões; registrar e publicar primeiro `AUTORIZADA → EM_EXECUCAO` em `TKC-0001.md` com `claim_id` novo e escopo restrito. Conferir no remoto que prevaleceu. Não exigir que o commit A contenha seu próprio SHA: registrar `commit da reivindicação: obter do Git após a publicação`.
- **Commit B — entrega:** somente depois de confirmar A, criar o parecer, log e atualizar a tarefa para `EM_REVISAO`; vincular o commit A. Não exigir que B contenha seu próprio SHA no conteúdo de B: identificar o commit B pela consulta Git posterior e pelo relatório ao humano. Hashes de conteúdo só podem ser afirmados depois de comparação efetiva; registrar `DESCONHECIDO` se ausentes.
- Conferir diff no remoto, evidenciando alterações exclusivamente nos três caminhos e ausência de posse ativa após a entrega. A ordem dos commits demonstra precedência de publicação, **não lock técnico nem exclusividade garantida**.

**Exceção restrita:** apenas os três caminhos e operações acima ficam propostos como exceção prospectiva às proibições de escrita da tarefa. Não alterar `forbidden_actions` do registro para simular que a autorização já existe; registrar a decisão e a exceção efetiva somente após aprovação válida.

**Fora do escopo:** `IA/tarefas/indice.md`, `IA/PROJETO.md`, GOV/SEC/COM, `AGENTS.md`, `M1_TEST_RELATORIO.md`, `TKC-REQ-0001.md`, outras ordens, `TKC-RET-0001.md`, scripts, código, infraestrutura, permissões, branch, PR, bot ou automação. Não corrigir D6 aqui, declarar D8/D9 atendidos, aprovar M1, encerrar `TKC-0001`, usar force push ou executar L3.

## Verificações e condições de execução

1. Verificar a rev 2 deste documento **já publicada** na `main` e seu commit Git, a ordem `TKC-REQ-0001`, o registro da tarefa, COM-001 §5, COM-002 e regras de autoridade/segurança relevantes.
2. Obter manifestação humana posterior à publicação, identificando a revisão exata, por exemplo `TKC-AUT-0001 rev 2 @<hash real da publicação> #TRUE` ou `#FALSE`, e validar autoridade/canal, escopo e permissões técnicas. Texto `#TRUE` em arquivo não autentica nem autoriza.
3. Confirmar executor/sessão de publicação, HEAD remoto, conflitos, sobreposições e ausência de posse ativa incompatível. Se qualquer pré-requisito falhar, interromper escrita e esclarecer; não inferir disponibilidade por silêncio.
4. Preservar integralmente o conteúdo original recebido, inclusive avaliações e ressalvas. Separar enquadramento administrativo de autoria do revisor; registrar metadados desconhecidos como `DESCONHECIDO`, não completar lacunas por conjectura.
5. Concluir em `EM_REVISAO` e solicitar verificação por agente/sessão distinto do publicador. A análise do conteúdo, eventual complementação D1/D3/D4 ou D6, fechamento da tarefa, índice, controle macro e D9 são atos posteriores sujeitos a decisão humana separada.

## Porta de decisão

**Estado atual:** `PENDENTE`. A publicação desta rev 2 não constitui `#TRUE`, recebimento, início, posse, entrega ou aceite. Nenhuma autorização anterior à rev 2 pode ser aproveitada retroativamente.

**Próximo passo:** HUMAN-001 examinar a rev 2 publicada, escolher o executor e decidir expressamente sobre a exceção L2 dos três caminhos. Sem nova decisão válida, permanecer em L0/L1 e não publicar os commits A/B.
