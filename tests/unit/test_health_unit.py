"""Unidade: não consulta PostgreSQL, Docker ou rede externa."""
from unittest.mock import patch

from fastapi.testclient import TestClient

from src.backend.main import app

client = TestClient(app)


def test_health_ok():
    with patch("src.backend.main.check_database") as mock_check:
        response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "ok", "database": "up"}
    mock_check.assert_called_once()


def test_health_unavailable_does_not_leak_secret():
    secret = "tkc-secret-value-never-echo"
    with patch("src.backend.main.check_database", side_effect=Exception(secret)):
        response = client.get("/health")
    assert response.status_code == 503
    assert response.json() == {
        "status": "unhealthy", "database": "down", "error": "DB_UNAVAILABLE"
    }
    assert secret not in response.text


def test_health_recovery_without_restart():
    with patch("src.backend.main.check_database", side_effect=[None, OSError("falha"), None]):
        assert client.get("/health").status_code == 200
        assert client.get("/health").status_code == 503
        assert client.get("/health").status_code == 200
