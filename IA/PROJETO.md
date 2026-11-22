# PROJETO — Controle de Evolução

**Projeto:** TeamKitCollection  
**Identificação:** M1-TEST  
**Estado:** EM_ANDAMENTO  
**Próxima etapa:** M1-TEST — Aplicar ensaio hipotético GOV-T02, SEC-T03 e GOV-T04 ao Grok, avaliar as respostas e persistir evidências; os demais testes seguem pendentes

---

## Controle das etapas

| Identificação | Etapa | Estado |
|---|---|---|
| M0-01 | Definir a visão geral do projeto | CONCLUÍDO |
| M0-02 | Elaborar `README.md` | CONCLUÍDO |
| M0-03 | Elaborar `AGENTS.md` | CONCLUÍDO |
| M0-04 | Definir a separação entre `IA/` e `docs/` | CONCLUÍDO |
| M0-05 | Elaborar `IA/PLANO_EVOLUCAO.md` | CONCLUÍDO |
| M0-06 | Criar `IA/PROJETO.md` | CONCLUÍDO |
| M0-07 | Atualizar `AGENTS.md` com a estrutura definitiva | CONCLUÍDO |
| M1-01 | Documentar GOV-001 a GOV-005 e definir cenários de aceitação | CONCLUÍDO |
| M1-TEST | Estático 10/10 PASS; 2/17 cenários com resposta relatada, 0/17 com PASS operacional | EM_ANDAMENTO |
| M1-02 | Documentar SEC-001 a SEC-010 e especificar testes de segurança | CONCLUÍDO |
| M2-01 | Criar `IA/regras/confiabilidade.md` | PENDENTE |
| M3-01 | Criar `IA/regras/comunicacao.md` | PENDENTE |
| M4-01 | Criar os contratos em `IA/papeis/` | PENDENTE |
| M5-01 | Implementar o protocolo de tarefas e handoff | PENDENTE |
| M6-01 | Criar verificações automatizadas | PENDENTE |
| M7-01 | Validar o método durante desenvolvimento e operação | PENDENTE |
| M8-01 | Testar a portabilidade entre projetos | PENDENTE |
| M9-01 | Avaliar os resultados e aperfeiçoar o método | PENDENTE |

## Estados permitidos

- `PENDENTE` — Ainda não iniciado.
- `EM_ANDAMENTO` — Em execução.
- `CONCLUÍDO` — Finalizado com evidências.
- `BLOQUEADO` — Impedimento identificado.
- `CANCELADO` — Não será executado.

## Regra de atualização

Ao finalizar uma atividade, o agente deverá:

1. Atualizar seu estado.
2. Registrar a evidência de conclusão ou a referência correspondente.
3. Atualizar a identificação e a próxima etapa no início deste arquivo.
4. Manter o histórico das etapas anteriores.

Uma etapa somente poderá ser marcada como `CONCLUÍDO` quando sua entrega estiver verificada no repositório.

---

**Última verificação do estado no Git:** 2026-11-22 — `README.md`, `AGENTS.md`, `IA/PLANO_EVOLUCAO.md` e `IA/PROJETO.md` existem em `main`. Contratos GOV-001 a GOV-005 em `IA/regras/constituicao.md` publicados e relidos na `main` (commit `c39a37a36aee9944f610ac0b13478dfead3458a7`); GOV-T01 a GOV-T07 definidos, ainda não executados. O marco M1 continua aberto até segurança e validação prática. `docs/` e código da aplicação ainda não existem. O script de VM foi preservado em `scripts/infra/create-vm-virtualbox.sh`, sem execução nem testes.

**M1-TEST — Verificação em andamento:** relatório `IA/validacao/M1_TEST_RELATORIO.md` criado e relido na `main`, commit `a6b76a239cbcfe78bbed297aa95dd1af24ee10db`. Dez verificações estáticas de documentos: 10/10 PASS; cenários comportamentais: 0/17 executados. A inspeção estática não equivale à prova de obediência de agentes; falta avaliação por outra sessão/IA. Não declarar M1 concluído operacionalmente.

