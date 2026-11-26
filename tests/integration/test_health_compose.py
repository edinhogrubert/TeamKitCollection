"""Teste de integração apenas na Fase B: depende de API já iniciada no laboratório.

Executar explicitamente com TKC_RUN_INTEGRATION=1 e TKC_HEALTH_URL (127.0.0.1).
Não cria, pára ou recria Docker, volumes, redes ou PostgreSQL.
"""
import os

import httpx
import pytest


@pytest.mark.skipif(os.getenv("TKC_RUN_INTEGRATION") != "1", reason="Fase B não habilitada")
def test_live_health_returns_200():
    url = os.getenv("TKC_HEALTH_URL", "http://127.0.0.1:8000/health")
    assert url == "http://127.0.0.1:8000/health", "URL restrita ao laboratório local"
    result = httpx.get(url, timeout=6)
    assert result.status_code == 200
    assert result.json() == {"status": "ok", "database": "up"}
