# Caixa de despachos multiagente — COM-002

**Estado:** PROTOCOLO DOCUMENTAL, SEM CONSUMIDOR AUTOMÁTICO INSTALADO  
**Origem de autoridade:** `AGENTS.md`, `IA/PROJETO.md`, `IA/regras/constituicao.md`, `IA/regras/seguranca.md` e `IA/regras/comunicacao.md` (COM-001)  
**Missão:** oferecer um **local comum de escrita e leitura** de ordens, checkpoints e respostas, acessível a agentes e humanos com acesso Git. O repositório é transporte e evidência; **não é um serviço de mensagens em tempo real**.

## Estrutura obrigatória

- `IA/tarefas/<TASK-ID>.md`: fonte de estado detalhado e posse de uma tarefa, conforme COM-001.
- `IA/despachos/ordens/<TASK-ID>-<SEQ>.md`: envelope **imutável em significado** de uma ordem. Cada revisão substancial gera nova ordem sequenciada, nunca sobrescreve a autorização original.
- `IA/despachos/logs/<TASK-ID>-<CLAIM-ID>.md`: registro de execução da tentativa, atualizado com eventos acrescentados; deve ligar ordem, versão-base, checkpoints, saídas e commits.
- `IA/despachos/retornos/<TASK-ID>-<CLAIM-ID>.md`: resposta final/entrega ou bloqueio do executor, com evidências e indicação explícita de que é **relato do executor**, não aprovação independente.
- `IA/tarefas/indice.md`: localização e resumo das tarefas; não substituir a consulta ao registro detalhado.

Modelos canônicos: `IA/despachos/MODELO_ORDEM.md` e `IA/despachos/MODELO_RETORNO.md`. Modelos não constituem ordens reais; nenhum agente deve executá-los.

## Ciclo de comunicação

1. O coordenador ou humano autorizado cria/atualiza o registro da tarefa e publica uma ordem com `task_id`, `order_id`, `recipient`, `authorization`, `scope`, `base_commit`, critérios de aceite e local da saída.
2. A publicação é **DESPACHO DISPONÍVEL**, não `RECEBIDO`. Uma sessão com Git deve ser explicitamente instruída a consultar a caixa na entrada ou mediante integração configurada. Nunca alegar leitura automática não observada.
3. O destinatário confirma leitura publicando `RECEBIDO` no registro de tarefa/log, contendo `order_id`, `agent_id`, `session_ref` e commit visto. Se não houver permissão para escrever ou conflito, deve responder por canal autorizado, com estado `NÃO CONFIRMADO`.
4. `TRUE` humano autoriza apenas o escopo, não prova entrega da ordem, início ou posse. Antes de modificar, cumprir COM-001: verificar sobreposição, publicar `EM_EXECUCAO` e confirmar no remoto.
5. O executor acrescenta checkpoints relevantes ao log e publica commits da entrega. Se houver falha, publica `BLOQUEADA` ou `FALHOU` com efeitos e recuperação conhecidos.
6. O executor publica o retorno em `retornos/`, referenciando ordem, log, arquivos, diff, hashes, verificações e limitações. Estado `EM_REVISAO` quando houver auditoria pendente.
7. O coordenador/revisor consulta diretamente Git, confere commit atual e fontes, registra aceite/reprovação em evento distinto e atualiza a tarefa. Não precisa que o humano copie textos entre conversas **se estiver ativamente consultando o repositório**.

## Semântica e segurança

- Identificadores de mensagem: `order_id = <TASK-ID>-O<SEQ>`; `claim_id` identifica uma **tentativa** e nunca é reutilizado. Logs/retornos identificam o emissor e distinguem `VERIFICADO`, `RELATADO`, `MEDIADO` e `DESCONHECIDO`.
- `PUBLICADO`, `RECEBIDO`, `INICIADO`, `EM_EXECUCAO`, `ENTREGUE`, `REVISADO` e `APROVADO` são eventos diferentes. Não inferir evento posterior a partir do anterior.
- Dados de sessão e logs: sanitizar segredos, tokens, prompts privados, credenciais e informações pessoais; não versionar saída bruta sensível. Saídas volumosas podem ser artefatos referenciados por hash e local autorizado.
- Não reescrever um relato para torná-lo favorável. Correções geram novo evento ou arquivo de retificação, preservando o anterior no histórico Git.
- **Não há polling, webhook, bot, gatilho, notificação, lock atômico, fila com confirmação nem heartbeat automático instalado por este documento.** Uma sessão que não está ativa/observando não recebe mensagens automaticamente.
- Um futuro despachante automático deverá possuir identidade e permissões técnicas mínimas, autenticar eventos, deduplicar `order_id`, conferir autorização/posse, revalidar `main`, lidar com erros/retries e somente entregar ordens em canal configurado. Exige projeto, teste e autorização próprios; não presumir que AI Studio/Codex expõem API de recepção.
- Não publicar nenhuma ordem operacional retroativa para justificar trabalho já concluído.

## Testes a executar (não executados)

| ID | Cenário | Aceitação |
|---|---|---|
| DSP-T01 | Ordem publicada, agente não acessa Git | `PUBLICADO` não vira `RECEBIDO` |
| DSP-T02 | Duas IAs leem a mesma ordem | Apenas responsável reivindica; duplicata não executa |
| DSP-T03 | `TRUE` sem registro de início | Não declarar `EM_EXECUCAO` |
| DSP-T04 | Executor publica entrega e retorno | Auditor localiza tudo por `task_id/order_id/claim_id` |
| DSP-T05 | Execução falha após commit parcial | Log e retorno mostram efeito parcial, sem `CONCLUIDA` |
| DSP-T06 | Revisão reprova | Preservar entrega anterior e registrar decisão distinta |

**Situação:** modelos e local de troca disponíveis; integração automática entre ferramentas não implementada nem testada.
