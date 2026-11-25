# TKC-AUT-0005 — PROPOSTA PENDENTE de autorização para o primeiro corte executável

**Documento de proposta, NÃO é ordem executável.** Um identificador `TKC-AUT-0005` isolado é referência para leitura. Esta publicação, mesmo feita por AGT-001 autorizado a preparar documentos, **não autoriza** código, Docker, serviços, rede, permissões, dados ou despesa.

| Campo | Valor |
|---|---|
| `task_id` | `TKC-0005` |
| `order_id / short_ref / request_type` | `TKC-AUT-0005` / `TKC-AUT-0005` / proposta de decisão humana |
| `status` | **`PENDENTE`** — sem decisão de execução |
| `sender` | AGT-001 — preparação documental C05 |
| `recipient` | HUMAN-001 para decisão; candidato a executor técnico: AGT-002 (Gemini) ou outro agente expressamente designado |
| `executor_assigned` | **NÃO DESIGNADO** — proposta não atribui trabalho automaticamente |
| `reviewer_assigned` | **NÃO DESIGNADO** — exigir sessão distinta do executor, com fontes realmente acessadas |
| `authorization_state` | **`PENDENTE` para ambas as fases A e B**; `TRUE` de HUMAN-001 nesta conversa refere-se somente à criação desta proposta |
| `authorization_provenance` | C05 documental `MEDIADO`; autorização operacional futura ainda não existe |
| `decision_ref / approval_channel` | HUMAN-001 deverá decidir escopo/versão/fases expressamente no seu canal; `#TRUE` sem verificação de autoridade, escopo e estado Git não autentica operação |
| `repository / branch` | `edinhogrubert/TeamKitCollection` / `main`; planejar branch isolada de implementação, sem presumir proteção/PR configurados |
| `base_commit` | `a8a687cc17342b5561db67cc0a794d0b985134bc` (parecer C04 integrado); C05 reivindicação `ce21dfd5a733ecc1f7ec40c7e713ed2e55ba83bd`; **revalidar HEAD** antes de qualquer tentativa |
| `task_record` | `IA/tarefas/TKC-0005.md` |
| `feasibility_report_ref` | `IA/despachos/retornos/TKC-PAR-0005.md` — `VIAVEL_COM_CONDICOES`, publicado no commit `a8a687cc17342b5561db67cc0a794d0b985134bc` |
| `dependencies` | COM-001, COM-002, normas de segurança; autorização específica para cada fase; capacidade real de Git e de Docker a verificar |
| `claim_conflicts` | C01–C05 encerradas após entrega documental; antes da fase autorizada criar nova reivindicação `TKC-0005-C06` **somente se livre** e confirmar no remoto |
| `log_path` | `IA/despachos/logs/TKC-EXE-0005.md` — **não criado**; criação exige autorização operacional |
| `return_path` | `IA/despachos/retornos/TKC-RET-0005.md` — **não criado**; retorno direto ou mediado COM-002.2 |
| `cost_constraint` | R$ 0,00 incremental, obrigatório; valores não estimados como custos reais |

## 1. Decisão solicitada — duas fases independentes

**Fase A — construir arquivos, sem subir infraestrutura (`PENDENTE`).** Solicitar autorização L2 para criar e modificar exatamente os seguintes caminhos do primeiro corte:

- `src/backend/__init__.py`, `src/backend/config.py`, `src/backend/db.py`, `src/backend/main.py` e `src/backend/requirements.txt`;
- `tests/unit/test_health_unit.py` e `tests/integration/test_health_compose.py`;
- `infra/docker/Dockerfile.backend`, `infra/docker/docker-compose.lab.yml`, `infra/docker/.env.lab.example` e `.gitignore`;
- `docs/arquitetura.md`, `docs/contratos-api.md`, `docs/infraestrutura.md`, `docs/testes.md` e `docs/operacao.md`;
- registros de comunicação `IA/tarefas/TKC-0005.md`, `IA/tarefas/indice.md`, `IA/despachos/logs/TKC-EXE-0005.md` e `IA/despachos/retornos/TKC-RET-0005.md`, apenas para posse, progresso, evidências e resultado.

**Ações desta fase quando autorizadas:** editar somente os caminhos aprovados, consultar documentação pertinente, preparar API, configurações e testes, executar apenas verificações estáticas/unitárias locais sem recursos externos **quando o ambiente e comandos estiverem explicitamente incluídos na decisão**, publicar commits/branch/PR conforme permissão efetiva. Não iniciar Docker, abrir portas, instalar serviços de sistema, fazer deploy público nem usar credenciais em prompt. Registrar testes não executados como tal.

**Fase B — executar laboratório Docker local (`PENDENTE`, autorização separada).** Exige decisão nominal posterior para um **ambiente identificado** com Docker/Compose efetivos, operador responsável, limites de memória/disco/rede, criação de containers, rede/volume do laboratório e comandos de subida/parada/reinício. Portas públicas proibidas; apenas `127.0.0.1:8000` para API, PostgreSQL sem `ports:` exposto no host. Sem autorização da fase B, o código e o Compose podem ser entregues na fase A, mas **nenhum teste de integração Docker pode ser marcado como executado**. A fase B não é liberada pelo mesmo `#TRUE` genérico da fase A; registrar decisão expressa de cada fase.

**Proibições comuns:** destruição/remoção de volumes (`down -v`, `docker volume rm`), redes/servidores de produção, custos, uso de recursos de terceiros sem verificação de cobrança, alterações normativas `IA/regras/` e `IA/despachos/README.md`, credenciais no Git/chat, mudanças em `IA/PROJETO.md`, arquivos não listados, acionamento automático de outra IA, publicação como se revisão/aceite já tivessem ocorrido. Qualquer operação não coberta deve ser separadamente proposta e autorizada.

