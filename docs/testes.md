# Plano e evidências — fase A

Teste unitário proposto (exige ambiente Python com dependências e permissão de executar): `python -m pytest tests/unit -q`. Deve verificar 200, 503, ausência de segredo e recuperação em chamadas consecutivas. Integração: `TKC_RUN_INTEGRATION=1 python -m pytest tests/integration -q` somente na fase B com API ativa em 127.0.0.1:8000.

Na Fase B, verificar `docker compose config --quiet` sem expor env; confirmar `200`, simular indisponibilidade de banco controladamente e verificar `503` com timeout e retorno a `200` após recuperação; exigir autorização operacional específica para parar ou reiniciar PostgreSQL. Persistência no container existente já foi relatada por HUMAN-001 em TKC-0008, não é teste executado deste backend.

**Estado na publicação da Fase A:** testes unitários e de integração NÃO EXECUTADOS; nenhum container novo criado pelo agente. A presença de testes no Git não constitui aprovação.
