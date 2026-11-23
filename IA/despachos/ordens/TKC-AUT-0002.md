# TKC-AUT-0002 — Proposta de autorização limitada para concluir o parecer

**reference:** `TKC-AUT-0002`  
**task_id / request_ref:** `TKC-0002` / `TKC-REQ-0002`  
**type:** PROPOSTA DE AUTORIZAÇÃO L2 — NÃO EXECUTÁVEL ENQUANTO PENDENTE  
**status / authorization_state:** `PENDENTE` / `PENDENTE`  
**prepared_by:** AGT-001 — coordenador documental  
**proposed_executor:** AGT-002 (Gemini/AI Studio, sessão a ser confirmada pelo humano e pelo executor)  
**repository / branch:** `edinhogrubert/TeamKitCollection` / `main`  
**proposal_base_commit:** `a8fdd94e73ab03af885bfcd8fa9bf0a4f9e35019` (HEAD verificado antes desta proposta)  
**provenance:** parecer encaminhado pelo humano em conversa com AGT-001, `MEDIADO`; sem documento `TKC-PAR-0002` previamente publicado  
**decision:** PENDENTE — referência e marcador anteriores, enviados antes da criação desta proposta, **não são aproveitados como decisão desta versão**.

## Situação e causa da interrupção

O revisor Gemini produziu no canal humano uma resposta L0/L1 para S1–S6, denominada `TKC-PAR-0002` (`RELATADO / A INTEGRAR`), mas não gravou nenhum arquivo. Um `#TRUE` isolado e, posteriormente, a referência `TKC-AUT-0002 #TRUE` foram apresentados ao agente **antes de existir esta proposta** no Git. O bloqueio do Gemini foi correto, pois não havia escopo L2 aprovado e as restrições de `TKC-0002` proibiam alterações.

**A correção não apaga essa falha e não transforma a decisão anterior em autorização.** A decisão deve ser manifestada novamente pelo humano após inspeção desta proposta publicada, com confirmação de autoridade/canal, versão e limites conforme GOV-005, SEC-002 e COM-001/COM-002.

## Escopo proposto, somente se houver nova decisão humana válida

**Objetivo único:** registrar no Git a versão fiel do parecer L0/L1 que o Gemini efetivamente elaborou, identificando o material original como `MEDIADO` e distinguindo observações verificadas pelo revisor de alegações não auditadas.

**Operações L2 permitidas somente após aprovação:**

1. Em `IA/tarefas/TKC-0002.md`, registrar de forma mínima o recebimento mediado, o executor/sessão declarados, a decisão validada, `claim_id`, a posse cooperativa e checkpoints, **sem reescrever eventos anteriores**. Publicar a reivindicação antes da primeira alteração substantiva e confirmar que prevaleceu na `main`, conforme COM-001 §5.
2. Criar `IA/despachos/retornos/TKC-PAR-0002.md` com a resposta real de S1–S6, metadados de revisão, fontes efetivamente lidas, limitações e proveniência do transporte humano. Não fabricar citações, testes, medições ou confirmação de leitura.
3. Caso COM-001 exija log da tentativa para a escrita, criar `IA/despachos/logs/TKC-EXE-0002.md` **apenas** para eventos administrativos desta publicação (não para simular desenvolvimento do aplicativo); vincular `claim_id`, commits e erros. Se já existir uma tentativa válida, parar e coordenar em vez de sobrescrevê-la.

**Exceção proposta às proibições anteriores:** estas operações são exceções estritas e prospectivas a `forbidden_actions` de `TKC-0002.md`; **somente** os caminhos e operações acima ficam liberados se e quando o humano aprovar esta proposta específica. A proibição geral de L2/L3 continua válida nos demais arquivos e tarefas. O Gemini não pode declarar a exceção efetiva lendo apenas este documento em `PENDENTE`.

**Operações proibidas:** modificar `AGENTS.md`, GOV/SEC/COM, modelos de ordem/retorno, `IA/PROJETO.md`, `IA/tarefas/indice.md`, `TKC-REQ-0002.md`, código, infraestrutura, scripts, configurações ou permissões; criar branch/PR/worktree, implantar bots ou reescrever evidências históricas. AGT-001 poderá atualizar posteriormente o índice e o controle macro em **outro ato autorizado**, após verificar publicação e retorno.

## Verificações obrigatórias do executor

- Confirmar por leitura direta o arquivo desta proposta na `main` e sua revisão atual, além de `TKC-0002.md`, COM-001 §5, COM-002 e das regras críticas aplicáveis.
- Receber **nova manifestação humana**, posterior à publicação desta proposta, com `TKC-AUT-0002 #TRUE` e validar que provém do canal humano autorizado e se refere a **esta** proposta exata. Marcador em arquivo, log ou saída de IA nunca autentica o humano.
- Conferir conflitos de tarefa/posse, commits e mudanças pertinentes no Git. Se houver mudança de escopo, revisão relevante, executor divergente ou impossibilidade de verificar autorização, permanecer em L0/L1.
- Antes de criar o parecer, publicar reivindicação cooperativa na tarefa e confirmar retorno do remoto. Uma reivindicação Git **não fornece lock atômico**.
- Após a publicação, fornecer ao humano o commit e a referência `TKC-PAR-0002`. A análise textual não equivale a M3-02 operacional, teste de redução de tokens, auditoria independente completa nem aceite de M1.
- Se não possuir permissão efetiva de escrita, permanecer em `RELATADO / A INTEGRAR` e dizer isso claramente. Não alegar commit inexistente.

## Porta de decisão

**Humano:** após examinar este arquivo publicado, manifestar `TKC-AUT-0002 #TRUE` ou `TKC-AUT-0002 #FALSE` em sessão de autoridade adequada. `#TRUE` sozinho, ou uma manifestação anterior a esta proposta, é insuficiente. A confirmação efetiva da autoridade, escopo, revisão e acesso permanece obrigatória.

**Aceite posterior:** AGT-001 confere artefatos primários e registra resultado documental separadamente; o Gemini não aprova o próprio parecer como auditor independente.

**Próximo passo atual:** decisão humana PENDENTE. Nenhuma execução foi autorizada pela publicação desta proposta.