## 2. Contrato técnico do corte (objetivo, não implementação)

**Meta mínima:** serviço API stateless com `GET /health` que consulta PostgreSQL por `SELECT 1` dentro de timeout limitado. Com DB saudável, HTTP `200` e `database: up`; com indisponibilidade do DB, HTTP `503` com `DB_UNAVAILABLE` e mensagem sanitizada, sem DSN/senha/stack trace. Recuperação do DB deve restaurar HTTP `200` sem exigir recriação do app. Persistência deve sobreviver a reinício do container DB sem exclusão de volumes.

**Candidata fundamentada no parecer de Gemini:** Python/FastAPI + Psycopg 3 + PostgreSQL + Docker Compose. Versões sugeridas no `TKC-PAR-0005` são **referências históricas do parecer**, não um conjunto de dependências já verificado quanto a suporte/segurança em 2026. Executor deverá validar versões, imagens, licenças, compatibilidade, fixação segura e `R$ 0,00` antes de construir. Não ampliar arquitetura para gateway, múltiplas regiões, replicação ou CRUD neste pacote.

**Testes observáveis:**
1. Análise estática da configuração Compose e ausência de segredos/portas externas;
2. Testes unitários de `200` e `503` por injeção de falha, incluindo inspeção do corpo e logs contra vazamento;
3. Com fase B autorizada, `docker compose config`, `up -d --build --wait` no laboratório validado, `curl` contra `127.0.0.1:8000/health` retornando `200` com DB ativo;
4. Teste controlado de indisponibilidade do DB produzindo `503` em tempo limitado, seguido de restauração para `200`;
5. Verificação de persistência de dado sintético após reinício DB, sem remoção de volumes.

**Evidência obrigatória:** commit/branch, comandos efetivamente executados, versões do ambiente, saída sanitizada dos testes, `PASS/FAIL/NÃO_EXECUTADO`, limitações, eventuais efeitos e procedimento de reversão autorizado. Nunca declarar um teste `PASS` apenas por aparecer no plano. Registrar tentativas, `horas_estimadas`, `horas_reais_construcao`, `horas_reais_metodo`, `intervencoes_humanas`, retrabalho e custo com fonte ou `NÃO MEDIDO`.

## 3. Capacidade, segurança e responsabilidades

- **AGT-002/Gemini** foi revisor de viabilidade L0/L1; relatou sandbox com `git`, mas sem `docker`, `psql`, `pip` e `pytest`. Uma autorização de codificação não torna esses programas disponíveis. Confirmar capacidades da sessão nova, pois o container pode reiniciar e perder configuração efêmera.
- **Publicação Git:** preferir acesso formalmente configurado por meio seguro; nunca inserir PAT, senha ou chave no prompt. Permissão técnica + decisão humana válida + claim COM-001 são requisitos distintos.
- **Executor da fase A:** candidato AGT-002 ou outro designado. **Validação da fase B:** operador/agente com Docker real no host autorizado, a identificar. **Revisão técnica:** agente/sessão diferente da executora, com independência e fontes declaradas; veredito crítico, não aceite automático.
- **Autorização excepcional humana durante testes:** registrar ato, escopo, risco assumido e origem `MEDIADO`, sem presumir que uma exceção geral substitua controles técnicos ou normativos em tarefas posteriores.
- **Segurança:** executar com usuário não-root onde possível; env real não versionado e placeholders de exemplo sem segredo; sem publicação de PostgreSQL ao host; logs sanitizados; `down` sem `-v`; procedimentos destrutivos proibidos por padrão.
- **Reversão:** reverter código por commit/PR conforme plano aprovado; interromper serviços com `docker compose down` **somente na fase B autorizada**, sem apagar volumes, e preservar evidências.

## 4. Portas humanas e handoff

**Estado presente:** `TKC-AUT-0005 = PENDENTE`; fases A e B `PENDENTE`; executor, revisor e ambiente Docker ainda não nomeados; nenhum recurso de produto autorizado pela publicação deste texto.

**Próxima decisão humana possível:** autorizar **somente a fase A**, informando executor, escopo de paths acima, branch/PR, testes locais permitidos e formato de retorno; ou negar/modificar e publicar nova versão da proposta. A fase B exige decisão separada com host e comandos exatos. `TKC-AUT-0005 #TRUE` **não** pode ser interpretado automaticamente como autorização das duas fases.

Se houver decisão válida, antes de editar código o executor deve conferir `main`, regras vigentes, outras posses sobrepostas, estado do repositório e autorização; publicar claim novo `TKC-0005-C06` ou próximo ID livre e confirmar no remoto. Ao finalizar, devolver `TKC-RET-0005` por Git direto ou `MEDIADO`, manter `EM_REVISAO` até revisão e aceite independente; não atualizar M3-02 automaticamente.

## 5. Histórico e proveniência

1. `2026-11-24` — HUMAN-001 autorizou **somente AGT-001 preparar esta proposta** nos caminhos `IA/despachos/ordens/TKC-AUT-0005.md`, `IA/tarefas/TKC-0005.md` e `IA/tarefas/indice.md`, registro `MEDIADO`, sem nenhuma autorização operacional.
2. `TKC-0005-C05` — reivindicação documental publicada e confirmada remotamente no commit `ce21dfd5a733ecc1f7ec40c7e713ed2e55ba83bd` antes da criação deste arquivo.
3. `TKC-PAR-0005` — referência de viabilidade publicada em `a8a687cc17342b5561db67cc0a794d0b985134bc`; conclusões técnicas são parecer, não ensaios executados.
4. Este arquivo constitui **proposta PENDENTE**. Seu commit será identificável no Git após entrega; nenhum registro deste documento autentica decisão humana futura.

