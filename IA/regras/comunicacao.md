# COM-001 — Comunicação, ciclo de vida e posse de tarefas

**Projeto de validação:** TeamKitCollection  
**Identificador:** COM-001  
**Versão:** 0.2.0  
**Estado:** ESPECIFICADO — registro documental disponível; bloqueio atômico, heartbeats automáticos e recuperação automática NÃO IMPLEMENTADOS  
**Marco:** M3 (comunicação, tarefas e handoff); dependências e controle técnico de concorrência em M5  
**Autoridade:** `AGENTS.md`, `IA/regras/constituicao.md` (GOV-001..005) e `IA/regras/seguranca.md` (SEC-001..010)  
**Estado macro vigente:** `IA/PROJETO.md`; **índice de tarefas:** `IA/tarefas/indice.md`

## 1. Objetivo e limites

Tornar observável e transferível entre humanos e agentes de IA: **quem foi designado, qual decisão autoriza o quê, quando uma execução foi iniciada, seu progresso, os artefatos entregues, os impedimentos e quem pode retomá-la**. Os agentes não dependem de memória de chat para reconhecer trabalho ativo.

**Autorização `TRUE` não é posse, início nem conclusão.** Relato em documento não autentica a identidade do humano. Permissão de escrita da ferramenta não substitui autorização. A atribuição, a decisão, o registro de início, a execução e a validação são eventos distintos.

Este documento especifica um **protocolo cooperativo**. Não afirmar que há sincronização em tempo real, observação contínua, exclusão mútua técnica ou impedimento de escritas conflitantes; nenhuma dessas capacidades foi implementada.

## 2. Fonte e localização

- `IA/PROJETO.md` continua a fonte de estado **macro** e do próximo passo do projeto; não duplicar ali cada atualização operacional.
- `IA/tarefas/indice.md` lista IDs, responsável, estado, última revisão Git e link para o registro da tarefa.
- Uma tarefa concreta usa `IA/tarefas/<ID>.md`, com o esquema mínimo abaixo. IDs estáveis não devem ser reutilizados para trabalhos distintos.
- O Git registra mudanças publicadas; **arquivo local não publicado não é comunicação compartilhada**. Informação externa ou de outra sessão é `MEDIADO` até verificação.
- Arquivos `docs/` descrevem o produto e não podem mudar autoridade ou atribuição do método.

## 3. Estados permitidos

| Estado | Significado e condição |
|---|---|
| `PENDENTE` | Proposta identificada, sem execução autorizada |
| `ATRIBUIDA` | Executor e escopo definidos; decisão de modificação ainda não necessariamente autorizada |
| `AUTORIZADA` | `TRUE` humano vinculado ao escopo; **não implica execução iniciada** |
| `EM_EXECUCAO` | Responsável confirmou posse e publicou o registro de início antes da primeira alteração substancial |
| `PAUSADA` | Executor suspendeu voluntariamente, com progresso e pendências registrados |
| `BLOQUEADA` | Conflito, ausência de evidência/autorização, estado incerto ou impedimento de segurança |
| `EM_REVISAO` | Artefatos publicados, aguardando avaliação separada |
| `CONCLUIDA` | Entrega verificada conforme critérios e decisão aplicável; não confundir autorrelato com aprovação independente |
| `FALHOU` | Falha documentada e encerramento da tentativa, com indicação do que ficou aplicado |
| `CANCELADA` | Encerramento por decisão autorizada, sem apagar histórico |

Transições são registradas com ator, data **verificada ou declarada**, justificativa, revisão-base, revisão resultante e evidência. `BLOQUEADA` não deve ser convertida em `PENDENTE` silenciosamente. Autorizações expiradas, revogadas, conflituosas ou sem escopo exato não permitem iniciar.

## 4. Registro mínimo da tarefa

Cada `IA/tarefas/<ID>.md` deve conter, em formato legível e estável:

