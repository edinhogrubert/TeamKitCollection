# TKC-REQ-0005 — Pedido de parecer de viabilidade L0/L1

**ATENÇÃO:** pedido de análise, **NÃO** autorização para implementar, editar código, provisionar recursos ou alterar infraestrutura. **Correção C03:** retorno por Git direto, quando possível, ou por transporte humano de resposta completa a AGT-001 para publicação mediada; publicação não prova recebimento.

| Campo | Valor |
|---|---|
| `task_id` | `TKC-0005` |
| `order_id / short_ref / request_type` | `TKC-REQ-0005` / `TKC-REQ-0005` / `VIABILIDADE L0/L1` |
| `recipient / agent_role` | Gemini AI Studio — destinatário indicado por HUMAN-001 para o pedido já enviado; capacidade de escrita Git **NÃO VERIFICADA** |
| `sender` | AGT-001 — coordenador técnico, autor da preparação documental |
| `authorization_state` | `TRUE` **somente** para AGT-001 preparar/publicar este pedido; `PENDENTE` para executor/receptor e qualquer modificação futura |
| `authorization_provenance` | `MEDIADO` — autorização expressa nesta conversa, sem autenticação independente pelo arquivo |
| `decision_ref / human_scope` | Manifestação HUMAN-001 para escrever somente `TKC-0005.md`, índice e esta REQ; não autoriza L2/L3 operacional nem produção de código |
| `status` | `PUBLICADO / RESPOSTA RELATADA PELO HUMANO / PARECER GIT AINDA NÃO RECEBIDO` — HUMAN-001 informou que Gemini respondeu; retorno no Git não verificado |
| `repository / branch` | `edinhogrubert/TeamKitCollection` / `main` |
| `base_commit` | `9fa1b26982ba86c37f3395ef84896e7ac6b35371` (base da preparação); reivindicação confirmada `1ee8fe4b3a9806dc2afc81ca016157f0bb36ec98`; consultar HEAD atual antes de responder |
| `task_record` | `IA/tarefas/TKC-0005.md` |
| `scope_paths` | Somente análise L0/L1 do escopo proposto no registro; **nenhuma alteração no objeto de estudo** |
| `forbidden_actions` | Código, comandos executáveis, containers, servidores, redes, credenciais, alterações Git não autorizadas, mudanças normativas, automações, supor atribuição ou aceite |
| `dependencies` | `AGENTS.md`, COM-001, COM-002 e limites do projeto; TKC-0004 fornece proposta, não nova norma |
| `claim_conflicts` | Preparação C01 entregue; nenhuma reivindicação de execução futura criada; revalidar remoto antes de qualquer execução posterior |
| `feasibility_report_ref` | **Destino obrigatório de retorno:** `IA/despachos/retornos/TKC-PAR-0005.md`; não existia na `main` na conferência pré-C02; Gemini deverá publicar se tiver acesso e autorização verificados |
| `required_checks` | Verificar capacidade de acesso, restrição de custo e riscos; diferenciar proposta de tecnologia e comportamento efetivamente demonstrado |
| `log_path` | `IA/despachos/logs/TKC-EXE-0005.md` — somente após autorização específica futura, não criado |
| `return_path` | `IA/despachos/retornos/TKC-PAR-0005.md` — destino persistente em ambos os modos: Gemini publica diretamente quando habilitado, senão HUMAN-001 traz o parecer e AGT-001 publica como `MEDIADO` mediante autorização apropriada |

## Entrada: o que deve ser analisado

Propor a viabilidade de uma **fatia vertical real do TeamKitCollection**, como primeiro teste operacional da comunicação entre IAs: backend mínimo com endpoint `GET /health` que consulte PostgreSQL; Docker Compose de laboratório isolado com rede e persistência; teste automatizado do caso saudável e comportamento da indisponibilidade do banco; documentação de reprodução e evidências.

Não se exige escolha automática de Django, FastAPI ou outra tecnologia. Comparar candidatas por arquitetura evolutiva, confiabilidade, operação, segurança, facilidade de verificação pela IA, custos efetivos e capacidade do ambiente, **sem usar falta de especialização humana como critério para simplificar a arquitetura**.

**Fora deste primeiro piloto candidato:** interface completa de camisetas, autenticação de produção, login Google/Firebase, DNS público, TLS público, VM Oracle, replicação regional e destruição/limpeza de recursos; esses assuntos pertencem à arquitetura-alvo e a pacotes futuros.

