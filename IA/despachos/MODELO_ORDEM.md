# MODELO — Ordem multiagente (não executável)

**NÃO É UMA TAREFA AUTORIZADA.** Copiar para `IA/despachos/ordens/TKC-REQ-XXXX.md` (pedido de viabilidade L0/L1) ou `TKC-AUT-XXXX.md` (proposta pendente), conforme COM-002. O humano transporta somente a referência.

| Campo | Valor a preencher |
|---|---|
| task_id | PENDENTE |
| order_id / short_ref / request_type | PENDENTE — TKC-REQ-XXXX (viabilidade) ou TKC-AUT-XXXX (proposta de decisão) |
| recipient / agent_role | PENDENTE |
| sender / authorization_provenance | PENDENTE |
| authorization_state | PENDENTE — não assumir TRUE; proposta de autorização não equivale a consentimento |
| decision_ref / human_scope / approval_channel | PENDENTE — #TRUE não comprova identidade |
| status | RASCUNHO — não despachado |
| repository / branch / base_commit | PENDENTE |
| task_record | `IA/tarefas/<TASK-ID>.md` |
| scope_paths / forbidden_actions | PENDENTE |
| dependencies / claim_conflicts | PENDENTE |
| feasibility_report_ref / acceptance_criteria | PENDENTE — autorização de execução exige parecer anterior, quando aplicável |
| required_checks | PENDENTE |
| log_path | `IA/despachos/logs/<TASK-ID>-<CLAIM-ID>.md` |
| return_path | `IA/despachos/retornos/<TASK-ID>-<CLAIM-ID>.md` |

## Instrução ao destinatário
O recebimento de uma referência isolada nunca autoriza modificações. Para REQ, atuar somente em L0/L1 e publicar parecer; para AUT, apenas apresentar os termos e solicitar decisão humana validável. `TKC-AUT-XXXX #TRUE` é manifestação humana a verificar, não senha nem permissão técnica. Antes de agir: ler `AGENTS.md`, `IA/PROJETO.md`, COM-001 e COM-002; validar a `main`, a posse e o escopo. Confirmar recebimento separadamente. Só iniciar edição após autorização e reivindicação publicadas. Ao terminar, escrever log e retorno, sanitizar dados, registrar commits e atualizar a tarefa. Não declarar aprovação por conta própria.

## Histórico de despacho
- **RASCUNHO:** este modelo não foi publicado como ordem real.