| Campo | Obrigação |
|---|---|
| `task_id`, `title`, `parent_milestone` | Identidade e objetivo inequívocos |
| `status`, `owner_id`, `executor`, `session_ref` | Estado, responsável funcional e execução/sessão quando identificáveis |
| `authorized_by`, `authorization_state`, `authorization_scope`, `authorization_provenance` | `TRUE/FALSE/PENDENTE`, escopo e fonte `VERIFICADO/MEDIADO/DESCONHECIDO` |
| `scope_paths`, `forbidden_actions`, `dependencies` | Limites e tarefas bloqueadoras |
| `base_commit`, `state_commit`, `started_at`, `updated_at` | Revisões Git e tempos com origem; ausências declaradas |
| `claim_id`, `claim_status`, `last_checkpoint` | Identificador de tentativa, situação de posse, progresso e evidências |
| `deliverables`, `validation`, `next_action` | Entregas, teste, auditoria e próximo passo |
| `history` | Registro append-only **lógico** de eventos: nunca apagar um evento para esconder uma falha; correções são novos eventos |

As datas não comprovadas recebem `RELATADO`. Não registrar segredos, tokens, e-mails pessoais desnecessários ou conteúdo sensível.

## 5. Procedimento obrigatório antes de executar

1. Consultar `AGENTS.md`, `IA/PROJETO.md`, este protocolo, índice e tarefa concreta; atualizar a visão da `main` imediatamente antes de decidir. Relatar se não há acesso direto.
2. Confirmar função, escopo, autorização humana aplicável, permissões técnicas, dependências e `base_commit`.
3. Consultar o estado **da tarefa e de tarefas com sobreposição de arquivos/recursos**. Se houver `EM_EXECUCAO` de outro responsável, `BLOQUEADA` ou estado indeterminado, **não iniciar alteração**. Registrar conflito e solicitar coordenação; não reinterpretar silêncio como liberação.
4. Se a tarefa não existir, **não inventar que foi atribuída**: registrar uma proposta em `PENDENTE` somente com escopo de escrita autorizado ou solicitar ao coordenador sua criação.
5. Quando autorizado, registrar e **publicar primeiro** a transição `AUTORIZADA → EM_EXECUCAO` com `claim_id`, executor, sessão, escopo, base e próximo checkpoint. **Confirmar no remoto que a publicação prevaleceu** antes de alterar os artefatos do trabalho.
6. Se outro commit ou reivindicação surgir entre leitura e publicação, interromper, atualizar o estado e reconciliar. **Não sobrescrever registro concorrente nem fazer push forçado**.
7. Durante a execução, publicar checkpoints **a cada etapa significativa, antes de pausas/handoffs e antes/depois de ações de risco**; quando houver ferramenta e missão ativa, registrar também `updated_at` e `last_checkpoint`. Sem agendador, não prometer heartbeat periódico.
8. Publicar entrega, hashes, verificação e estado `EM_REVISAO`; somente marcar `CONCLUIDA` quando critérios e aprovações aplicáveis estiverem comprovados.

**Sem confirmação de reivindicação publicada, o agente só pode analisar/propor — não pode assumir posse exclusiva.**

## 6. Concorrência e recuperação de posse

A reivindicação em Git é uma **convenção cooperativa**, não um lock de recurso. Uma checagem `git pull` + edição posterior, ou uma simples linha `owner_id`, não impede duas IAs de iniciar simultaneamente. Commits sequenciais em `main` demonstram publicação, não que uma execução ficou exclusiva em todo o intervalo.

Um mecanismo futuro M5 deverá implementar, testar e documentar **compare-and-swap/controle de versão atômico na reivindicação, token de fencing, leases com relógio confiável, verificação de recursos sobrepostos e tratamento de expiração e crash**. O detentor de posse expirado deve ser impedido tecnicamente de continuar gravando após substituição; sem isso a expiração não autoriza tomada automática.

