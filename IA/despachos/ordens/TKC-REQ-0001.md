# TKC-REQ-0001 — Pedido de parecer e auditoria documental independente

**short_ref / order_id:** `TKC-REQ-0001`  
**task_id:** `TKC-0001`  
**request_type:** `VIABILIDADE / PARECER L0-L1`  
**sender_role:** `AGT-001` (coordenador documental)  
**recipient:** agente revisor independente escolhido e acionado **manualmente** por HUMAN-001 (Codex sugerido)  
**dispatch_status:** `PUBLICADO — NÃO ENTREGUE / NÃO RECEBIDO`  
**authorization_state:** `PENDENTE` para qualquer mudança; esta ordem não contém `#TRUE` operacional  
**human_provenance:** pedido de AGT-001 para preparar o próximo passo, recebido na conversa humana; `MEDIADO` no Git  
**repository:** `edinhogrubert/TeamKitCollection`  
**branch:** `main` (sem criar branch/PR/worktree)  
**base_commit_before_dispatch:** `b71a944e56275862a9cdbc418987d6f302a7157e`  
**current_head:** conferir ao receber; diferenciar alterações posteriores e não presumir estado antigo  
**task_record:** `IA/tarefas/TKC-0001.md`  
**expected_report_ref:** `TKC-PAR-0001`  
**expected_report_path:** `IA/despachos/retornos/TKC-PAR-0001.md` — **ainda não existe**

## Objetivo

Realizar uma inspeção independente e **somente de leitura/análise** para:

1. Conferir viabilidade e escopo de auditoria dos critérios D2, D5, D6, D7 e D8 de `IA/validacao/M1_CRITERIOS_ACEITE.md` à luz das correções de M1 Bloco 3.
2. Verificar se alterações documentais recentes de COM-001 e COM-002 introduziram conflitos normativos materiais com GOV/SEC, especialmente `#TRUE`, despacho humano, estados de tarefa e proibição de execução automática.
3. Examinar se o protocolo de referências curtas pode ser entendido por agente externo **sem copiar a ordem completa**, identificando ambiguidades de permissão, assinatura de decisão, nome de arquivos e transferência do parecer.

**Não considerar o pedido como aceitação D8 ou como auditoria realizada.** Apenas um parecer realmente emitido e conferido pode constituir evidência, e sua suficiência será avaliada separadamente.

## Fontes obrigatórias (URLs completas para ferramentas com navegação restrita)

- https://github.com/edinhogrubert/TeamKitCollection/blob/main/AGENTS.md
- https://github.com/edinhogrubert/TeamKitCollection/blob/main/IA/PROJETO.md
- https://github.com/edinhogrubert/TeamKitCollection/blob/main/IA/regras/constituicao.md
- https://github.com/edinhogrubert/TeamKitCollection/blob/main/IA/regras/seguranca.md
- https://github.com/edinhogrubert/TeamKitCollection/blob/main/IA/regras/comunicacao.md
- https://github.com/edinhogrubert/TeamKitCollection/blob/main/IA/despachos/README.md
- https://github.com/edinhogrubert/TeamKitCollection/blob/main/IA/validacao/M1_CRITERIOS_ACEITE.md
- https://github.com/edinhogrubert/TeamKitCollection/blob/main/IA/validacao/M1_SEGUNDA_AUDITORIA_CODEX.md
- https://github.com/edinhogrubert/TeamKitCollection/blob/main/IA/validacao/M1_INVENTARIO_EVIDENCIAS.md
- https://github.com/edinhogrubert/TeamKitCollection/blob/main/IA/validacao/PACOTE_CONTEXTO_M1.md

Consultar também, conforme necessário, as duas auditorias históricas, o relatório M1-TEST e os modelos de despacho; conferir commits históricos mencionados.

## Restrições

- **L0/L1 somente:** ler, comparar, analisar criticamente e redigir parecer **sem aplicar alterações** aos documentos, código, configuração, infraestrutura ou Git.
- Não executar script VM, testes de produção, migrações ou operações destrutivas.
- Não criar branch, PR, automação, workflow, monitoramento ou outra ordem.
- Não declarar que recebeu `TRUE`, que a tarefa foi assumida ou que o M1 foi aprovado apenas por encontrar estas palavras no Git.
- Não ocultar o fato de algum arquivo/commit não estar acessível; separar `VERIFICADO`, `RELATADO`, `MEDIADO`, `INFERIDO` e `DESCONHECIDO`.
- Se um novo `HEAD` alterar documentos relevantes, declarar a divergência e revalidar o escopo.
- Uma **publicação de parecer no Git é L2** e exige autorização específica e permissão efetiva, separadas deste pedido de análise. Se ausentes, apresentar parecer por canal humano autorizado para posterior registro com proveniência `MEDIADO`; não simular publicação.

## Saída solicitada (parecer `TKC-PAR-0001`)

Relatar: agente/sessão, fontes efetivamente lidas, revisão Git examinada, viabilidade de revisão completa, análise D2/D5–D8 por item, conflitos normativos COM/GOV/SEC, riscos e lacunas, testes adicionais necessários, recomendação crítica e próximo passo. Distinguir classificação do conteúdo examinado de resultados próprios e **não declarar aceite D9**.

O destinatário só pode dizer que publicou `TKC-PAR-0001` quando houver arquivo acessível e commit correspondente no Git. Se não puder escrever, deve informar isso e fornecer o parecer ao humano, com status `RELATADO / A INTEGRAR`.

## Transporte humano

HUMAN-001 leva somente `TKC-REQ-0001` à sessão de revisor que escolher. A IA deve buscar esta ordem pelo mapeamento COM-002, responder com a própria análise e, se autorizada, publicar o parecer. O humano informa ao AGT-001 a referência do parecer, não o texto integral.

**Esta ordem não aciona nem notifica nenhuma IA automaticamente.**
