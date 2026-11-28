# MODELO — Ordem multiagente (não executável)

**NÃO É UMA TAREFA AUTORIZADA.** Copiar para `IA/despachos/ordens/TKC-REQ-XXXX.md` (pedido de viabilidade L0/L1) ou `TKC-AUT-XXXX.md` (proposta pendente), conforme COM-002. O humano transporta somente a referência.

| Campo | Valor a preencher |
|---|---|
| task_id | PENDENTE — ex.: TKC-0054 |
| order_id / short_ref / request_type | PENDENTE — TKC-REQ-XXXX (viabilidade) ou TKC-AUT-XXXX (proposta de decisão) |
| recipient / agent_role | PENDENTE |
| sender / authorization_provenance | PENDENTE |
| authorization_state | PENDENTE — não assumir TRUE; proposta de autorização não equivale a consentimento |
| decision_ref / human_scope / approval_channel | PENDENTE — #TRUE não comprova identidade |
| status | RASCUNHO — não despachado; pedido publicado não equivale a recebido |
| repository / branch / base_commit | PENDENTE |
| task_record | `IA/tarefas/<TASK-ID>.md` |
| product_scope_paths / forbidden_actions | PENDENTE — análise L0/L1 não autoriza editar o produto |
| documentation_write_authorization / provenance | PENDENTE — decisão humana específica ou conjunta com a atribuição; nunca presumir |
| documentation_scope_paths | PENDENTE — informar caminhos exatos de tarefa, linha do índice, log/checkpoints, parecer/retorno e impedimentos aplicáveis; nunca incluir outras tarefas por padrão |
| git_read_write_capability | A CONFIRMAR pelo destinatário no recebimento; permissão técnica não substitui autorização |
| dependencies / claim_conflicts | PENDENTE |
| feasibility_report_ref / acceptance_criteria | PENDENTE — autorização de execução exige parecer anterior, quando aplicável |
| required_checks | PENDENTE |
| log_path (somente execução após autorização) | `IA/despachos/logs/TKC-EXE-XXXX.md` |
| return_path | Viabilidade: `IA/despachos/retornos/TKC-PAR-XXXX.md`; execução: `IA/despachos/retornos/TKC-RET-XXXX.md` |

## Instrução ao destinatário
O recebimento de uma referência isolada nunca autoriza modificações. Para REQ, atuar somente em L0/L1 **sobre o produto**; se `documentation_write_authorization` estiver válida e cobrir o caminho de retorno, publicar o parecer e os checkpoints por Git sob posse COM-001, sem nova aprovação documental por artefato. Caso não cubra, solicitar complemento, sem presumir autorização. Para AUT, apenas apresentar os termos e solicitar decisão humana validável. `TKC-AUT-XXXX #TRUE` é manifestação humana a verificar, não senha nem permissão técnica. Antes de agir: ler `AGENTS.md`, `IA/PROJETO.md`, COM-001 e COM-002; validar a `main`, a posse e o escopo. Confirmar recebimento separadamente. Só iniciar edição após autorização e reivindicação publicadas. Ao terminar, escrever log e retorno **nos caminhos documentais autorizados**, sanitizar dados, registrar commits e atualizar apenas os registros autorizados da própria tarefa. HUMAN-001 transporta somente referência e SHA quando a publicação ocorrer. Não declarar aprovação por conta própria.

## Histórico de despacho
- **RASCUNHO:** este modelo não foi publicado como ordem real.

**Atenção:** a versão de ordem, o número da tarefa e o escopo devem ser inequívocos e correlacionados. Ao alterar escopo/risco depois do parecer, emitir nova revisão de autorização. Um modelo no repositório não é uma ordem real.