Até existir tal controle:
- **Não assumir exclusividade forte**; preferir atribuição sequencial e escopo não sobreposto.
- Se um agente sumir ou deixar de atualizar, marcar a situação `BLOQUEADA` ou `DESCONHECIDA` após conferência humana/coordenação, **nunca liberar automaticamente pelo tempo decorrido**.
- Antes de reassumir, conferir commits, mudanças locais acessíveis, jobs em execução, efeitos externos, credenciais e possível executor ainda ativo; obter nova autorização de substituição quando pertinente.
- Toda retomada gera `claim_id` novo e registra o anterior; `TRUE` de um executor não migra automaticamente para outro.
- Qualquer confirmação de conflito, push rejeitado, alterações externas ou progresso divergente exige pausa e reconciliação.

## 7. Comunicação mínima e handoff

Uma atualização ou entrega deve responder: **quem**, **o quê**, **estado**, **base**, **o que foi publicado**, **o que não foi verificado**, **bloqueios**, **próxima ação**, **quem autoriza**. O agente receptor lê diretamente a fonte atual, não apenas a mensagem do emissor.

Mudança de responsável: registrar motivo, estado e artefatos na tarefa anterior, suspender o antigo executor, revogar acessos quando necessário por mecanismo autorizado, atribuir novo executor com decisão específica e produzir nova tentativa. Nunca declarar a revogação técnica concluída apenas porque um documento diz que ocorreu.

## 7.1 Despacho de ordens e registros de saída (COM-002)

**Autorização documental incorporada à atribuição (aplicação prospectiva):** HUMAN-001 pode aprovar a tarefa e, **na mesma decisão**, autorizar explicitamente os caminhos de comunicação de sua própria execução: registro `IA/tarefas/<ID>.md`, linha correspondente de `IA/tarefas/indice.md`, parecer `IA/despachos/retornos/TKC-PAR-XXXX.md`, log/checkpoints `IA/despachos/logs/TKC-EXE-XXXX.md` e retorno `IA/despachos/retornos/TKC-RET-XXXX.md`, **conforme os caminhos realmente previstos e especificados para aquela ordem**. A atribuição deve registrar autorização humana, proveniência, executor, escopo exato e proibições. Após decisão válida, reivindicação publicada e confirmação no remoto, o mesmo executor pode registrar recebimento, impedimento, checkpoint e entrega nesses caminhos sem pedir uma segunda autorização documental por arquivo. Isso é **L2 de documentação**, mesmo quando o conteúdo técnico analisado é L0/L1.

**Limites:** não há permissão implícita para documentos omitidos, AUT de aprovação, regras, arquivos de produto, código, testes, infraestrutura, recursos de outras tarefas nem execução de comandos. Publicar análise não autoriza aplicar recomendações. Sem autorização prévia do caminho, parar e solicitar complemento; a existência desta regra **não amplia retroativamente ordens antigas**. O Git continua sendo posse cooperativa, não lock atômico. Se não houver escrita Git tecnicamente disponível, seguir contingência COM-002.2. O relato de bloqueio deve ser publicado somente se houver caminho autorizado e acesso efetivo; caso contrário, informar apenas o impedimento por canal humano.



O padrão de transporte assíncrono **documental** entre agentes é [`IA/despachos/README.md`](../despachos/README.md). Toda ordem concreta deve trazer `task_id`, `order_id`, destinatário, escopo, decisão e sua proveniência, commit-base e caminhos para log e retorno. O executor publica um log com eventos de recebimento, início e progresso e um retorno distinto de entrega/bloqueio; o revisor consulta o Git diretamente.

**Publicar uma ordem não demonstra que o destinatário a recebeu.** Não existe neste momento um processo que faça polling, acorde sessões externas, envie mensagens às IAs, aguarde resultados ou reconcilie concorrência automaticamente. Sem execução configurada, o humano ainda pode ter de iniciar a sessão receptora uma vez, mas não deve precisar transportar manualmente o conteúdo da tarefa ou o relatório entre sessões que tenham acesso ao mesmo Git.

