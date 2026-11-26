# Infraestrutura do primeiro corte

**Fase A somente — código/documentação, nenhum Docker executado.** O Compose em `infra/docker/docker-compose.lab.yml` sobe futuramente apenas `backend`. Ele depende da rede externa `tkc-lab-net` que **ainda não foi criada** e da conexão do container existente `tkc-postgres16` a essa rede; ambas são operações da Fase B. Sem `ports:` do PostgreSQL. API restrita a `127.0.0.1:8000` na VM.

Para a Fase B, verificar previamente o caminho de credenciais local `~/.config/teamkitcollection/postgres16.env` e exportar somente o caminho em `TKC_PG_ENV_FILE`; **não** imprimir, copiar ao Git, ou inserir o segredo em logs de `docker compose config` (usar `config --quiet`). `infra/docker/.env.lab.example` não contém credenciais. Nunca usar `docker compose down -v` ou `docker volume rm`.

**Riscos pendentes da Fase B:** pin de digest da imagem Python, lock/hash de dependências, revisão de CVEs e licença, conexão à rede Docker, idempotência do script orquestrador, teste de perda de conexão, custo adicional zero. Nenhum comando operacional autorizado nesta fase.
