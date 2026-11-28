# MODELO — Parecer, log e retorno (não é resultado real)

**Não preencher retrospectivamente como evidência verificada.** Na fase de viabilidade, publicar `IA/despachos/retornos/TKC-PAR-XXXX.md` com capacidade declarada, riscos, plano, dependências, alternativas e verificação `L0/L1`, **sem alterações operacionais**. Na fase autorizada, criar log de execução em `IA/despachos/logs/TKC-EXE-XXXX.md`, anexando eventos; publicar retorno em `IA/despachos/retornos/TKC-RET-XXXX.md`. Ambos devem mencionar `claim_id` específico (nova tentativa exige nova identidade, sem sobrescrever tentativa anterior).

## Identificação
- task_id: PENDENTE
- order_id / ref curta: PENDENTE
- tipo: PARECER L0/L1 ou EXECUCAO (PENDENTE)
- claim_id: PENDENTE
- agent_id / papel / ferramenta / session_ref: PENDENTE
- origem da ordem / evidência da autorização: PENDENTE
- documentation_write_authorization / documentation_scope_paths: PENDENTE — autorização explícita existente na atribuição, ou complemento humano; separar de escopo de produto
- git_read_write_capability / publish_status: A CONFIRMAR / NÃO PUBLICADO — sem atribuição e claim, não publicar
- repositório / branch / base_commit / head_final: PENDENTE
- estado de saída: NÃO EXECUTADO
- ai_model (AUTODECLARADO quando informado) / intellectual_author / recorded_by / published_by / git_commit_author: PENDENTE — não inferir identidade técnica ou modelo
- revisão da ordem / SHA completo resolvido / decisão e proveniência: PENDENTE
- evidência de capacidade por função / claim remoto anterior à alteração: PENDENTE

## Parecer prévio de viabilidade (somente L0/L1)
- Contexto e versão consultados: PENDENTE
- Capacidade de executar e lacunas de conhecimento: NÃO AVALIADO
- Riscos, impactos, janela, backup e rollback necessários: NÃO AVALIADO
- Condições para autorizar ou contraindicações: NÃO AVALIADO
- Recomendação independente de autorização: PENDENTE

## Eventos de execução (log)
| Evento | Momento e origem | Commit/ref | Descrição | Evidência/limite |
|---|---|---|---|---|
| RECEBIDO | — | — | Confirmação de leitura da ordem | Não equivale a autorização |
| INICIADO | — | — | Posse publicada antes da mudança | Sem confirmação, não alegar início |
| CHECKPOINT | — | — | Progresso, decisões e impedimentos | — |
| ENTREGUE/BLOQUEADO | — | — | Resultado e efeitos parciais | — |

## Relatório de saída
- Resumo do que foi executado: NÃO EXECUTADO
- Arquivos alterados e commits: NENHUM
- Verificações/testes e resultados: NÃO EXECUTADOS
- Divergências frente à ordem: NÃO AVALIADO
- Riscos, pendências e efeitos parciais: NÃO AVALIADO
- Logs/artefatos externos sanitizados e respectivos hashes: NENHUM
- Próximo responsável e ação recomendada: PENDENTE
- Comparação base/HEAD, caminhos autorizados, renomes/exclusões e preservação de eventos: NÃO VERIFICADO
- Esforço de construção / esforço de método / intervenções humanas / retrabalho / custo efetivo: NÃO MEDIDO (informar método de medição e fonte se disponível)
- Handoff: autorizações vigentes e proveniência, posse, trabalho local/remoto, impedimentos, próximo passo e referência de corte: PENDENTE
- Revisão independente: NÃO REALIZADA
- Decisão de aceite humano: PENDENTE

**Classificação:** declaração do executor é `RELATADO` até conferência direta. Não contém permissão ou aprovação automática.

**Em qualquer fase:** publicar dúvidas, checkpoints, impedimentos e pareceres no Git **somente nos caminhos previamente autorizados**; basta a autorização documental já incorporada à atribuição, mais claim COM-001 confirmado. Informar ao humano somente referência e SHA. Se publicação operacional for impossível, retornar referência, estado BLOQUEADA e motivo curto; não exigir colagem integral. Consulta mediada facultativa não substitui entrega operacional. Nenhuma autorização documental abrange código, normas ou infraestrutura.

**Em qualquer fase:** registrar o status e proveniência das afirmações (`VERIFICADO`, `RELATADO`, `MEDIADO` ou `DESCONHECIDO`), o commit consultado e os links completos da ordem/parecer quando disponíveis. O humano transporta apenas a referência; nenhum retorno é entregue automaticamente à sessão inativa.

**Revisão do modelo:** TKC-0015-C03, AGT-001 III (ChatGPT / GPT-6.2, AUTODECLARADO; autoria/registro), autorização HUMAN-001 MEDIADO, base d5cfbad, claim 5f21ee1; revisão distinta pendente.
