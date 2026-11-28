---
agent_id: AGT-002
ai_model: Codex
intellectual_author: Codex / AGT-002
recorded_by: Codex / AGT-002
role: revisor e proponente documental
executor_proposed: AGT-003
reviewer_proposed: AGT-002
published_by: HUMAN-001
base_commit: 75479f1
source_task_id: TKC-0004-PILOTO-M3-02
---

# TKC-AUT-0004-PILOTO-M3-02 — Proposta de melhoria unitária

**estado:** `PENDENTE` — proposta documental; não autoriza execução
**task_id:** `TKC-0004-PILOTO-M3-02`
**escopo único:** melhoria em `tests/unit/test_health_unit.py`
**executor proposto:** `AGT-003`
**revisor independente proposto:** `AGT-002`

## Melhoria proposta

Adicionar um teste unitário que verifique explicitamente que respostas `503` do endpoint `/health` mantêm o contrato público estável quando `check_database()` falha com uma exceção não relacionada a segredo, preservando `status`, `database` e o código `DB_UNAVAILABLE`. O teste deve permanecer isolado, sem PostgreSQL, Docker, rede, VM ou alteração de código de produção.

## Critérios de aceite verificáveis

1. A alteração fica confinada a `tests/unit/test_health_unit.py`.
2. O novo teste usa mock de `src.backend.main.check_database` e não acessa recursos externos.
3. O teste confirma `HTTP 503` e o JSON público exatamente como definido pelo endpoint.
4. O teste confirma que a mensagem interna da exceção não aparece na resposta.
5. AGT-003 publica claim, commit, teste executado e retorno vinculados a esta ordem.
6. AGT-002 consulta diretamente o Git e produz revisão independente; entrega não equivale a aceite.
7. Uma sessão sucessora recebe apenas a referência da tarefa e os commits publicados, identifica escopo, estado e próxima ação sem depender deste chat.
8. Falhas, divergências ou arquivos fora do escopo permanecem registradas e bloqueiam a promoção.

## Limites e não autorização

Esta proposta não autoriza execução, alteração de código de produção, Docker, PostgreSQL, VM, infraestrutura, dependências, configuração ou M3-02. A autorização operacional deverá ser emitida separadamente, após conferência de HUMAN-001, e a reivindicação deverá ser publicada antes da execução conforme COM-001 v0.2.0.

## Pacote de handoff

- Fonte da tarefa: `IA/tarefas/TKC-0004.md`
- Ordem proposta: este arquivo
- Arquivo permitido para eventual execução: `tests/unit/test_health_unit.py`
- Base: `75479f1`
- Próxima ação: HUMAN-001 decidir se autoriza AGT-003 a executar o pacote
