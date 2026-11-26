"""API HTTP mínima, deliberadamente sem endpoints de dados de negócio."""
from fastapi import FastAPI
from fastapi.responses import JSONResponse

from src.backend.db import check_database

app = FastAPI(title="TeamKitCollection", version="0.1.0")


@app.get("/health", include_in_schema=True)
def health():
    try:
        check_database()
    except Exception:
        # Não emitir senha, DSN, SQL nem detalhes internos para o cliente.
        return JSONResponse(
            status_code=503,
            content={"status": "unhealthy", "database": "down", "error": "DB_UNAVAILABLE"},
        )
    return {"status": "ok", "database": "up"}
