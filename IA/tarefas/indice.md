# Índice de tarefas — TeamKitCollection

**Estado:** REGISTRO INICIAL — mecanismo de bloqueio/automação ainda não implementado  
**Regra:** consultar `IA/regras/comunicacao.md` (COM-001) e `IA/despachos/README.md` (COM-002) antes de assumir trabalho; consultar `IA/PROJETO.md` para o estado macro. Ordens publicadas e retornos são rastreados por `task_id`, mas não entregues automaticamente a IAs inativas.

| Task ID | Objetivo | Estado confirmado | Responsável ativo | Registro | Observação |
|---|---|---|---|---|---|
| TKC-0002 | Teste de sincronização incremental de regras e custo de contexto | CONCLUIDA (ensaio documental, revisão distinta por AGT-001) | NENHUM — tentativa TKC-0002-C01 encerrada | `IA/tarefas/TKC-0002.md` | Parecer `IA/despachos/retornos/TKC-PAR-0002.md` e log `IA/despachos/logs/TKC-EXE-0002.md` verificados; entrega `7954695`; sem validação operacional ou medição de tokens |
| TKC-0001 | Piloto COM-002: parecer independente M1 D2/D5–D8 e consistência COM | CONCLUIDA — encerramento administrativo aceito por HUMAN-001 com ressalvas (`MEDIADO`), sem aceite M1 | NENHUM — C01, C02 e C03 entregues, sem posse ativa | `IA/tarefas/TKC-0001.md` | Parecer `IA/despachos/retornos/TKC-PAR-0001.md`, log `IA/despachos/logs/TKC-EXE-0001.md`; integração `a183a47`, reconciliação `e054205`, reivindicação C03 `1718332`; parecer da revisão `APROVAR COM RESSALVAS` recebido via HUMAN-001 (`MEDIADO`); D8/D9 e M1 pendentes |
| TKC-0003 | Ajuste D6 do cabeçalho de M1_TEST_RELATORIO | EM_REVISAO — ajuste pontual entregue, aguardando revisão distinta | NENHUM — C01 ENTREGUE, sem posse ativa | `IA/tarefas/TKC-0003.md` | Apenas campo `Estado atual consolidado` alterado; posse C01 `4e51e67`; D6/D8/D9/M1 não aprovados |
| TKC-0004 | Preparação operacional do M3-02: pacotes, handoff e revisão entre IAs | EM_REVISAO — C02 incorporou seis achados de Claude; revisão distinta e piloto pendentes | NENHUM — C01/C02 ENTREGUES, sem posse ativa | `IA/tarefas/TKC-0004.md` | C02 reivindicada `4ba4c08`; autorização e parecer MEDIADO; matriz de acesso, métricas, HND-T01, riscos e piloto propostos; M3-02 PENDENTE |
| TKC-0005 | Pacote executável e proposta de autorização do piloto | EM_REVISAO — C05 entregou proposta TKC-AUT-0005 em PENDENTE; nenhuma execução | NENHUM — C01–C05 ENTREGUES, sem posse ativa | `IA/tarefas/TKC-0005.md` | Parecer C04 `a8a687c`; proposta `IA/despachos/ordens/TKC-AUT-0005.md` PENDENTE: fase A código sem Docker; fase B laboratório requer aprovação própria; M3-02 PENDENTE |
| TKC-0006 | Script reprodutível de instalação Docker/Compose Ubuntu | EM_REVISAO — C01 entregou script Git; instalação na VM não verificada | NENHUM — C01 ENTREGUE, sem posse ativa | `IA/tarefas/TKC-0006.md` | Instalador `scripts/infra/install-docker-ubuntu.sh`, diagnóstico `--check` e instalação explícita `--install`; nenhum container criado pelo agente |
| M1-REVISAO | Revisão documental M1 e auditoria D2/D5–D8 | EM_ANDAMENTO (macro) | NÃO ATRIBUÍDO NESTE ÍNDICE | `IA/PROJETO.md` | Linha informativa: **não constitui reivindicação de posse**; Bloco 3 já publicado, auditoria dirigida pendente |
| M3-01 | Especificar COM-001 e iniciar índice | CONCLUÍDO (documental) | NENHUM | `IA/regras/comunicacao.md` | Contrato publicado e verificado; bloqueio atômico e ensaios operacionais pendentes |
| M3-02 | Implementar registros de tarefa e handoff testados | PENDENTE | NENHUM | A criar com autorização | Não iniciar sem atribuição e TRUE aplicável |
| M5-01 | Implementar coordenação concorrente segura | PENDENTE | NENHUM | A criar com autorização | Sem lock/lease/fencing operacional |

**Protocolo de mensagens:** referências `TKC-REQ-XXXX` (pedido), `TKC-PAR-XXXX` (parecer), `TKC-AUT-XXXX` (proposta), `TKC-EXE-XXXX` (log) e `TKC-RET-XXXX` (resultado) são resolvidas pelos caminhos de [COM-002](../despachos/README.md). Sem ordem real publicada, nenhum desses exemplos é tarefa ou autorização vigente. `M1-REVISAO` não possui reivindicação individual confirmada neste índice, embora a etapa macro esteja em andamento.

## Como atualizar

1. Um novo trabalho recebe ID estável e registro próprio `IA/tarefas/<ID>.md` antes de começar sua execução.
2. Estado, responsável e referência Git do índice devem corresponder ao registro específico. **Discordância bloqueia execução modificadora até reconciliação.**
3. Sem confirmação de registro publicado, exibir `DESCONHECIDO` ou `NÃO ATRIBUÍDO`; nunca inferir que ninguém está trabalhando.
4. Não alterar este índice apenas para sugerir que uma tarefa está livre; consultar fonte remota e todas as tarefas que compartilhem recursos.
5. Histórico de alterações fica no Git e no log da tarefa. Correção de um evento é novo registro, sem apagar a ocorrência original.

**Aviso:** não existe serviço de monitoramento ou exclusão automática implementado. As linhas acima são inventário inicial, não locks.
