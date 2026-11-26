# Primeiro corte executável — laboratório

Fase A de TKC-AUT-0005: API Python 3.12, FastAPI, Psycopg 3 e PostgreSQL 16.16 existente na VM Ubuntu Container. O endpoint `GET /health` realiza `SELECT 1` no banco real. Sem modelos de domínio, gateway ou réplica neste corte. Projeto multiagente/etapas M3-02 seguem independentes.

A API roda futuramente em container independente; PostgreSQL `tkc-postgres16` já existe com volume `tkc-postgres16-data`. A rede privada Docker de usuário `tkc-lab-net` será conectada ao banco na Fase B, mediante autorização específica. Nenhum banco ou volume é gerenciado pelo Compose da API. A arquitetura foi projetada para o laboratório local amd64 e exige revisão de imagens e dependências antes de portar a Oracle arm64.
