"""Configuração por ambiente. Não registrar segredos em logs."""
import os
from dataclasses import dataclass


@dataclass(frozen=True)
class DatabaseConfig:
    host: str
    port: int
    dbname: str
    user: str
    password: str


def database_config() -> DatabaseConfig:
    """Leitura no momento de cada teste: mudanças de ambiente não ficam em cache."""
    return DatabaseConfig(
        host=os.environ.get("POSTGRES_HOST", "tkc-postgres16"),
        port=int(os.environ.get("POSTGRES_PORT", "5432")),
        dbname=os.environ.get("POSTGRES_DB", "teamkitcollection"),
        user=os.environ.get("POSTGRES_USER", "tkc_app"),
        password=os.environ["POSTGRES_PASSWORD"],
    )
