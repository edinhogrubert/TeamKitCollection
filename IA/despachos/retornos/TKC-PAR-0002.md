# TKC-PAR-0002 — Parecer L0/L1 de sincronização incremental e custo de contexto

## Identificação
- **task_id:** `TKC-0002` ([`IA/tarefas/TKC-0002.md`](../../tarefas/TKC-0002.md))
- **order_id / ref curta:** `TKC-REQ-0002` ([`IA/despachos/ordens/TKC-REQ-0002.md`](../ordens/TKC-REQ-0002.md)) | publicação L2 autorizada por `TKC-AUT-0002` ([`IA/despachos/ordens/TKC-AUT-0002.md`](../ordens/TKC-AUT-0002.md))
- **report_id:** `TKC-PAR-0002`
- **tipo:** `PARECER L0/L1` (ensaio de mesa; publicação documental autorizada posteriormente em L2 restrito)
- **claim_id:** `TKC-0002-C01` (reivindicação cooperativa publicada no commit `7fdd127d0c5c63cb41a617934de2a0fbae13faf3`)
- **agent_id / papel / ferramenta / session_ref:** `AGT-002` / Revisor e Implementador Documental / Gemini (Google AI Studio) / `ais-session-agt002-tkc0002`
- **origem da ordem / evidência da autorização:**
  - Pedido `TKC-REQ-0002` transportado por `HUMAN-001` no chat (`MEDIADO`), lido pelo agente via acesso Git `DIRETO` (`VERIFICADO`) no commit `a8fdd94e73ab03af885bfcd8fa9bf0a4f9e35019`.
  - Primeiro marcador `#TRUE` isolado e segundo marcador `TKC-AUT-0002 #TRUE` (enviados antes de existir `TKC-AUT-0002.md` no Git): **BLOQUEADOS** por `AGT-002` em conformidade com `COM-002`, `GOV-005` e `SEC-002`.
  - Nova manifestação `TKC-AUT-0002 #TRUE` (`MEDIADO` no canal humano): recebida **após** publicação e conferência direta de `IA/despachos/ordens/TKC-AUT-0002.md` no commit `e6f7c4db8b47599b4964179e0ffbafd3a3a6843e`.
- **repositório / branch:** `edinhogrubert/TeamKitCollection` / `main`
- **base_commit simulado no cenário:** `64c8686925e41551b68cb1bcc5c890bfd51578ce` (hipótese do ensaio; **não** representa memória ou leitura prévia comprovada desta sessão)
- **target_rules_commit do cenário:** `f50ad9f891d7d2c638db7a62f537605822590c66`
- **HEAD na elaboração original do parecer L0/L1:** `a8fdd94e73ab03af885bfcd8fa9bf0a4f9e35019` (`VERIFICADO`)
- **HEAD na validação de `TKC-AUT-0002` / posse `TKC-0002-C01`:** `e6f7c4db8b47599b4964179e0ffbafd3a3a6843e` → `7fdd127d0c5c63cb41a617934de2a0fbae13faf3` (`VERIFICADO`)
- **estado de saída:** `PARECER PUBLICADO — EM_REVISAO` (`RELATADO` pelo executor até conferência de `AGT-001`)

---

## Metadados de sincronização incremental (`COM-001` §7.3)
- **rules_checked_commit:** `e6f7c4db8b47599b4964179e0ffbafd3a3a6843e` (e `a8fdd94e73ab03af885bfcd8fa9bf0a4f9e35019` no momento da resposta inicial no chat)
- **rules_scope:** `AGENTS.md` (§5 Etapa 2 e §10), `IA/regras/comunicacao.md` (§7.3) e `IA/despachos/README.md` (seção *Contexto mínimo e revisão de regras*), inspecionados por `git diff` no momento do ensaio `S1–S6` (com leitura complementar de `COM-001` e `COM-002` durante a validação de bloqueio de `#TRUE`).
- **rules_check_status:** `MUDANCA_RELEVANTE` no intervalo simulado `64c8686..f50ad9f`; `ATUALIZADO` nos intervalos `f50ad9f..a8fdd94` e `a8fdd94..e6f7c4d` (`0` arquivos normativos alterados).
- **rules_diff_ref:** `64c8686925e41551b68cb1bcc5c890bfd51578ce..f50ad9f891d7d2c638db7a62f537605822590c66`

---

## Respostas aos Cenários (`S1`–`S6` — versão fiel elaborada em `L0/L1`)

### S1 — Revisão antiga (`64c8686..f50ad9f`)
Entre `64c8686925e41551b68cb1bcc5c890bfd51578ce` e `f50ad9f891d7d2c638db7a62f537605822590c66` mudaram **3 arquivos normativos** (além de `IA/PROJETO.md`, que é controle de progresso):
1. `AGENTS.md` (blobs `e32d799..f173110`): **§5 Etapa 2** (*Sincronização mínima das regras*, itens 1 a 4) e **§10** (*Orçamento de contexto*).
2. `IA/regras/comunicacao.md` (`COM-001`, blobs `d81197f..7a01686`): nova seção **§7.3** (*Sincronização incremental e economia de contexto*).
3. `IA/despachos/README.md` (`COM-002`, blobs `d5eb73c..b5db003`): nova seção ***Contexto mínimo e revisão de regras***.