### Perguntas obrigatórias para o parecer

1. **Capacidade da sessão:** qual modo de acesso efetivamente comprovado (`DIRETA`, `MEDIADA`, `SEM_ACESSO` ou `NÃO_VERIFICADA`) ao Git, escrita, execução local, PR e retorno? Quais URLs realmente abriu?
2. **Viabilidade:** qual arquitetura, componentes e versões tecnológicas recomenda para essa fatia, e por quê? Que alternativas e riscos existem?
3. **Escopo futuro:** que caminhos de produto/código/infraestrutura deverão ser criados? Quais operações exigem autorização separada, especialmente Docker e rede?
4. **Segurança:** como garantir credenciais não versionadas, portas mínimas, persistência, logs sanitizados e reversão sem perda involuntária de volumes?
5. **Verificação:** quais testes concretos permitiriam afirmar que app, banco e Compose funcionam? Como comprovar a falha controlada do banco sem expor o servidor?
6. **Recuperabilidade:** que `next_action`, arquivos e commit uma sessão sucessora receberia para continuar sem histórico de chat?
7. **Métricas:** como coletará esforço técnico, esforço do método, intervenções humanas, tentativas e custo financeiro sem inventar medições?
8. **Parecer final:** `VIAVEL`, `VIAVEL_COM_CONDICOES` ou `NAO_VIAVEL`? Identifique bloqueadores reais versus melhorias posteriores.

### Links de leitura em prioridade

