# TKC-AUT-0016-VAL — Validação humana do patch unitário em Docker local existente

task_id: TKC-0016
order_id: TKC-0016-O09
based_on: TKC-AUT-0016-CAP-R05 @ba2197ff0414d73928fb76c272cc2987371919e7 (aprovada em C13 @c4eb464 e executada por HUMAN-001 em C14 @4f57708)
status / authorization_state: PENDENTE — revisão independente AGT-002 e nova decisão humana #TRUE obrigatórias antes da execução
executor: HUMAN-001 — VM local existente
author / recorded_by: AGT-003 — DevOps/SRE (gemini-4-hydrogen, AI Studio)
preparation_auth_ref: AGT-003 — TKC-0016-VAL @af46504 #TRUE (AGT-001 III)
reviewer_proposed: AGT-002 — revisão independente obrigatória antes da execução humana
base_commit: af465042b0a15ff031e93dd4396a473063758410
script: scripts/qa/tkc-0016-val.sh @5838f69b76c02fc136ba6cfc0ddbc6f9ee54c6f6
script_blob: 597258394088fa406471bdfd8550dce9a426365d
test_revision: 7b2330a574987492d233a37a1a1cbeb6a4b38c2f
test_blob: 4718b2a7a35e29024ed095bea1ef76451974d729
cost_limit: R$ 0,00 inclusive risco de cobrança futura; dúvida implica parada antes do download
risk: L2 — Docker local descartável com imagem existente, sem alteração de produto, host ou contêineres existentes
scope: download HTTPS versionado do script, verificação de hash e sintaxe com preservação do código de retorno via trap em subshell, leitura pública GitHub, uma cópia temporária local, sudo -v controlado com env -i apenas para socket Docker local e um contêiner efêmero de imagem local com limite de duração, envio do resumo
remote_write_scope: nenhum nesta ordem; registro da evidência posterior requer autorização explícita
decision_ref: TKC-AUT-0016-VAL @SHA #TRUE (após revisão de AGT-002)
provenance: resultado e decisão humanos MEDIADO; publicação do script VERIFICADA; execução na VM NÃO_EXECUTADA
dependencies: C13 (65f58f9/c4eb464), C14 (4f57708), C15 (7b2330a574987492d233a37a1a1cbeb6a4b38c2f/af465042b0a15ff031e93dd4396a473063758410); revisão AGT-002 concluída; HUMAN-001 confirma daemon na VM local existente e custo zero
stop_condition: qualquer dúvida sobre custos, daemon não local, execução como root, falha de sudo -v ou sudo_env, erro ao consultar docker ps, imagem ausente ou com volumes, timeout (60s), integridade, dependências, isolamento ou falha; não corrigir nem repetir automaticamente

## Procedimento

Executar na VM local existente (como usuário normal, nunca como root), somente após revisão de AGT-002 e decisão `#TRUE` de HUMAN-001, via download HTTPS do script fixado no commit acima (em subshell com `trap` para remover `"$tmp"` preservando o código de retorno real de qualquer etapa):

```bash
(tmp=$(mktemp) && trap 'rc=$?; rm -f -- "$tmp"; exit "$rc"' EXIT && curl --fail --silent --show-error --location --proto '=https' --tlsv1.2 "https://raw.githubusercontent.com/edinhogrubert/TeamKitCollection/5838f69b76c02fc136ba6cfc0ddbc6f9ee54c6f6/scripts/qa/tkc-0016-val.sh" -o "$tmp" && [[ -s "$tmp" ]] && [[ "$(git hash-object "$tmp")" == "597258394088fa406471bdfd8550dce9a426365d" ]] && bash -n "$tmp" && bash "$tmp" --custo-zero-local-confirmado)
```

O argumento `--custo-zero-local-confirmado` expressa confirmação humana da ausência de cobrança e de que o daemon em `/var/run/docker.sock` é efetivamente local. Se houver dúvida, não baixar nem executar.

O script preserva integralmente os controles aprovados na R05: limpa `DOCKER_*`, proxies, `LD_*` e `SUDO_ASKPASS`; aceita exclusivamente o socket Unix `/var/run/docker.sock` (ignorando contextos/credenciais Docker do usuário); exige `EUID != 0`; tenta acesso direto sanitizado (`direto`) e, apenas se indisponível, executa `sudo -v` interativo controlado (sem alterar grupo `docker`, `sudoers` ou permissões do host) seguido exclusivamente pelo caminho sanitizado `sudo_env` (`env -i ... sudo -- /usr/bin/env -i ... "$DOCKER"`), sem qualquer fallback não sanitizado.

Inspeciona a imagem local `teamkitcollection/backend:lab`, fixa seu ID por `sha256` e rejeita imagens com volumes declarados. **Não baixar (`--pull=never`) nem construir imagem.** Obtém por leitura pública GitHub a revisão `7b2330a574987492d233a37a1a1cbeb6a4b38c2f`, confirma `TEST_BLOB` (`4718b2a7a35e29024ed095bea1ef76451974d729`) e estado limpo, rejeitando arquivos de configuração `pytest` extras.

Executa um único contêiner temporário nomeado (`--name tkc-val-$$`) sob `timeout --signal=TERM --kill-after=10s 60s`, com `--rm --pull=never --network none --read-only --cap-drop ALL --security-opt no-new-privileges:true --user 10001:10001 --pids-limit 128 --memory 512m --cpus 1 --no-healthcheck --log-driver none --tmpfs /tmp:rw,nosuid,nodev,noexec,size=64m,mode=1777`, montagem `--mount ...readonly`, entrypoint explícito com ambiente mínimo, executando:

`python -m pytest -q -p no:cacheprovider --color=no --tb=no tests/unit/test_health_unit.py`

Após a execução (ou em timeout/interrupção/falha), o script consulta o daemon sem ignorar erros de `docker ps -a`, executa `docker stop -t 5` e `docker rm -f` se houver contêiner residual, reconsulta `docker ps -a` sem ignorar falhas, remove o diretório temporário em `cleanup()` e preserva o código de retorno real do comando após a limpeza.

Resultado esperado: `4 passed`, `PYTEST_RC=0`, `DOCKER_RUN_RC=0`, `ESTADO_ANTES=LIMPO`, `ESTADO_DEPOIS=LIMPO`. Saída restrita a versões, marcadores e contagens permitidas, sem logs brutos.

## Retorno e limites

HUMAN-001 envia apenas o resumo terminal (`VAL=ENTREGUE` ou `VAL=BLOQUEADA`). Registrar como `MEDIADO`, distinguir falha de ambiente de falha de teste, e manter avaliação de aceite M3-02 separada após evidência e parecer QA. Custo zero absoluto (R$ 0,00); sem pull, build, instalação, mudança de configuração/permissões do host ou alteração nos contêineres existentes (`tkc-postgres16` / `tkc_lab-backend-1`). `bash -n` foi verificado por AGT-003 após a derivação da R05; execução funcional na VM `NÃO_EXECUTADA`. Métricas `NÃO MEDIDO`.
