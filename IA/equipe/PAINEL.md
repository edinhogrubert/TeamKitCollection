# PAINEL — TeamKitCollection (piloto L0/L1, não normativo)

**Conferido em:** 2026-11-27, `main` `355be18e5c9cbd1bdbd44011ee536c0ae45b4ea6` (base da reconciliação; publicação do parecer neste mesmo avanço; revalidar HEAD atual a cada consulta).  
**Tipo:** fotografia documental, **não** monitoramento automático ou presença em tempo real.  
**Fonte primária:** `IA/tarefas/indice.md`, registros `IA/tarefas/TKC-XXXX.md`, despachos e commits. Se painel e registro divergirem, conferir evidência remota e sinalizar conflito; não escolher silenciosamente.  
**Piloto:** `TKC-0014`; adoção de regras definitivas pendente de revisão e decisão humana.

## Estado por frente e próxima ação verificável

| Frente | Tarefa | Estado do trabalho / estado da informação | Falta para a etapa atual | Ação seguinte — responsável e critério de conclusão |
|---|---|---|---|---|
| AGT-001 — liderança | `TKC-0013` | Parecer arquitetural L0/L1 publicado `VERIFICADO`; C02 encerrada, revisão independente pendente | Integrar `TKC-PAR-0010` e `TKC-PAR-0011` quando disponíveis; obter revisão distinta de `TKC-PAR-0013` | **HUMAN-001:** designar revisor distinto para `TKC-PAR-0013`; **AGT-001:** examinar pareceres 0010/0011 e propor decisões separadas. Concluído quando houver revisão de arquitetura e bloqueadores fundamentados, sem deploy. |
| AGT-002 — QA/Security | `TKC-0012` | Parecer v2 e reconciliação `VERIFICADO`; `APROVADO_COM_RESSALVAS` documental | Evidência operacional da matriz TST-01..10 na VM; depende de autorização e resolução de riscos | **AGT-002:** quando receber evidências primárias da Fase B, inspecionar cada teste e classificar resultado; concluído quando parecer operacional distinguir aprovado/falhou/não executado; não executar VM por conta própria. |
| AGT-003 — DevOps/SRE | `TKC-0010` (ligada a `0009`) | Pedido de análise publicado `VERIFICADO`; parecer dito pronto em conversa `MEDIADO`, **não confirmado como arquivo Git** | Obter relatório integral com diagnóstico reproduzível do risco de `set -e` / `if`; avaliar necessidade de patch L2 | **AGT-003:** devolver `TKC-PAR-0010` completo com teste sintético, impacto e correção sugerida via COM-002.2 ou publicação autorizada; **AGT-001** revisa antes de propor L2. Sem novo patch/VM neste passo. |
| AGT-004 — Backend/API | `TKC-0011` | Despacho publicado `VERIFICADO`; recebimento e parecer **não confirmados** | Avaliar FastAPI `/health`, conexão PG, timeouts, segredos, testes e dependências | **HUMAN-001:** transportar `TKC-REQ-0011` à sessão AGT-004 se ainda não recebido; **AGT-004:** entregar `TKC-PAR-0011` L0/L1. Concluído quando AGT-001 localizar e revisar o parecer integral. |
| AGT-005 — Frontend/UX | Sem tarefa ativa atribuída | Reserva planejada `RELATADO` | Contratos de negócio e escopo funcional | **AGT-001:** não despachar implementação antes de clarificar API de negócio e autorizar escopo. |
| AGT-ACI — Auditor Crítico Independente | Consultoria pontual, sem task operacional | Papel acordado em conversa `MEDIADO`; especificação piloto em `TKC-0014` | Nenhuma entrega obrigatória; não é membro da cadeia de execução | **AGT-ACI:** apenas sugestão quando consultado; **AGT-001:** aceitar, adaptar ou ignorar por mérito técnico; escalar HUMAN-001 somente quando necessário. |

**Status não equivale a presença:** `DESIGNADO`, `RECEBIDO`, `EM_EXECUCAO`, `ENTREGUE`, `BLOQUEADO` descrevem fluxo da tarefa; `VERIFICADO`, `MEDIADO`, `RELATADO`, `NÃO_EXECUTADO` descrevem qualidade da evidência. `EM_EXECUCAO` exige registro datado de início/posse, mas não prova atividade neste minuto. Sem atualização suficiente: sinalizar `SEM_SINAL` como *alerta informacional*, nunca expirar posse automaticamente; limite N dias a definir após piloto.

## PA-01 — Contrato mínimo de próximo passo

Todo próximo passo publicado ou comunicado deve indicar: **(1) tarefa**, **(2) ação e entrega**, **(3) responsável**, **(4) como/fonte**, **(5) pré-condição ou autorização**, **(6) evidência objetiva de conclusão**, **(7) destinatário da entrega**. Se uma informação é desconhecida, declarar `DESCONHECIDO` e explicar como descobri-la. Evitar “acompanhar” ou “seguir” isoladamente.

**Regra lógica de referência (não um motor de políticas):** `EXECUTAR = AUTORIZACAO_VALIDA AND POSSE_CONFIRMADA AND ESCOPO_PERMITIDO AND NOT BLOQUEADOR`. Uma condição desconhecida bloqueia L2/L3; consultar COM-001/COM-002 para detalhes de segurança e autoridade. `CONCLUIR = ENTREGA AND EVIDENCIA_VALIDADA AND ACEITE_EXIGIDO`. Nenhum destes atalhos substitui as regras vigentes.

## Handoff do AGT-001 — sucessão sem conversa anterior

**Entrada do novo líder:** HUMAN-001 nomeia substituto; ele lê `AGENTS.md`, `IA/PROJETO.md`, este painel, `IA/tarefas/indice.md` e somente as tarefas pertinentes; revalida HEAD/diffs e autorizações. **Este painel não transfere o cargo, a posse ou permissões por si só.**

**Decisões pendentes:** (a) receber/revisar `TKC-PAR-0010`; (b) obter `TKC-PAR-0011`; (c) obter revisão independente do `TKC-PAR-0013` publicado; (d) decidir se a governança do piloto `TKC-0014` será adotada após teste; (e) somente depois planejar teste Fase B com HUMAN-001. Não assumir autorização Docker.

**Risco prioritário:** `scripts/infra/teamkit-lab.sh` usa função de menu em contexto `if ( action ... )`; Bash pode suprimir `errexit` dentro da função. Não executar rotinas mutáveis de menu na VM até diagnóstico e correção/aceite pertinentes. Preservar PostgreSQL `tkc-postgres16` e volume nomeado `tkc-postgres16-data`.

**Teste de substituição proposto:** revisor sem histórico responde, a partir de fontes Git, “quem faz o quê?”, “o que falta?”, “qual a primeira ação e seu gate?”, “o que não pode ser executado?”. Em cenário de ensaio isolado, introduzir registro propositalmente inconsistente (`ENTREGUE` sem artefato) e verificar se aponta discrepância, sem adulterar estado real. Não declarar teste executado antes de obter registro independente.

**Rotina mínima de manutenção:** agente executor atualiza tarefa e evidências no checkpoint; AGT-001 reconcilia **somente linhas alteradas do painel** na entrega/revisão; não repetir o histórico. Se atualização não ocorrer, declarar painel desatualizado e consultar fontes antes de responder. Objetivo futuro: geração automática de resumo a partir das tarefas, sem criar segunda verdade.
