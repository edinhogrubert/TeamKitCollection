# TKC-REQ-0009 — Primeiro handoff para DevOps AGT-003

**order_id:** `TKC-REQ-0009`
**task_id:** `TKC-0009`
**sender:** AGT-001 — liderança técnica
**recipient:** AGT-003 — especialista DevOps/SRE PROPOSTO, ainda não recebeu
**request_type:** Análise de prontidão, riscos e plano de execução L0/L1, **não execução**
**status:** DISPONIVEL_PARA_ENTREGA — encaminhamento manual por HUMAN-001
**authorization:** HUMAN-001 pediu delegar a responsabilidade DevOps; só a análise e proposta estão autorizadas neste despacho. A autorização anterior para Fase B do AGT-001/operador **não é transferida automaticamente** a AGT-003.
**base_commit:** `0a66b5958e1526a11ad92dacaae9443ef96b8694` (revalidar main no recebimento)
**task_record:** `IA/tarefas/TKC-0009.md`
**rules:** `AGENTS.md`, `IA/regras/comunicacao.md` (COM-001) e `IA/despachos/README.md` (COM-002), e seções relevantes de segurança/autoridade; conferir revisão atual
**return_path:** `IA/despachos/retornos/TKC-PAR-0009.md` somente se escrita Git autorizada e claim próprio confirmado; caso contrário, retorno mediado a HUMAN-001

## Papel DevOps e primeiro objetivo

Você é o especialista responsável por Docker, infraestrutura Ubuntu/VM, PostgreSQL, redes e scripts de implantação, diagnósticos, observabilidade, incidentes e estratégia de recuperação. Não administra o código de regras de negócio nem aprova sua própria implementação.

**Sua primeira tarefa é revisar o laboratório e a Fase B preparados, sem executar comandos ou editar código:**
1. Verifique em main os scripts `scripts/infra/teamkit-lab.sh` e `scripts/infra/backend-lab.sh`, o Compose `infra/docker/docker-compose.lab.yml`, `infra/docker/Dockerfile.backend` e os registros `TKC-0005`, `TKC-0007`, `TKC-0008`.
2. Procure falhas reais que possam surgir nas opções **7 (check), 8 (up) e 9 (fault/restore)** antes de pedir ao operador que as execute. Em especial: retorno de erros e traps, Docker privileges, uso seguro de secrets, conexões entre redes, comportamento da API em falha, idempotência e não recriação de PostgreSQL.
3. Proponha a menor correção possível, scripts previsíveis e status/relatórios automáticos, preservando `tkc-postgres16` e volume `tkc-postgres16-data`, sem publicar 5432. Indique quais testes estáticos são possíveis sem Docker e quais exigem operação na VM.
4. Faça uma lista curta de bloqueadores graves, roteiro de teste e rollback seguro **sem exclusões**. Distinga verificado por inspeção, relatado pelo humano e não executado.
5. **Não execute** a opção 8 ou 9, não inicie containers, não altere rede, não use credenciais, não crie recursos em Oracle ou VM externa e não altere repositório além de eventual retorno autorizado separadamente.

## Condições e limites

- Laboratório real: VM Ubuntu 24.04.5, Docker 29.10.1, Compose v5.8.0, PostgreSQL 16.16 existente sem porta publicada; persistência após restart relatada e registrada como MEDIADO em TKC-0008.
- Repo: `edinhogrubert/TeamKitCollection`, branch `main`. Último pacote do backend/menu em `abf054f83d36ff15afdf4b44f72aa02bb5d15611`. Banco não deve ser recriado.
- R$ 0,00 de custos incrementais, sem manipulação de credenciais ou dados reais, sem qualquer reset ou exclusão.
- O recebimento da ordem não configura autorização L2/L3: antes de qualquer ajuste de código, solicitar/validar autorização de escopo e registrar posse conforme COM-001.

## Entrega solicitada

Parecer conciso `TKC-PAR-0009` com: `APTO` / `APTO_COM_CONDICOES` / `BLOQUEADO`, achados por severidade, roteiro da primeira execução segura, arquivos a alterar e testes a realizar; mencionar fontes consultadas e limitações.

Se escrita no Git estiver realmente disponível **e especificamente autorizada**, publicar retorno após reivindicação válida; encerrar com `TKC-PAR-0009 PUBLICADA NO GIT — commit: <SHA>`. Sem escrita/autorização, fornecer o conteúdo na conversa e encerrar com `TKC-PAR-0009 PRONTA — SEM ESCRITA GIT. LEVE ESTA RESPOSTA A AGT-001`.

**A publicação deste despacho não significa recebimento.** HUMAN-001 entrega a referência curta ao especialista em outra sessão, conforme COM-002.
