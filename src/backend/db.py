"""Verificação explícita de conectividade com PostgreSQL, sem mudanças no esquema."""
import psycopg

from src.backend.config import database_config


def check_database() -> None:
    cfg = database_config()
    with psycopg.connect(
        host=cfg.host,
        port=cfg.port,
        dbname=cfg.dbname,
        user=cfg.user,
        password=cfg.password,
        connect_timeout=3,
        options="-c statement_timeout=3000",
    ) as conn:
        with conn.cursor() as cursor:
            cursor.execute("SELECT 1")
            if cursor.fetchone() != (1,):
                raise RuntimeError("Resultado inesperado do teste SQL")
