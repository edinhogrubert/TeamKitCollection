# Contrato inicial da API

`GET /health` não requer corpo nem autenticação no laboratório, e **não** deve ser publicado na internet durante este corte.

- HTTP 200: `{"status":"ok","database":"up"}` após `SELECT 1`.
- HTTP 503: `{"status":"unhealthy","database":"down","error":"DB_UNAVAILABLE"}` quando configuração, conexão ou consulta falhar.

Timeout de conexão de 3 s e timeout SQL de 3000 ms. Não retornar DSN, senha, SQL, stack trace ou detalhes internos ao cliente. Verificação não modifica dados. O `200` prova somente que a API conseguiu completar a consulta naquele instante.
