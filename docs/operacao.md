# Operação laboratório — Fase B da API

O menu scripts/infra/teamkit-lab.sh oferece opções 7 (diagnóstico), 8 (prepara rede privada e inicia somente o backend) e 9 (simulação de falha por desconexão temporária da rede tkc-lab-net e restauração).

O script trabalha exclusivamente na VM Ubuntu Container. PostgreSQL tkc-postgres16 e seu volume tkc-postgres16-data são preservados. A API deve publicar somente 127.0.0.1:8000; o PostgreSQL não publica 5432 no host. Não executar em produção.

Credenciais locais continuam em ~/.config/teamkitcollection/postgres16.env, sem impressão do conteúdo nem publicação no Git. A opção 9 exige a digitação de TESTAR; se a rede não puder ser restaurada automaticamente, o script emite comando de reconexão para o operador. Não executar se outros serviços dependerem da rede.

A imagem Python de build e as dependências permanecem em faixas, sem digest/lock; revisar antes de entrega reprodutível/produção/ARM64. Não usar exclusões de volumes, docker compose down -v nem firewall. C07 não realizou execução Docker nem testes HTTP na VM.
