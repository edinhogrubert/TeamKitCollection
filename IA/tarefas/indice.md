# Índice de tarefas — TeamKitCollection

**Estado:** REGISTRO INICIAL — mecanismo de bloqueio/automação ainda não implementado  
**Regra:** consultar `IA/regras/comunicacao.md` (COM-001) antes de assumir trabalho; consultar `IA/PROJETO.md` para o estado macro.

| Task ID | Objetivo | Estado confirmado | Responsável ativo | Registro | Observação |
|---|---|---|---|---|---|
| M1-REVISAO | Revisão documental M1 e auditoria D2/D5–D8 | EM_ANDAMENTO (macro) | NÃO ATRIBUÍDO NESTE ÍNDICE | `IA/PROJETO.md` | Linha informativa: **não constitui reivindicação de posse**; Bloco 3 já publicado, auditoria dirigida pendente |
| M3-01 | Especificar COM-001 e iniciar índice | DOCUMENTADO (verificar no Git) | NENHUM | `IA/regras/comunicacao.md` | A criação deste índice não demonstra bloqueio atômico |
| M3-02 | Implementar registros de tarefa e handoff testados | PENDENTE | NENHUM | A criar com autorização | Não iniciar sem atribuição e TRUE aplicável |
| M5-01 | Implementar coordenação concorrente segura | PENDENTE | NENHUM | A criar com autorização | Sem lock/lease/fencing operacional |

## Como atualizar

1. Um novo trabalho recebe ID estável e registro próprio `IA/tarefas/<ID>.md` antes de começar sua execução.
2. Estado, responsável e referência Git do índice devem corresponder ao registro específico. **Discordância bloqueia execução modificadora até reconciliação.**
3. Sem confirmação de registro publicado, exibir `DESCONHECIDO` ou `NÃO ATRIBUÍDO`; nunca inferir que ninguém está trabalhando.
4. Não alterar este índice apenas para sugerir que uma tarefa está livre; consultar fonte remota e todas as tarefas que compartilhem recursos.
5. Histórico de alterações fica no Git e no log da tarefa. Correção de um evento é novo registro, sem apagar a ocorrência original.

**Aviso:** não existe serviço de monitoramento ou exclusão automática implementado. As linhas acima são inventário inicial, não locks.