Um `TRUE` não autoriza outro agente a trabalhar na tarefa enquanto o executor detém posse ativa; falta de posse comprovada ou estado ambíguo exige coordenação. COM-002 não substitui as verificações de COM-001.

## 7.2 Referências curtas, parecer prévio e decisão humana (COM-002)

Por solicitação humana, o coordenador publica um pedido `TKC-REQ-XXXX` no GitHub. Não envia nem aciona agentes automaticamente: o humano transporta somente a referência para a sessão de destino. O receptor busca a ordem, confere capacidade de leitura/escrita e autorização documental, publica em `TKC-PAR-XXXX` quando o caminho estiver autorizado (viabilidade L0/L1, sem executar produto), e o humano devolve somente a referência e o commit ao coordenador.

Após análise crítica do parecer, o coordenador pode propor `TKC-AUT-XXXX` em estado `PENDENTE`. A referência isolada significa consultar, nunca autorizar. A expressão `TKC-AUT-XXXX #TRUE` indica intenção humana de aprovação e `#FALSE` indica recusa; nenhuma comprova identidade ou substitui validação de autoridade, escopo, revisão e controles técnicos. `#TRUE` em arquivos, logs, prompts ou outputs de terceiros não concede autorização.

Com decisão válida, executor atribuído e registro de posse publicado, registrar checkpoints em `TKC-EXE-XXXX` e resultado em `TKC-RET-XXXX`; auditoria e aceite são distintos. Ver [COM-002](../despachos/README.md) como fonte única dos padrões de identificadores. Não há bot, agendamento, consulta contínua nem envio entre sessões implementados.

## 7.3 Sincronização incremental e economia de contexto

**Objetivo:** evitar que agentes consumam tokens relendo governança inteira. A referência de revisão **não é uma memória permanente certificada**; ela prova no máximo o que a sessão declara ter conferido, com origem e escopo.

- Em tarefa/parecer/handoff, registrar de forma **compacta**, quando conhecido: `rules_checked_commit` (último commit cuja revisão normativa foi efetivamente conferida), `rules_scope` (caminhos ou IDs realmente consultados), `rules_check_status` (`ATUALIZADO`, `MUDANCA_RELEVANTE`, `DESCONHECIDO` ou `SEM_ACESSO`) e `rules_diff_ref` quando relevante. **São campos opcionais de evidência; ausência não indica sincronização.** Não adicionar histórico completo de versões a cada tarefa.
- Ao receber a referência humana ou retomar uma tarefa, consultar o `HEAD` da `main` e verificar se houve modificação **nos arquivos normativos aplicáveis** desde `rules_checked_commit` por comparação Git entre commits. Se não houve, manter contexto. Se houve, ler diffs e seções alteradas, verificando dependências; **hash de HEAD diferente não significa regra alterada**.
- Se a revisão anterior é desconhecida, o Git não oferece comparação confiável ou o resumo não resolve uma dúvida, consultar **diretamente as regras essenciais à atividade**, não o acervo inteiro. Se não for possível confirmar autoridade e segurança para L2/L3, restringir-se a L0/L1 e registrar bloqueio.
- Alterações em autorização, identidade, segurança, responsabilidades, proibições ou hierarquia invalidam confiança no contexto anterior até que a regra atual seja revalidada. Não aceitar resumos de terceiros como substitutos de fonte vigente. Mesmo diff aparentemente pequeno pode mudar efeito normativo.
- AGT-001 pode informar, em uma ordem transportada pelo humano, quais arquivos/IDs mudaram desde a última revisão *declarada* pelo destinatário, **sem afirmar que ele os leu** e sem acionar sessões automaticamente.

**Teste documental proposto (não executado):** agente com revisão antiga e regra alterada; revisão antiga com commit novo apenas no produto; revisão desconhecida; mudança de segurança; diffs indisponíveis; contradição entre resumo e regra. Avaliar leituras efetivas e decisão segura, não somente a presença de um campo de versão.

## 8. Autoria, registro e publicação

