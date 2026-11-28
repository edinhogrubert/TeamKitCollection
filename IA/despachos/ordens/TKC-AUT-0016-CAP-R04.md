# TKC-AUT-0016-CAP-R04 — Ensaio humano com Docker local existente

task_id: TKC-0016
order_id: TKC-0016-O05
revision: 4
supersedes: R03 @9f286f9590195192d977229b8a4fac7394e10c06, encerrada BLOQUEADA por isolamento indisponível
status / authorization_state: PENDENTE — execução humana exige nova decisão específica
executor: HUMAN-001 — VM local existente
coordinator / author / recorded_by: AGT-001 III (ChatGPT GPT-6.2 AUTODECLARADO)
reviewer_proposed: AGT-002 — revisão distinta, autorização própria
base_commit: 5e4824ebb823d97ddc58c896389efcaa240e54a4
script: scripts/qa/tkc-0016-cap-r04.sh @6d9b0a0051b179e3b1e8ea6b528dbfafd39e736c
script_blob: 2b72d12390fee961910415e4c84fb386c84f4215
test_revision: 706cda089731263ee4f0b5e48e2bfe06047f57ef
test_blob: a165e47889ddcc99c026a2562914336f9077738a
cost_limit: R$ 0,00 inclusive risco de cobrança futura; dúvida implica parada antes do download
risk: L2, Docker local descartável, sem alteração de produto/contêineres existentes
scope: download HTTPS versionado do script, verificação de hash e sintaxe, leitura pública GitHub, uma cópia temporária local e um contêiner efêmero de imagem local, envio do resumo
remote_write_scope: nenhum nesta ordem; registro da evidência posterior requer autorização explícita
decision_ref: TKC-AUT-0016-CAP-R04 @SHA #TRUE
provenance: resultado e decisão humanos MEDIADO; publicação VERIFICADA; teste não executado pela IA
dependencies: C06 entregue, nenhuma posse ativa; HUMAN-001 confirma daemon na VM local existente e custo zero
stop_condition: qualquer dúvida sobre custos, daemon não local, acesso, imagem, integridade, dependências, isolamento ou falha; não corrigir nem repetir automaticamente

## Procedimento
Executar na VM local existente, via curl HTTPS do script fixado no commit acima, em arquivo temporário; exigir download não vazio, git hash-object igual ao blob acima e bash -n antes de executar. Argumento --custo-zero-local-confirmado expressa confirmação humana da ausência de cobrança e de que o daemon no socket Unix é efetivamente local, não proxy de serviço remoto. O script não consegue auditar faturamento ou topologia física. Se houver dúvida, não baixar nem executar.

O script aceita exclusivamente socket Unix /var/run/docker.sock, ignora contextos remotos e configurações/credenciais de usuário; tenta acesso direto e, apenas se necessário, sudo -n para comandos Docker já permitidos (padrão do laboratório), sem pedir senha nem alterar permissões do host. Sem acesso, parar. Inspeciona a imagem local teamkitcollection/backend:lab (nome existente no Compose; dependências pytest, FastAPI, httpx e psycopg previstas em src/backend/requirements.txt), fixa seu ID e rejeita imagens com volumes declarados. Disponibilidade real ainda desconhecida. Não baixar ou construir imagem. Obter por leitura pública GitHub a revisão de teste fixa em diretório descartável sem credenciais, verificar SHA, blob e estado limpo; permissões de leitura somente na cópia temporária para o UID 10001. Nenhuma mudança no checkout existente.

Executar um único contêiner temporário com --rm --pull=never --network none, root filesystem e checkout montados somente leitura, UID 10001, capabilities removidas, no-new-privileges, limites de CPU/memória/processos, tmpfs /tmp, healthcheck e logging persistente desabilitados, sem portas, sem volumes de dados, sem env-file, sem credenciais reais. Não usar Docker Compose, docker exec, restart, stop ou alterações dos contêineres existentes; não acessar PostgreSQL. Entrypoint explícito com ambiente mínimo; verificar dependências sem instalar e, se disponíveis, executar o teste original: python -m pytest -q -p no:cacheprovider --color=no --tb=no tests/unit/test_health_unit.py. Resultado esperado 3 passed, PYTEST_RC=0, DOCKER_RUN_RC=0 e cópia limpa. O script apresenta somente marcadores, versões e contagens permitidas; sem logs brutos. Remove cópia temporária ao sair; Docker --rm remove contêiner ao terminar normalmente. Se houver interrupção anormal, informar sem remover recursos existentes por iniciativa própria.

## Retorno e limites
HUMAN-001 envia apenas resumo terminal. Registrar MEDIADO, distinguir falha do ambiente de falha do teste, não atribuir capacidade de pytest à AGT-004. Nenhum patch liberado, nenhuma homologação M3-02. Se bloqueado, não emitir novas revisões repetitivas por padrão; coordenação avalia viabilidade e alternativa de trabalho sem reduzir controles. Custo zero prevalece sobre tudo: sem recursos remotos, pulls, builds, instalação, mudanças de configuração/permissões do host, credenciais, serviços pagos ou risco de cobrança. Nenhum teste funcional ou revisão independente do script pela coordenação; bash -n é pré-requisito na VM, não validação funcional. Métricas NÃO MEDIDO.
