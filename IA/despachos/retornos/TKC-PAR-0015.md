---
agent_id: AGT-002
ai_model: Codex
intellectual_author: AGT-002 / Codex
recorded_by: AGT-002 / Codex
role: revisor independente
published_by: HUMAN-001
source_commit_sha: 1d042eb
base_commit: d8186b5
claim_id: TKC-0015-C02
---

# TKC-PAR-0015 — Parecer independente sobre o fortalecimento operacional

**decisão técnica:** `APROVAR COM RESSALVAS` a proposta documental; não autoriza execução, não altera M3-02 e não substitui uma AUT específica.

## Fontes e limites

Consulta direta na `main`: `AGENTS.md`, `IA/PROJETO.md`, `IA/regras/comunicacao.md` (COM-001 v0.2.0), `IA/despachos/README.md` (COM-002), `IA/regras/seguranca.md`, `IA/tarefas/TKC-0004.md`, `IA/tarefas/TKC-0015.md`, `IA/tarefas/indice.md`, `IA/despachos/ordens/TKC-REQ-0015.md` e `IA/despachos/retornos/TKC-RET-0004-PILOTO-M3-02.md`. Base inicialmente solicitada: `3719539`; estado revalidado antes da revisão: `d8186b5`, com reivindicação C02 confirmada em `1d042eb`.

Não foram executados testes, código, Docker, VM, configuração GitHub ou operações externas. A revisão é L0/L1 documental.

## Achados A1–A5 — governança

- **A1 — atendido com ressalva:** a proposta exige ID, claim, papel, capacidades, caminhos, base e critérios. A autorização e a capacidade devem continuar sendo confirmadas por tentativa, não herdadas do C01.
- **A2 — atendido:** vincular decisões a SHA resolvível e não antecipar o hash do próprio commit. Manter proveniência `MEDIADO` quando a decisão vier por transporte humano.
- **A3 — atendido:** separa leitura, escrita e testes; ensaio de escrita ou branch exige autorização própria. Atribuição de modelo deve ser declarada, não presumida.
- **A4 — atendido:** perda de publicação/posse bloqueia a tentativa; não usar execução local como substituto de evidência remota.
- **A5 — atendido com ressalva:** o handoff por referência curta é adequado, mas `PUBLICADO` não prova `RECEBIDO`; a sessão sucessora deve consultar diretamente o Git.

## Achados B1–B3 — verificação técnica

- **B1 — necessário:** comparação direta de diff contra caminhos autorizados, preservando eventos históricos; não aplicar regra cega de zero exclusões a estado e índice.
- **B2 — necessário:** sem CI, uma segunda sessão deve comparar base/HEAD e revisar exemplos positivos e negativos antes do aceite. Isso é controle documental, não bloqueio técnico implementado.
- **B3 — atendido:** workflow, permissões, proteção de branch, credenciais, infraestrutura e custo permanecem fora do escopo; qualquer exceção exige decisão própria.

## Achados C1–C4 — validação e retomada

- **C1 — adequado:** novo piloto deve ter ID próprio, executor e revisor distintos, capacidade comprovada, ordem versionada, caminhos específicos e comando reproduzível.
- **C2 — adequado com condição:** claim remoto deve preceder qualquer alteração; o revisor deve consultar diretamente o diff, histórico e evidências, sem transformar relato em verificação.
- **C3 — adequado:** registrar `NÃO MEDIDO` quando não houver medição; o teto de esforço é estimativa, não prazo nem autorização para ampliar escopo.
- **C4 — obrigatório:** M3-02 continua `PENDENTE`; o incidente do piloto anterior não deve ser reintegrado nem apagado, e uma nova tentativa deve ser separada.

## Pacote mínimo recomendado para retomada

1. Criar uma AUT própria para o piloto, com versão-base, executor, revisor, arquivos, comando, limites e critérios.
2. Usar a fatia unitária de `tests/unit/test_health_unit.py` ou outro pacote igualmente isolado; não incluir Docker/VM sem autorização separada.
3. Publicar claim remoto antes da primeira alteração e verificar que a `main` prevaleceu.
4. Exigir retorno com diff, testes efetivamente executados, limitações, custo/tempo medidos ou `NÃO MEDIDO` e handoff por referências.
5. Fazer a revisão independente em sessão sucessora; registrar falha ou divergência sem reescrever eventos.

## Conclusão

A proposta TKC-0015 é coerente e fornece o mínimo necessário para preparar um piloto, com ressalvas sobre capacidade real, confirmação remota e independência efetiva. O incidente `TKC-RET-0004-PILOTO-M3-02.md` confirma que publicação ausente, escopo divergente, claim tardio e evidência truncada devem bloquear integração. Nenhuma evidência desta revisão homologa M3-02, que permanece `PENDENTE`.
