# TKC-AUT-0016-CAP-R05 — Ensaio humano com Docker local existente e sudo interativo controlado

task_id: TKC-0016
order_id: TKC-0016-O07
revision: 5
supersedes: R04 @bccc7dfea08ad55eac6ff80fb5451cd3cb325d1d, encerrada BLOQUEADA por sudo -n sem acesso Docker não interativo
status / authorization_state: PENDENTE — revisão independente AGT-002 e nova decisão humana #TRUE obrigatórias antes da execução
executor: HUMAN-001 — VM local existente
author / recorded_by: AGT-003 — DevOps/SRE (gemini-4-hydrogen, AI Studio)
preparation_auth_ref: AGT-003 — #TRUE | TKC-0016 | Base 88b9c52 (AGT-001 III)
reviewer_proposed: AGT-002 — revisão independente obrigatória antes da execução humana
base_commit: 88b9c52eb4476a94ee5aad8bf2070ebe9eaf2405
script: scripts/qa/tkc-0016-cap-r05.sh @65fde21ae5e7e56aaab65be1d42e7a526018c7bb
script_blob: 8851447e3735731683b1110179c69c539a1b9cb8
test_revision: 706cda089731263ee4f0b5e48e2bfe06047f57ef
test_blob: a165e47889ddcc99c026a2562914336f9077738a
cost_limit: R$ 0,00 inclusive risco de cobrança futura; dúvida implica parada antes do download
risk: L2 — Docker local descartável com imagem existente, sem alteração de produto, host ou contêineres existentes
scope: download HTTPS versionado do script, verificação de hash e sintaxe, leitura pública GitHub, uma cópia temporária local, sudo -v controlado apenas para socket Docker local e um contêiner efêmero de imagem local, envio do resumo
remote_write_scope: nenhum nesta ordem; registro da evidência posterior requer autorização explícita
decision_ref: TKC-AUT-0016-CAP-R05 @SHA #TRUE (após parecer favorável de AGT-002)
provenance: resultado e decisão humanos MEDIADO; publicação do script VERIFICADA; execução na VM NÃO_EXECUTADA
dependencies: C08/C09 entregues; revisão independente AGT-002 concluída; HUMAN-001 confirma daemon na VM local existente e custo zero
stop_condition: qualquer dúvida sobre custos, daemon não local, execução como root, falha de sudo -v, imagem ausente ou com volumes, integridade, dependências, isolamento ou falha; não corrigir nem repetir automaticamente

## Procedimento
Executar na VM local existente (como usuário normal, nunca como root), somente após revisão independente de AGT-002 e decisão `#TRUE` de HUMAN-001, via download HTTPS do script fixado no commit acima:

```bash
tmp=$(mktemp) && curl --fail --silent --show-error --location --proto '=https' --tlsv1.2 "https://raw.githubusercontent.com/edinhogrubert/TeamKitCollection/65fde21ae5e7e56aaab65be1d42e7a526018c7bb/scripts/qa/tkc-0016-cap-r05.sh" -o "$tmp" && [[ -s "$tmp" ]] && [[ "$(git hash-object "$tmp")" == "8851447e3735731683b1110179c69c539a1b9cb8" ]] && bash -n "$tmp" && bash "$tmp" --custo-zero-local-confirmado; rm -f "$tmp"
```

O argumento `--custo-zero-local-confirmado` expressa confirmação humana da ausência de cobrança e de que o daemon em `/var/run/docker.sock` é efetivamente local. Se houver dúvida, não baixar nem executar.

O script aceita exclusivamente o socket Unix `/var/run/docker.sock` (ignorando contextos/credenciais Docker do usuário); exige `EUID != 0`; tenta acesso direto e, apenas se indisponível, executa `sudo -v` interativo controlado (sem alterar grupo `docker`, `sudoers` ou permissões do host), usando `sudo -- /usr/bin/env -i ...` (com fallback apenas para `sudo -- "$DOCKER" --config "$work/docker" --host unix:///var/run/docker.sock` se `sudoers` restringir `/usr/bin/env`).

Inspeciona a imagem local `teamkitcollection/backend:lab`, fixa seu ID por `sha256` e rejeita imagens com volumes declarados. **Não baixar (`--pull=never`) nem construir imagem.** Obtém por leitura pública GitHub a revisão `706cda089731263ee4f0b5e48e2bfe06047f57ef`, confirma `TEST_BLOB` e estado limpo, rejeitando arquivos de configuração `pytest` extras.

Executa um único contêiner temporário com `--rm --pull=never --network none --read-only --cap-drop ALL --security-opt no-new-privileges:true --user 10001:10001 --pids-limit 128 --memory 512m --cpus 1 --no-healthcheck --log-driver none --tmpfs /tmp:rw,nosuid,nodev,noexec,size=64m,mode=1777`, montagem `--mount ...readonly`, entrypoint explícito com ambiente mínimo, executando:
`python -m pytest -q -p no:cacheprovider --color=no --tb=no tests/unit/test_health_unit.py`

Resultado esperado: `3 passed`, `PYTEST_RC=0`, `DOCKER_RUN_RC=0`, `ESTADO_ANTES=LIMPO`, `ESTADO_DEPOIS=LIMPO`. Saída restrita a versões, marcadores e contagens permitidas, sem logs brutos.

## Retorno e limites
HUMAN-001 envia apenas o resumo terminal (`CAP=ENTREGUE` ou `CAP=BLOQUEADA`). Registrar como `MEDIADO`, distinguir falha de ambiente de falha de teste, e não atribuir capacidade de `pytest` à AGT-004. Nenhum patch liberado; nenhuma homologação M3-02. Custo zero absoluto (R$ 0,00); sem pull, build, instalação, mudança de configuração/permissões do host ou alteração nos contêineres existentes (`tkc-postgres16` / `tkc_lab-backend-1`). `bash -n` foi verificado por AGT-003 na preparação; execução funcional na VM `NÃO_EXECUTADA`. Métricas `NÃO MEDIDO`.