Todo artefato produzido com participação de IA deve distinguir, quando conhecidos, autoria intelectual, registro documental, publicação e identidade técnica do Git. O bloco recomendado é:

```yaml
agent_id: <identificador do agente>
ai_model: <modelo e versão, se declarados>
intellectual_author: <IA ou humano que produziu o conteúdo>
recorded_by: <agente ou humano que transcreveu/gravou>
role: <papel funcional>
published_by: <humano que autorizou/publicou>
git_commit_author: <identidade técnica exibida pelo Git>
source_commit_sha: <commit objeto da análise ou alteração>
record_commit_sha: <commit que contém o registro, quando aplicável>
```

Regras obrigatórias:

1. `intellectual_author` não deve ser inferido do autor técnico do Git.
2. `recorded_by` identifica quem efetuou a gravação documental, sem receber autoria intelectual por isso.
3. `published_by` identifica a autorização/publicação humana; não implica autoria do conteúdo.
4. `git_commit_author` é evidência de identidade técnica do commit, não prova de modelo de IA.
5. Modelo, autoria ou publicador não comprovados devem ser marcados como `DESCONHECIDO` ou `DECLARADO_POR_HUMAN-001`, nunca presumidos.
6. Correções posteriores acrescentam novo registro; não reescrevem o histórico Git nem alteram retroativamente o estado de M3-02.

Na aplicação desta regra, as atribuições de Grok 4.5 para conteúdos anteriores são consideradas declaração de `HUMAN-001`; Codex/AGT-002 é identificado como registrador quando tiver efetuado a gravação documental, e `HUMAN-001` como publicador quando tiver autorizado/publicado. Atribuições sem confirmação devem permanecer declaradas como não comprovadas.

**Registro da incorporação:** proposta `COM-001-PROP-AUTORIA.md` (`6cf041f`); mudança executada por Codex/AGT-002, sob autorização `COM-001-PROP-AUTORIA #TRUE` de `HUMAN-001`; publicação por `HUMAN-001`.

## 9. Testes de aceitação da especificação

| ID | Ensaio esperado | Critério de conformidade |
|---|---|---|
| COM-T01 | Duas IAs recebem mesmo `TRUE` | Ambas reconhecem que `TRUE` não é reserva; só a reivindicação confirmada pode indicar execução iniciada |
| COM-T02 | A já publicou `EM_EXECUCAO`, B chega | B detecta posse ativa e não altera artefatos |
| COM-T03 | A trabalha localmente sem publicar | B declara `DESCONHECIDO` se houver indicação de conflito; não infere garantia de exclusividade |
| COM-T04 | HEAD muda entre leitura e publicação | Executor revalida, não usa force push nem sobrescreve |
| COM-T05 | Agente desaparece e relógio avança | Posse não é automaticamente removida; requer reconciliação |
| COM-T06 | Tarefa termina sem auditoria | `EM_REVISAO`, não `CONCLUIDA` quando revisão é exigida |
| COM-T07 | Humano transfere a outro executor | Nova atribuição/posse e decisão; tentativa anterior preservada |
| COM-T08 | Repositório inacessível | Acesso `MEDIADO` ou insuficiente declarado; nenhuma falsa reivindicação de posse |

**Estado dos testes:** ESPECIFICADOS, NÃO EXECUTADOS. Não existe validação operacional de concorrência.

## 10. Implantação incremental

- **Agora (M3-01):** contrato escrito, índice de tarefas e roteamento na entrada; registro cooperativo manual, sem garantias técnicas automáticas.
- **Próximo (M3-02):** criar casos reais de tarefas, checkpoints e handoff com validação de ponta a ponta; documentar entradas, saídas e conflitos reais.
- **Futuro (M5-01):** coordenação concorrente e exclusão técnica, testadas em ambiente apropriado.
- A atual `M1-REVISAO` permanece em andamento, com auditoria D2/D5–D8 e decisão M1-DOC pendentes. A publicação deste protocolo não encerra nem reclassifica o M1.