1. [Registro TKC-0005](https://github.com/edinhogrubert/TeamKitCollection/blob/main/IA/tarefas/TKC-0005.md).
2. [AGENTS.md](https://github.com/edinhogrubert/TeamKitCollection/blob/main/AGENTS.md).
3. [COM-001](https://github.com/edinhogrubert/TeamKitCollection/blob/main/IA/regras/comunicacao.md) e [COM-002](https://github.com/edinhogrubert/TeamKitCollection/blob/main/IA/despachos/README.md).
4. [TKC-0004, preparação anterior](https://github.com/edinhogrubert/TeamKitCollection/blob/main/IA/tarefas/TKC-0004.md), somente se necessária para rastrear propostas e HND-T01.
5. [README do produto](https://github.com/edinhogrubert/TeamKitCollection/blob/main/README.md).

Quando houver limite de navegação, priorizar a própria ordem e o registro; informar quais demais fontes não foram acessadas. Para avaliação L0/L1 por colagem humana, declarar `MEDIADO`; **não alegar revisão Git direta**.

### Instruções de resposta

- Ler as fontes realmente acessíveis, identificar `task_id`, compromisso de **não executar** e estado da ordem `PUBLICADO`.
- Produzir parecer objetivo com premissas, alternativas, viabilidade, riscos, plano de ensaio e limitações.
- **Retorno esperado em um de dois canais:** se Gemini puder escrever no Git, seguir COM-001 e publicar `TKC-PAR-0005` com commit; se não puder, apresentar o parecer completo na própria conversa, junto com o rodapé `TKC-PAR-0005 PRONTA — SEM ESCRITA GIT. LEVE ESTA RESPOSTA A AGT-001`. HUMAN-001 transporta esse conteúdo uma única vez e AGT-001 o publica no Git identificado como `MEDIADO`, mediante permissão adequada. Resposta pronta não equivale a publicação ou aceite.
- Não assumir que publicar esta REQ gera `RECEBIDO`, claim de execução, `TRUE` operacional, testes, revisão ou aprovação.
- Nenhuma sessão externa está sendo acionada automaticamente.

## Histórico

1. `PUBLICACAO_PREPARADA` — AGT-001, sob autorização documental relatada de HUMAN-001, preparou `TKC-REQ-0005` para transporte humano por referência; sua publicação será demonstrada pelo commit do próprio arquivo.

## Retificação C02 — instrução de devolução ao Gemini

**Motivo:** HUMAN-001 informou que Gemini já respondeu, mas o documento `TKC-PAR-0005` não estava publicado; a alternativa de colagem integral pelo humano frustrou o contrato de comunicação multiagente. **Não se trata de nova pergunta técnica ao Gemini:** preservar seu parecer original, transferindo-o para o destino Git.

**Entregar a referência curta desta REQ e executar os passos abaixo somente se a sessão possuir acesso Git e autorização humana aplicável:**

1. Confirmar a capacidade real de leitura/escrita GitHub. Não presumir acesso porque a IA pode ler uma URL.
2. Confirmar no canal humano que a autorização é estritamente para publicar seu próprio parecer nos **arquivos de comunicação** `IA/despachos/retornos/TKC-PAR-0005.md`, `IA/tarefas/TKC-0005.md` e `IA/tarefas/indice.md` (este último par somente para reivindicar e liberar posse). Não editar os arquivos técnicos do projeto. A manifestação em Git é `MEDIADO` e não certifica identidade.
3. Conferir HEAD e conflitos de tarefas; criar reivindicação cooperativa nova (candidata `TKC-0005-C03`, desde que livre) no registro e índice; **publicá-la e verificar o commit no remoto antes de criar o parecer**. Não reaproveitar C01/C02 nem sobrescrever claims de outro agente.
4. Criar `IA/despachos/retornos/TKC-PAR-0005.md` com o parecer já produzido, sem inventar leituras/testes. Incluir identificação, REQ, base, commits, fontes realmente inspecionadas, capacidades da sessão, arquitetura, riscos, alternativas, plano, custo R$ 0,00 e veredito.
5. Registrar o commit da entrega e liberar a própria posse no registro/índice, com estado de tarefa `EM_REVISAO` enquanto aguarda coordenação; nenhum aceite automático.
6. Informar HUMAN-001 **somente a referência `TKC-PAR-0005`** (e opcionalmente link do commit). HUMAN-001 informa AGT-001 que publicou; AGT-001 consulta o Git.

**Se não puder publicar no Git:** resposta única `SEM_ESCRITA_GIT`, com causa conhecida/limitante, sem alegar sucesso. O coordenador deverá corrigir o transporte técnico por canal autorizado sem exigir colagem do parecer ao HUMAN-001. **Nenhum segredo, token ou chave deve ser enviado ou versionado para contornar a falta de acesso.**

Essa retificação não autoriza código, Docker, rede, servidores, mudanças de regras nem nova análise técnica. Não existe entrega automática entre sessões.

**Histórico:** correção de comunicação C02 por AGT-001, com autorização humana mediada; reivindicação C02 publicada no commit `e25c1a011a3e287ffb2788314ee62aad77907f11`. O commit da retificação será identificável pelo Git após a publicação.

## Retificação C03 — dois modos de retorno, acordo atual

Esta seção **substitui apenas a exigência de retorno exclusivamente Git e a proibição de colagem da C02**. Preserva o restante do pedido L0/L1 e as regras de segurança/autorização existentes.

**Modo A — IA com escrita Git autorizada:** publicar o parecer no destino `IA/despachos/retornos/TKC-PAR-0005.md`, observando reivindicação prévia e conferência remota de COM-001, e terminar a resposta ao humano com a linha `TKC-PAR-0005 PUBLICADA NO GIT — commit: <SHA>`. O humano só comunica a referência a AGT-001; AGT-001 consulta o arquivo. A existência de link ou claim não prova que o parecer esteja correto.

**Modo B — IA sem escrita Git:** fornecer **a resposta completa no próprio chat**, acompanhada ao final pela linha exata `TKC-PAR-0005 PRONTA — SEM ESCRITA GIT. LEVE ESTA RESPOSTA A AGT-001`. HUMAN-001 traz a resposta para AGT-001; AGT-001 publica no mesmo destino persistente, registrando `autor_original=Gemini`, `publicador=AGT-001`, `proveniência=MEDIADO`, `acesso_Git_do_autor=SEM_ESCRITA` e o compromisso de não interpretar o relato como teste verificado. Publicação por AGT-001 exige reivindicação e autoridade aplicáveis no próprio momento. **Não enviar chaves/tokens ao humano ou ao chat.**

**Modo C — falha/impedimento:** terminar com `TKC-PAR-0005 BLOQUEADA — motivo: ...` e dados suficientes para AGT-001 identificar a dependência real, sem declaração falsa de entrega.

**Semantica para HUMAN-001 e AGT-001:** "Gemini publicou a TKC-PAR-0005" significa **buscar no Git**; "trouxe a resposta do Gemini" significa **receber material mediado e publicar com proveniência adequada**. Se nada foi publicado ou transmitido, não há parecer disponível. Nenhum desses modos autoriza código ou infraestrutura.
