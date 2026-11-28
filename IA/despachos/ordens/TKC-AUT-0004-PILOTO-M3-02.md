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

Substituir a adição de um caso único, redundante com `test_health_unavailable_does_not_leak_secret`, por cobertura parametrizada de classes distintas de falha em `check_database()` (por exemplo, `Exception` genérica e `OSError`). Para cada caso, o teste deve verificar o mesmo JSON público estável (`status`, `database` e `DB_UNAVAILABLE`), a ausência da mensagem interna na resposta e chamada única ao mock. A cobertura deve permanecer isolada, sem PostgreSQL, Docker, rede, VM ou alteração de código de produção.

## Critérios de aceite verificáveis

1. A alteração fica confinada a `tests/unit/test_health_unit.py`.
2. O novo teste usa mock de `src.backend.main.check_database` e não acessa recursos externos.
3. A parametrização cobre pelo menos duas classes distintas de falha sem duplicar o teste 503 já existente.
4. Cada caso confirma `HTTP 503`, o JSON público exatamente como definido pelo endpoint e ausência da mensagem interna na resposta.
5. Cada caso confirma `check_database` chamado exatamente uma vez.
6. AGT-003 publica claim, commit, teste executado e retorno vinculados a esta ordem.
7. AGT-002 consulta diretamente o Git e produz revisão independente; entrega não equivale a aceite.
8. Uma sessão sucessora recebe apenas a referência da tarefa e os commits publicados, identifica escopo, estado e próxima ação sem depender deste chat.
9. Falhas, divergências ou arquivos fora do escopo permanecem registradas e bloqueiam a promoção.

## Limites e não autorização

Esta proposta não autoriza execução, alteração de código de produção, Docker, PostgreSQL, VM, infraestrutura, dependências, configuração ou M3-02. A autorização operacional deverá ser emitida separadamente, após conferência de HUMAN-001, e a reivindicação deverá ser publicada antes da execução conforme COM-001 v0.2.0.

## Pacote de handoff

- Fonte da tarefa: `IA/tarefas/TKC-0004.md`
- Ordem proposta: este arquivo
- Arquivo permitido para eventual execução: `tests/unit/test_health_unit.py`
- Base: `75479f1`
- Próxima ação: HUMAN-001 decidir se autoriza AGT-003 a executar o pacote