Para executar com segurança uma tarefa de despacho partindo apenas do commit-base simulado `64c8686`, leria exclusivamente os diffs/seções acima e o contrato da ordem/tarefa específica (além das seções de posse/transporte de `COM-001`/`COM-002` caso não consultadas na sessão), sem reler `IA/regras/constituicao.md` ou `IA/regras/seguranca.md` (cujos blobs permaneceram inalterados) e sem afirmar que já conhecia as mudanças antes da comparação.

### S2 — Commit novo sem regra nova
**Não** se deve reler toda a governança (`HEAD` novo não significa regra alterada). A comprovação técnica é feita comparando apenas os caminhos normativos entre o último commit verificado e o `HEAD` atual via `git diff <rules_checked_commit>..HEAD -- AGENTS.md IA/regras/ IA/despachos/README.md` (ou conferindo os blob SHAs com `git ls-tree HEAD`). Se o diff nos caminhos normativos for vazio — como verificado em `f50ad9f..a8fdd94` e `a8fdd94..e6f7c4d`, onde mudaram apenas arquivos em `IA/PROJETO.md`, `IA/tarefas/` e `IA/despachos/ordens/` — mantém-se o contexto normativo já validado.

### S3 — Revisão desconhecida
Com `rules_checked_commit: DESCONHECIDO`, para análise `L0/L1` lê-se apenas o mínimo essencial à missão: `AGENTS.md` (§5 Protocolo obrigatório de entrada), a ordem/tarefa (`TKC-REQ-XXXX` e `IA/tarefas/TKC-XXXX.md`) e as seções aplicáveis de `COM-001` e `COM-002`. Qualquer ação `L2/L3` fica **bloqueada** pela incerteza sobre as regras vigentes de autoridade e segurança (`GOV-003..005`, `SEC-001..005`), ausência de atribuição e reivindicação cooperativa de posse publicada (`claim_id`) sem conflito, e falta de decisão humana `TRUE` verificável vinculada ao escopo.

### S4 — Segurança crítica
**Não**, o resumo de mudanças nunca substitui a fonte normativa vigente nem basta para prosseguir. Qualquer alteração em `GOV` ou `SEC` sobre autorização, identidade, hierarquia, responsabilidades ou restrições invalida a confiança no checkpoint anterior (`COM-001` §7.3 e `AGENTS.md` §5 Etapa 2 item 4). É obrigatório ler diretamente na `main` o diff e a seção completa alterada (e suas dependências normativas) e revalidar autoridade, escopo, classe `L2/L3` e decisão humana antes de qualquer operação modificadora.

### S5 — Diff indisponível ou contraditório
Declarar explicitamente `rules_check_status: SEM_ACESSO` (ou classificar a divergência como `CONTRADITÓRIO`), **não inventar sincronização**, descartar o resumo de outra IA como substituto da regra, consultar diretamente as regras vigentes essenciais à atividade na `main` (se acessíveis) ou permanecer estritamente em `L0/L1`, bloqueando `L2/L3` até reconciliação ou fornecimento da fonte primária pelo operador humano.

### S6 — Custo de contexto e proposta de melhoria mínima
- **Fontes efetivamente consultadas na elaboração de S1–S6 (`HEAD` `a8fdd94`):**
  - *Documentos integrais curtos:* `IA/despachos/ordens/TKC-REQ-0002.md` (64 linhas), `IA/tarefas/TKC-0002.md` (35 linhas), `IA/tarefas/indice.md` (26 linhas) e `IA/despachos/MODELO_RETORNO.md` (44 linhas).
  - *Apenas por `git diff` (sem carregar arquivo inteiro):* `git diff 64c8686..f50ad9f` (hunks alterados de `AGENTS.md`, `IA/regras/comunicacao.md`, `IA/despachos/README.md` e `IA/PROJETO.md`) e `git diff f50ad9f..a8fdd94 --name-status`.
  - *Leitura adicional posterior (apenas para fundamentar o bloqueio do `#TRUE` prematuro e validar `TKC-AUT-0002`):* `IA/regras/comunicacao.md`, `IA/despachos/README.md` e `IA/despachos/ordens/TKC-AUT-0002.md` (50 linhas).
  - *Não lidos nesta tarefa:* `README.md`, `IA/PROJETO.md` integral, `IA/regras/constituicao.md`, `IA/regras/seguranca.md` e relatórios de auditoria M1. Nenhuma métrica de tokens, memória ou tempo foi estimada ou inventada.
- **Menor melhoria proposta (apenas sugestão L1; não aplicada nos modelos):** incluir opcionalmente nos templates `IA/despachos/MODELO_ORDEM.md` e `IA/despachos/MODELO_RETORNO.md` uma linha compacta para os campos opcionais de `COM-001` §7.3 (`rules_checked_commit`, `rules_scope`, `rules_check_status`, `rules_diff_ref`), facilitando sua adoção padronizada sem criar novos arquivos.

---

## Limitações e Proveniência
- **Proveniência (`MEDIADO` vs `VERIFICADO`):** o transporte das referências (`TKC-REQ-0002`, `#TRUE` prematuros bloqueados e o `TKC-AUT-0002 #TRUE` válido posterior) ocorreu por mediação humana no chat (`MEDIADO`). Os hashes de commits, diffs e arquivos do repositório foram consultados diretamente via Git (`VERIFICADO`).
- **Alcance experimental:** este parecer documenta um ensaio de mesa (`L0/L1`) e dois bloqueios preventivos de autorização incompleta, seguidos de publicação controlada sob `TKC-AUT-0002`. **Não** constitui validação operacional completa de `M3-02`, medição empírica de economia de tokens, auditoria independente (que cabe a agente distinto/coordenador) nem encerramento de `M1`.