**M1-02 — Evidência atual:** `IA/regras/seguranca.md` publicado e relido na `main` no commit `5144b2746ffdc3c7a13fa7dd80978413352cc850`, contendo SEC-001 a SEC-010 e SEC-T01 a SEC-T10. O arquivo documenta segurança do método, não segurança do produto. Nenhum dos 10 cenários SEC ou 7 cenários GOV foi executado. A etapa documental M1-02 está concluída, mas o marco M1 ainda não foi validado operacionalmente.

**Atenção:** o script existente de VM contém exclusão automática de VM com nome coincidente e tratamento potencialmente incorreto de imagem `.img`; requer revisão e aprovação específica antes de ser executado.

**Atribuição inicial:** `HUMAN-001` exerce a porta decisória `TRUE/FALSE`; `AGT-001` é Coordenador Técnico e Arquiteto do Método, atualmente ChatGPT (GPT-6), substituível por outra IA. Contrato `GOV-001` documentado; nenhuma implementação de produto inferida.

## Registro de observação externa — Grok

- **Origem:** resposta textual encaminhada por HUMAN-001; Grok não possui acesso de escrita ao Git e dependerá de ponte humana para receber instruções.
- **Cenários:** GOV-T01 e SEC-T02 — resposta declarada compatível com as regras; evidência classificada como `RELATADO`, não como teste operacional integral.
- **Registro:** `IA/validacao/M1_TEST_RELATORIO.md`, seção 6.
- **Limitação:** AGT-001 não presenciou a sessão original e não realizou auditoria independente.
- **Próximo ensaio:** hipóteses GOV-T02, SEC-T03 e GOV-T04, sem acesso/modificação de ambiente.

## Registro de execução M1-TEST

- **Autorização humana:** continuar para a próxima etapa do plano M1-TEST.
- **Escopo realizado:** leitura de documentos oficiais e inspeção estática; nenhum teste com segunda IA foi executado.
- **Resultado:** 10/10 checagens estáticas PASS, registradas em `IA/validacao/M1_TEST_RELATORIO.md`.
- **Evidência:** commit `a6b76a239cbcfe78bbed297aa95dd1af24ee10db`.
- **Pendência:** GOV-T01–GOV-T07 e SEC-T01–SEC-T10; validação independente.
- **Próximo passo:** executar um lote seguro de testes comportamentais de leitura, documentando entradas, saídas e critérios sem segredos reais nem ações destrutivas.

## Registro da decisão M1-02

- **Proposta:** estabelecer regras de segurança da atuação de IAs, separadas de `docs/seguranca.md`.
- **Decisão humana:** `TRUE` — autorização para executar o próximo passo documental.
- **Execução:** criado `IA/regras/seguranca.md`, conferido por releitura do GitHub; `AGENTS.md` já referenciava este caminho e não exigiu alteração.
- **Evidência:** commit `5144b2746ffdc3c7a13fa7dd80978413352cc850`.
- **Não realizado:** testes comportamentais, execução de scripts, deploy, mudanças de infraestrutura ou código.
- **Próxima ação:** preparar e executar testes controlados GOV/SEC com evidências, incluindo revisão independente.

## Registro da decisão M1-01

- **Proposta:** completar os contratos GOV-002 a GOV-005, preservando GOV-001, e registrar os testes necessários.
- **Decisão humana:** `TRUE` — autorização expressa para criar, atualizar o controle e informar testes.
- **Execução:** documento publicado e relido na `main`; nenhum teste comportamental multiagente executado.
- **Evidência documental:** commit `c39a37a36aee9944f610ac0b13478dfead3458a7` e conteúdo `IA/regras/constituicao.md`.
- **Pendente:** GOV-T01 a GOV-T07; revisão independente e `IA/regras/seguranca.md`.

**Evidências gerais:** histórico de commits da `main` e arquivos citados; documentação concluída significa arquivo existente e verificado no Git, não validação do comportamento de IAs ou do aplicativo.
