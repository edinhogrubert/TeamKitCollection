# TKC-AUT-0016-CAP-R05 — Ensaio humano com Docker local existente e sudo interativo controlado

task_id: TKC-0016
order_id: TKC-0016-O07
revision: 5 (corrigida em C13 conforme ressalvas AGT-002 C12)
supersedes: R04 @bccc7dfea08ad55eac6ff80fb5451cd3cb325d1d, encerrada BLOQUEADA por sudo -n sem acesso Docker não interativo
status / authorization_state: PENDENTE — revisão final AGT-002 e nova decisão humana #TRUE obrigatórias antes da execução
executor: HUMAN-001 — VM local existente
author / recorded_by: AGT-003 — DevOps/SRE (gemini-4-hydrogen, AI Studio)
preparation_auth_ref: AGT-003 — TKC-AUT-0016-CAP-R05 @186ebf4 #TRUE (AGT-001 III)
reviewer_proposed: AGT-002 — revisão independente obrigatória antes da execução humana
base_commit: 186ebf4022214aba3d91cd9faa008fb671381682
script: scripts/qa/tkc-0016-cap-r05.sh @e9da9e383c0ae8cdf3f52c951eadcd8ab8a506b7
script_blob: fd3942b45b7013c70c6534d488dd859d81fbee29
test_revision: 706cda089731263ee4f0b5e48e2bfe06047f57ef
test_blob: a165e47889ddcc99c026a2562914336f9077738a
cost_limit: R$ 0,00 inclusive risco de cobrança futura; dúvida implica parada antes do download
risk: L2 — Docker local descartável com imagem existente, sem alteração de produto, host ou contêineres existentes
scope: download HTTPS versionado do script, verificação de hash e sintaxe com preservação do código de retorno via trap em subshell, leitura pública GitHub, uma cópia temporária local, sudo -v controlado com env -i apenas para socket Docker local e um contêiner efêmero de imagem local com limite de duração, envio do resumo
remote_write_scope: nenhum nesta ordem; registro da evidência posterior requer autorização explícita
decision_ref: TKC-AUT-0016-CAP-R05 @SHA #TRUE (após revisão de AGT-002)
provenance: resultado e decisão humanos MEDIADO; publicação do script VERIFICADA; execução na VM NÃO_EXECUTADA
dependencies: C12/C13 entregues; revisão AGT-002 concluída; HUMAN-001 confirma daemon na VM local existente e custo zero
stop_condition: qualquer dúvida sobre custos, daemon não local, execução como root, falha de sudo -v ou sudo_env, erro ao consultar docker ps, imagem ausente ou com volumes, timeout (60s), integridade, dependências, isolamento ou falha; não corrigir nem repetir automaticamente

## Procedimento
Executar na VM local existente (como usuário normal, nunca como root), somente após revisão de AGT-002 e decisão `#TRUE` de HUMAN-001, via download HTTPS do script fixado no commit acima (em subshell com `trap` para remover `"$tmp"` preservando o código de retorno real de qualquer etapa):

```bash
(tmp=$(mktemp) && trap 'rc=$?; rm -f -- "$tmp"; exit "$rc"' EXIT && curl --fail --silent --show-error --location --proto '=https' --tlsv1.2 "https://raw.githubusercontent.com/edinhogrubert/TeamKitCollection/e9da9e383c0ae8cdf3f52c951eadcd8ab8a506b7/scripts/qa/tkc-0016-cap-r05.sh" -o "$tmp" && [[ -s "$tmp" ]] && [[ "$(git hash-object "$tmp")" == "fd3942b45b7013c70c6534d488dd859d81fbee29" ]] && bash -n "$tmp" && bash "$tmp" --custo-zero-local-confirmado)
```

O argumento `--custo-zero-local-confirmado` expressa confirmação humana da ausência de cobrança e de que o daemon em `/var/run/docker.sock` é efetivamente local. Se houver dúvida, não baixar nem executar.

O script limpa `DOCKER_*`, proxies, `LD_*` e `SUDO_ASKPASS`; aceita exclusivamente o socket Unix `/var/run/docker.sock` (ignorando contextos/credenciais Docker do usuário); exige `EUID != 0`; tenta acesso direto sanitizado (`direto`) e, apenas se indisponível, executa `sudo -v` interativo controlado (sem alterar grupo `docker`, `sudoers` ou permissões do host) seguido exclusivamente pelo caminho sanitizado `sudo_env` (`env -i ... sudo -- /usr/bin/env -i ... "$DOCKER"`), sem qualquer fallback não sanitizado.

Inspeciona a imagem local `teamkitcollection/backend:lab`, fixa seu ID por `sha256` e rejeita imagens com volumes declarados. **Não baixar (`--pull=never`) nem construir imagem.** Obtém por leitura pública GitHub a revisão `706cda089731263ee4f0b5e48e2bfe06047f57ef`, confirma `TEST_BLOB` e estado limpo, rejeitando arquivos de configuração `pytest` extras.

Executa um único contêiner temporário nomeado (`--name tkc-cap-r05-$$`) sob `timeout --signal=TERM --kill-after=10s 60s`, com `--rm --pull=never --network none --read-only --cap-drop ALL --security-opt no-new-privileges:true --user 10001:10001 --pids-limit 128 --memory 512m --cpus 1 --no-healthcheck --log-driver none --tmpfs /tmp:rw,nosuid,nodev,noexec,size=64m,mode=1777`, montagem `--mount ...readonly`, entrypoint explícito com ambiente mínimo, executando:
`python -m pytest -q -p no:cacheprovider --color=no --tb=no tests/unit/test_health_unit.py`

Após a execução (ou em timeout/interrupção/falha), o script consulta o daemon sem ignorar erros de `docker ps -a`, executa `docker stop -t 5` e `docker rm -f` se houver contêiner residual, reconsulta `docker ps -a` sem ignorar falhas, remove o diretório temporário em `cleanup()` e preserva o código de retorno real do comando após a limpeza.

Resultado esperado: `3 passed`, `PYTEST_RC=0`, `DOCKER_RUN_RC=0`, `ESTADO_ANTES=LIMPO`, `ESTADO_DEPOIS=LIMPO`. Saída restrita a versões, marcadores e contagens permitidas, sem logs brutos.

## Retorno e limites
HUMAN-001 envia apenas o resumo terminal (`CAP=ENTREGUE` ou `CAP=BLOQUEADA`). Registrar como `MEDIADO`, distinguir falha de ambiente de falha de teste, e não atribuir capacidade de `pytest` à AGT-004. Nenhum patch liberado; nenhuma homologação M3-02. Custo zero absoluto (R$ 0,00); sem pull, build, instalação, mudança de configuração/permissões do host ou alteração nos contêineres existentes (`tkc-postgres16` / `tkc_lab-backend-1`). `bash -n` foi verificado por AGT-003 após a correção C13; execução funcional na VM `NÃO_EXECUTADA`. Métricas `NÃO MEDIDO`.
