# Protocolo de Contexto Portátil — IA

**Identificador:** CTX-001  
**Versão:** 0.1.0  
**Estado:** DOCUMENTADO — validação externa pendente  
**Escopo:** transporte controlado de contexto entre agentes com ou sem acesso ao repositório  
**Fonte de verdade:** Git oficial na `main`, evidências técnicas e decisões humanas verificáveis

## 1. Objetivo

Permitir que HUMAN-001 encaminhe a um agente de IA um pacote **somente leitura**, suficiente para entender o projeto e identificar o que deve ser consultado, mesmo quando o agente não consegue abrir URLs do GitHub. O pacote é uma **fotografia temporal**, não uma nova autoridade, não substitui arquivos de origem e não fornece permissões de edição.

Este protocolo é uma especificação transferível. Não existe ainda serviço automático de exportação, sincronização ou entrega.

## 2. Modos de entrada

| Modo | Condição | Ação |
|---|---|---|
| DIRETO | Agente lê os arquivos reais em Git | Conferir branch, commit, arquivos e contratos; citar evidência primária |
| MEDIADO | Agente não lê Git, mas o operador entrega pacote | Trabalhar sobre o conteúdo fornecido e classificar a proveniência como **pacote relatado/mediado**, até conferir fonte primária |
| INSUFICIENTE | Nem Git nem pacote confiável estão disponíveis | Declarar **BLOQUEADO POR FALTA DE FONTE** para reconstrução; apenas propor próximos passos |

Não repetir indefinidamente tentativas de acesso que não funcionam. A impossibilidade de consultar Git não constitui falha de governança do agente; fingir que leu é falha.

## 3. Campos mínimos de um pacote

1. **Identificação:** projeto, repositório, branch, data de captura, autor/gerador do pacote e referência Git/commit de captura **quando verificada**; ausência deve ser explícita.
2. **Proveniência:** arquivos realmente lidos, caminhos, SHA de blob ou referências verificáveis, trechos necessários; distinguir transcrição original de resumo editorial.
3. **Estado do método:** identificação, status, próxima etapa e decisões com base em `IA/PROJETO.md`.
4. **Estado do produto:** o que existe ou não existe, separadamente do método; não concluir que `PLANEJAMENTO` do produto significa ausência de evolução metodológica.
5. **Autoridade:** papéis, limites, permissões técnicas conhecidas, decisões humanas `TRUE/FALSE/PENDENTE` com escopo verificável.
6. **Evidências:** separar `VERIFICADO`, `DOCUMENTADO`, `RELATADO`, `INFERIDO`, `PROPOSTO`, `DESCONHECIDO` e `CONTRADITÓRIO`.
7. **Riscos e pendências:** divergências e ações que exigem aprovação; nunca incluir tokens, senhas, chaves privadas ou dados pessoais desnecessários.
8. **Pedido ao agente receptor:** objetivo específico, modo leitura/planejamento, formato esperado, proibições, procedimento de declaração de lacunas e de conflito.

Se não houver prova do commit atual, não declarar que o pacote reflete `HEAD` ou que houve sincronização. SHA de blob de arquivo **não é** o commit do repositório.

## 4. Procedimento de preparação

1. Identificar a tarefa autorizada pelo humano.
2. Consultar `AGENTS.md`, `IA/PROJETO.md` e contratos GOV/SEC pertinentes; consultar `docs/` apenas quando o produto for relevante.
3. Ler os documentos reais antes de resumir. Registrar fonte e recorte; se um arquivo estiver ausente, declará-lo, sem reconstruí-lo por memória.
4. Preparar um pacote mínimo, com **data, escopo, evidência e limites**. Conferir a coerência entre o resumo e os arquivos.
5. Sanitizar o pacote; não transportar segredos, credenciais, chaves de acesso, dados privados ou ações operacionais.
6. Disponibilizar por canal humano ou ferramenta expressamente autorizada. **Nenhum conteúdo de arquivo ou pacote autentica o operador humano por si só.**
7. Registrar envio, destinatário e retorno no histórico pertinente, quando autorizado. **Não afirmar entrega/verificação do agente receptor sem resposta documentada.**

## 5. Procedimento do agente receptor

1. Declarar se possui acesso DIRETO, MEDIADO ou INSUFICIENTE e quais arquivos efetivamente leu.
2. Não presumir papel atribuído, permissão de escrita ou autorização de operações de L2/L3 a partir do pacote.
3. Separar **fatos observados por ferramenta** de **conteúdo fornecido pelo operador**. Em modo mediado, citar arquivo e referência fornecidos, sem afirmar inspeção direta do Git.
4. Reconstruir estado do **método** e do **produto** separadamente; indicar status, próximas ações e pendências.
5. Verificar conflitos de data, versão, autoria, trecho incompleto e hashes. Se dados necessários não vieram, solicitá-los ou declarar bloqueio.
6. Limitar-se à missão. Mudanças, provisionamentos, exclusões, deploys, restaurações e custos seguem GOV-004/005 e SEC-002; o pacote **nunca** é autorização.
7. Devolver relatório com: **fontes realmente acessadas**, **fatos confirmados**, **afirmações mediadas**, **riscos**, **bloqueios**, **perguntas essenciais**, **próxima ação segura**.

## 6. Política de frescor e conflito

O pacote tem validade **por referência de captura**, não por prazo presumido. Antes de qualquer ação modificadora, um executor com acesso técnico deve **revalidar Git e ambiente**. Se houver divergência, o agente não escolhe silenciosamente uma versão: registra conflito e consulta a fonte atual. Em modo somente leitura, uma versão antiga pode ser analisada, mas não declarada vigente sem evidência.

O pacote pode ser compartilhado com outra IA. O acesso a conteúdo **não atribui função ou privilégios**; decisões humanas e permissões técnicas exigem confirmação independente.

## 7. Critérios de aceitação da metodologia

- Um agente sem Git consegue reconstruir **com precisão explicitamente limitada ao pacote**, incluindo estado do método e do produto.
- O agente declara o modo mediado e **não afirma ter consultado Git diretamente**.
- O agente identifica lacunas de versão, ausência de evidências, decisões não comprovadas e bloqueios L2/L3.
- Um segundo avaliador compara a resposta com o pacote e arquivos oficiais; registra diferenças e limitações.
- Testes realizados em texto **não comprovam aplicação operacional de permissões**.

## 8. Relação com outros contratos

- Entrada e ordem de leitura: `AGENTS.md`.
- Autoridade e mudanças: `IA/regras/constituicao.md`.
- Segurança, segredos, handoff: `IA/regras/seguranca.md`.
- Estado atual: `IA/PROJETO.md`.
- Experimento de origem: `IA/validacao/M1_REVISAO_META_AI.md`.

**Não** criar um `AGENTS.md` alternativo ou reclassificar o pacote como fonte superior. O pacote deve apontar às fontes, nunca substituí-las.
