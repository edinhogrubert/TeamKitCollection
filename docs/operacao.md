# Operação do laboratório — somente proposta da Fase B

1. Confirmar a autorização específica do laboratório API e a revisão do script orquestrador. Não executar automaticamente a partir desta documentação.
2. Verificar PostgreSQL `tkc-postgres16`, seu volume e ausência de publicação da porta 5432.
3. Preparar a rede Docker `tkc-lab-net` e conectar o banco existente **sem** recriá-lo (fase B).
4. Injetar credenciais via `TKC_PG_ENV_FILE` apontando para o arquivo local de modo 0600; nunca versionar credenciais nem imprimi-las.
5. Validar Compose e iniciar **somente backend**, vinculado à interface `127.0.0.1:8000`. Não abrir 5432, executar migrations, destruir volumes, ou alterar firewall.
6. Testar `GET /health`, falha do banco e recuperação; registrar evidências e reverter somente recursos da API conforme autorização futura.

O menu `scripts/infra/teamkit-lab.sh` ainda não contém a fase da API. Sua integração está fora do escopo de escrita da Fase A e exige autorização separada.
