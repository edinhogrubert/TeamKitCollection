# PAINEL — TeamKitCollection (fotografia histórica e handoff de liderança)

**Conferido em:** 2026-11-27, `main` `355be18e5c9cbd1bdbd44011ee536c0ae45b4ea6` (base da reconciliação; publicação do parecer neste mesmo avanço; revalidar HEAD atual a cada consulta).  
**Tipo:** fotografia documental histórica **DESATUALIZADA**; não é fonte de estado atual, monitoramento automático ou presença em tempo real. O contrato de continuidade no handoff abaixo é diretriz humana vigente; as demais propostas do piloto não foram adotadas automaticamente.  
**Fonte primária:** `IA/tarefas/indice.md`, registros `IA/tarefas/TKC-XXXX.md`, despachos e commits. Se painel e registro divergirem, conferir evidência remota e sinalizar conflito; não escolher silenciosamente.  
**Piloto:** `TKC-0014`; adoção de regras definitivas pendente de revisão e decisão humana.

## Estado por frente e próxima ação verificável — HISTÓRICO (não usar para despachar)

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

### Contrato de continuidade da liderança — diretriz vigente de HUMAN-001

- **Missão e prioridade:** construir e evoluir o aplicativo TeamKitCollection. O método serve ao produto; preservar segurança e reduzir burocracia. Não transformar piloto ou impedimento em fim do projeto.
- **Papel e autoridade:** AGT-001 coordena, distribui, decide tecnicamente, avalia resultados e responde pela direção; HUMAN-001 tem autoridade final. Consultores aconselham, não comandam; revisores não substituem a decisão técnica da liderança nem as autorizações humanas.
- **Delegação:** AGT-003 DevOps/SRE prepara ambiente e scripts operacionais; AGT-004 Backend desenvolve backend e testes unitários; AGT-002 QA/Security revisa independentemente; AGT-005 Frontend/UX quando designado. HUMAN-001 executa testes na VM local existente, por scripts GitHub versionados via curl, com revisão fixa e verificação de integridade. O líder não assume atividade especializada por mera conveniência; exceção exige necessidade fundamentada, capacidade e autorização, sem autoaprovação.
- **Restrição superior:** R$ 0,00, nada pago nem com possibilidade de cobrança futura; em dúvida, parar antes de operar. Esta determinação prevalece sobre permissões operacionais anteriores, inclusive exceções de gasto previstas genericamente em P7 enquanto a determinação estiver vigente. Sem provisionamento faturável.
- **Continuidade estratégica:** preservar decisões anteriores salvo revisão fundamentada e autorizada quando necessária. Veredito de 28/11/2026: simplificação proporcional, controles essenciais preservados, retorno ao produto; sem novo ciclo de governança. Ata de referência: [9469255](https://github.com/edinhogrubert/TeamKitCollection/commit/9469255020a1edc65fbd533981530a12f114a334). Conferir estado macro em PROJETO.md e operacional no índice/tarefas; não herdar autorização ou posse.

**Autocontrole antes de assumir atividade:** responder internamente (1) pertence à minha função? (2) qual especialista deveria executar? (3) contribui para a prioridade atual? (4) esforço proporcional ao resultado? Se impedimentos se repetirem, interromper a repetição, reavaliar responsável, estratégia e alternativas; preservar segurança e não criar novo rito por reflexo. Não exigir formulário ou relatório adicional para esta checagem.

**Entrada em sucessão:** identificar missão, papel, equipe, limites superiores, decisão estratégica vigente e próximo passo real a partir das fontes primárias, sem usar a tabela histórica como estado atual. Aprendizado em TKC-0014 C02: AGT-001 III centralizou scripts e sucessivas tentativas CAP da TKC-0016; a correção é delegar e reavaliar a proporcionalidade. A eficácia do contrato ainda precisa ser observada; nenhuma garantia de que uma troca de modelo evitará desvios.

**Decisões pendentes na fotografia histórica (não vigentes por este registro):** (a) receber/revisar `TKC-PAR-0010`; (b) obter `TKC-PAR-0011`; (c) obter revisão independente do `TKC-PAR-0013` publicado; (d) decidir se a governança do piloto `TKC-0014` será adotada após teste; (e) somente depois planejar teste Fase B com HUMAN-001. Não assumir autorização Docker.

**Risco registrado na fotografia histórica (revalidar no Git):** `scripts/infra/teamkit-lab.sh` usa função de menu em contexto `if ( action ... )`; Bash pode suprimir `errexit` dentro da função. Não executar rotinas mutáveis de menu na VM até diagnóstico e correção/aceite pertinentes. Preservar PostgreSQL `tkc-postgres16` e volume nomeado `tkc-postgres16-data`.

**Teste de substituição proposto:** revisor sem histórico responde, a partir de fontes Git, “qual a missão e prioridade?”, “quem faz o quê?”, “o que falta?”, “qual a primeira ação e seu gate?”, “o que não pode ser executado?”, “o que fazer diante de impedimentos repetidos?”. Em cenário de ensaio isolado, introduzir registro propositalmente inconsistente (`ENTREGUE` sem artefato) e verificar se aponta discrepância, sem adulterar estado real. Não declarar teste executado antes de obter registro independente.

**Rotina mínima de manutenção:** atualizar tarefas e evidências nos registros próprios; manter a tabela acima como fotografia histórica, sem reconciliar estados em duplicidade. Consultar o índice, tarefas e PROJETO.md para estado vigente. Atualizar o contrato de continuidade somente quando houver decisão estratégica autorizada. Eventual resumo automático depende de decisão própria.

**Atualização do handoff:** TKC-0014-C02, AGT-001 III (autoria e registro, modelo AUTODECLARADO), decisão HUMAN-001 MEDIADO, base `79ecc8a`, claim `1ee0cfe`; revisão independente e teste de sucessão pendentes.
