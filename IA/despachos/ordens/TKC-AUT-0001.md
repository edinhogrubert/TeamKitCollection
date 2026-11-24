# TKC-AUT-0001 — Proposta de autorização para integração documental do parecer

**reference / order_id:** `TKC-AUT-0001`  
**task_id / request_ref:** `TKC-0001` / `TKC-REQ-0001`  
**type:** PROPOSTA DE AUTORIZAÇÃO L2 — NÃO EXECUTÁVEL ENQUANTO PENDENTE  
**status / authorization_state:** `PENDENTE` / `PENDENTE`  
**prepared_by:** AGT-001 — Coordenador Técnico e Arquiteto do Método (nova sessão)  
**proposed_executor:** AGT-001 ou publicador expressamente designado por HUMAN-001, a confirmar em decisão posterior  
**repository / branch:** `edinhogrubert/TeamKitCollection` / `main`  
**proposal_base_commit:** `af339d77f624a5745152035e2dfa1ab0b61fb645` (HEAD consultado antes desta publicação)  
**provenance:** parecer `TKC-PAR-0001` recebido por AGT-001 no canal humano, classificado `RELATADO / A INTEGRAR` e `MEDIADO`; não autenticado como sessão do revisor por evidência independente  
**decision:** `PENDENTE` — HUMAN-001 autorizou somente preparar e publicar **esta proposta**. Não autorizou a publicação do parecer ou qualquer outra modificação.

## Objeto e limites da proposta

A ordem `TKC-REQ-0001` solicita avaliação independente de D2 e D5–D8 de M1 e de consistência COM/GOV/SEC em L0/L1. Uma resposta foi entregue por canal humano, sem commit. Sua preparação analítica foi L0/L1; a publicação em Git é L2 e exige autorização específica e permissão técnica.

**Objetivo único da autorização futura:** integrar fielmente o conteúdo do parecer mediado na `main`, sem lhe atribuir autenticidade, independência comprovada por Git, testes, aprovação de M1 ou evidências que não estejam disponíveis.

**Único artefato substantivo proposto para escrita L2, após nova decisão válida:**

- Criar `IA/despachos/retornos/TKC-PAR-0001.md` com identificação da tarefa e da ordem, corpo integral do parecer recebido (sem mudanças substanciais), origem `MEDIADO / RELATADO / A INTEGRAR`, limites de verificação e commit de publicação. Qualquer contextualização adicional deve ser distinguida do texto original do revisor.

**Não autorizados por esta proposta:** editar `IA/tarefas/TKC-0001.md`, `IA/tarefas/indice.md`, `IA/PROJETO.md`, COM/GOV/SEC, `M1_TEST_RELATORIO.md`, criar `TKC-EXE-0001.md` ou `TKC-RET-0001.md`, alterar outras ordens, criar branches/PRs, executar scripts, mudar permissões, criar automações, executar L3, declarar D8/D9 satisfeitos, encerrar `TKC-0001` ou aprovar M1. Qualquer dessas mudanças requer escopo e decisão humanos separados.

**Dependência de COM-001:** antes de qualquer escrita substantiva, o eventual executor deverá observar COM-001 §5 (atribuição, decisão, verificação de conflito e reivindicação de posse publicada). Como o escopo desta proposta não inclui edição do registro de tarefa nem log de reivindicação, **não se deve contornar COM-001 para publicar o parecer**. Se o cumprimento da reivindicação exigir modificar outro arquivo, solicitar previamente autorização humana complementar e específica. A autorização futura deste único arquivo, isoladamente, não elimina essa dependência.

## Verificações antes da eventual execução

1. Ler esta proposta efetivamente publicada na `main` e confirmar seu commit, a ordem `TKC-REQ-0001`, o registro `TKC-0001`, COM-001 e COM-002 aplicáveis.
2. Receber manifestação humana **posterior** à publicação, referida a esta versão exata (por exemplo, `TKC-AUT-0001 #TRUE` ou `#FALSE`); o marcador não autentica identidade nem substitui confirmação de autoridade/canal, escopo, revisão e permissão técnica.
3. Revalidar HEAD, conteúdo-fonte do parecer, possíveis conflitos e eventual sobreposição de tarefas. Em caso de mudança material ou falta de autorização suficiente, interromper escrita e permanecer L0/L1.
4. Publicar somente com reivindicação válida conforme COM-001 e autorização L2 suficiente para todos os atos necessários. Conferir depois no remoto os caminhos alterados e os commits; não presumir entrega ou aceite.
5. Submeter o arquivo publicado à revisão distinta, preservando os achados de D6, as limitações de D8 e a pendência de D9. Não converter parecer mediado em prova de identidade do revisor.

## Porta humana de decisão

**Estado presente:** `PENDENTE`. Esta proposta **não autoriza** execução, posse, criação do parecer ou atualização de estado. Não aproveitar manifestações `#TRUE` anteriores à sua publicação.

**Próximo passo:** HUMAN-001 examinar a proposta publicada e decidir seu escopo exato, considerando se será necessária autorização adicional para a reivindicação COM-001. Somente depois de decisão válida e dos controles de execução cabíveis poderá ocorrer qualquer publicação de `TKC-PAR-0001`.
