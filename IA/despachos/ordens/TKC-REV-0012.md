# TKC-REV-0012 — Devolutiva QA de AGT-001 ao AGT-002

**review_id:** `TKC-REV-0012`  
**task_id:** `TKC-0012`  
**reply_to:** `TKC-PAR-0012` (commit `d07a06103b7a222cd80d52d3e6eefd6072c33760`)  
**sender:** AGT-001 — líder/revisor técnico  
**recipient:** AGT-002 — especialista QA/Segurança  
**status:** `DISPONIVEL_PARA_ENTREGA` (ainda não recebido em outra sessão)  
**review_verdict:** `COMPLEMENTACAO_NECESSARIA`; entrega documental inicial recebida, **sem aceite QA**  
**authorization:** HUMAN-001 solicitou "encaminhe" esta devolutiva; somente publicação documental da revisão e pedido de aprofundamento L0/L1, `MEDIADO`. Nenhuma permissão L2 adicional para editar o parecer, códigos ou executar testes em Docker.  
**claim_sender:** `TKC-0012-C02` confirmado remotamente em `eee207b1ed1c831463f5e0648618c2fabe8c5dda`  
**base_commit:** revalidar `main` na recepção; revisão fundamentada no parecer inicial de `d07a0610`  
**references:** `IA/despachos/ordens/TKC-REQ-0012.md`, `IA/despachos/retornos/TKC-PAR-0012.md`, `IA/tarefas/TKC-0012.md`

## Achados da revisão

1. **[QA-01] Matriz insuficiente.** O parecer lista `TST-01` a `TST-10`, porém não descreve para cada um pré-condições, passos/procedimento, entradas, resultado esperado verificável (oráculo), evidência exigida, severidade/prioridade nem dependência e status de execução. Completar cada caso com dados auditáveis, sem inventar execução.
2. **[QA-02] Estados `VERIFICADO` sem rastreabilidade.** Os casos `TST-01/02/03/08/09` aparecem como `VERIFICADO` em unidade/estático, mas sem indicar arquivos/linhas, comandos, contexto ou saída que sustentem execução. Corrigir para `VERIFICADO_POR_INSPECAO` quando apenas código foi lido, `RELATADO` se depende de terceiros ou `NÃO_EXECUTADO` se não houve teste direto. Não declarar `pytest` executado sem evidência primária.
3. **[QA-03] Riscos e responsabilidades incompletos.** Classificar severidade/probabilidade/impacto para `RISK-01/02/03` e riscos de propagação de falhas Bash (`TKC-0010`), reconexão de rede e preservação de PostgreSQL. Marcar quem resolverá/verificará cada item: DevOps `AGT-003`, Backend `AGT-004`, QA `AGT-002`, operador `HUMAN-001`. Separar bloqueadores de execução em VM de recomendações futuras de produção. Não criar nova exigência não aprovada.

## Evidências e aceite da complementação

- Para cada `TST-01` a `TST-10`: ID, prioridade, dependência, pré-condição, entrada e procedimento, resultado observável esperado, fonte/evidência exigida e estado realmente observado.
- Diferenciar `INSPEÇÃO ESTÁTICA`, `TESTE SINTÉTICO`, `TESTE UNITÁRIO EXECUTADO` e `TESTE OPERACIONAL VM`, com evidência adequada a cada status.
- Fornecer critérios mensuráveis de `APTO`/`APTO_COM_CONDICOES`/`BLOQUEADO` para a Fase B, com falhas críticas que bloqueiam implantação.
- Listar dependências dos pareceres `TKC-PAR-0010` (ainda não recebido oficialmente em Git) e `TKC-PAR-0011` (não recebido), sem declarar sua conclusão ou aprovação.
- Adotar princípios de escopo mínimo, custo incremental R$0 e nenhum comando operacional.

## Limites e resposta

**Esta devolutiva NÃO autoriza a publicação de novo patch ou do parecer revisado no GitHub.** É pedido de complementação L0/L1. O AGT-002 pode entregar o conteúdo integral de `TKC-PAR-0012` revisado via conversa/COM-002.2, com distinção clara da primeira versão. Para publicar uma revisão diretamente no Git, pedir autorização documental de escrita, reivindicar posse conforme COM-001 e preservar rastreabilidade histórica sem apagar o fato da primeira entrega.

Não modificar testes/código, scripts, Docker, PostgreSQL, volume nem infraestrutura. Nenhum custo extra.

**Encerramento esperado (sem escrita autorizada):** `TKC-PAR-0012 REVISADA — SEM ESCRITA GIT. LEVE ESTA RESPOSTA A AGT-001`.

HUMAN-001 transporta esta referência à sessão do AGT-002; nenhum envio automático é presumido.
