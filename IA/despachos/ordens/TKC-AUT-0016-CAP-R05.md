# TKC-AUT-0016-CAP-R05 — Ensaio humano com Docker local existente e sudo interativo controlado

task_id: TKC-0016
order_id: TKC-0016-O07
revision: 5 (corrigida em C11 conforme ressalvas AGT-002 C10)
supersedes: R04 @bccc7dfea08ad55eac6ff80fb5451cd3cb325d1d, encerrada BLOQUEADA por sudo -n sem acesso Docker não interativo
status / authorization_state: PENDENTE — revisão pontual AGT-002 e nova decisão humana #TRUE obrigatórias antes da execução
executor: HUMAN-001 — VM local existente
author / recorded_by: AGT-003 — DevOps/SRE (gemini-4-hydrogen, AI Studio)
preparation_auth_ref: AGT-003 — TKC-AUT-0016-CAP-R05 @144833f #TRUE (AGT-001 III)
reviewer_proposed: AGT-002 — revisão pontual obrigatória antes da execução humana
base_commit: 144833f12f438f8bc634c0f85f9537d45f4bac51
script: scripts/qa/tkc-0016-cap-r05.sh @5820845391a31e0639fd1c0cbfd1bf422e87bb26
script_blob: 97bd77acdafa8fe55aa06c96e104d46019b445ab
test_revision: 706cda089731263ee4f0b5e48e2bfe06047f57ef
test_blob: a165e47889ddcc99c026a2562914336f9077738a
cost_limit: R$ 0,00 inclusive risco de cobrança futura; dúvida implica parada antes do download
risk: L2 — Docker local descartável com imagem existente, sem alteração de produto, host ou contêineres existentes
scope: download HTTPS versionado do script, verificação de hash e sintaxe, leitura pública GitHub, uma cópia temporária local, sudo -v controlado apenas para socket Docker local e um contêiner efêmero de imagem local com limite de duração, envio do resumo
remote_write_scope: nenhum nesta ordem; registro da evidência posterior requer autorização explícita
decision_ref: TKC-AUT-0016-CAP-R05 @SHA #TRUE (após revisão pontual de AGT-002)
provenance: resultado e decisão humanos MEDIADO; publicação do script VERIFICADA; execução na VM NÃO_EXECUTADA
dependencies: C10/C11 entregues; revisão pontual AGT-002 concluída; HUMAN-001 confirma daemon na VM local existente e custo zero
stop_condition: qualquer dúvida sobre custos, daemon não local, execução como root, falha de sudo -v, imagem ausente ou com volumes, timeout (60s), integridade, dependências, isolamento ou falha; não corrigir nem repetir automaticamente

## Procedimento
Executar na VM local existente (como usuário normal, nunca como root), somente após revisão pontual de AGT-002 e decisão `#TRUE` de HUMAN-001, via download HTTPS do script fixado no commit acima:

```bash
tmp=$(mktemp) && curl --fail --silent --show-error --location --proto '=https' --tlsv1.2 "https://raw.githubusercontent.com/edinhogrubert/TeamKitCollection/5820845391a31e0639fd1c0cbfd1bf422e87bb26/scripts/qa/tkc-0016-cap-r05.sh" -o "$tmp" && [[ -s "$tmp" ]] && [[ "$(git hash-object "$tmp")" == "97bd77acdafa8fe55aa06c96e104d46019b445ab" ]] && bash -n "$tmp" && bash "$tmp" --custo-zero-local-confirmado; rm -f "$tmp"
```

O argumento `--custo-zero-local-confirmado` expressa confirmação humana da ausência de cobrança e de que o daemon em `/var/run/docker.sock` é efetivamente local. Se houver dúvida, não baixar nem executar.

O script limpa `DOCKER_*`, proxies, `LD_*` e `SUDO_ASKPASS`; aceita exclusivamente o socket Unix `/var/run/docker.sock` (ignorando contextos/credenciais Docker do usuário); exige `EUID != 0`; tenta acesso direto e, apenas se indisponível, executa `sudo -v` interativo controlado (sem alterar grupo `docker`, `sudoers` ou permissões do host), usando `env -i` antes do `sudo` tanto em `sudo_env` quanto no fallback `sudo_direto`.

Inspeciona a imagem local `teamkitcollection/backend:lab`, fixa seu ID por `sha256` e rejeita imagens com volumes declarados. **Não baixar (`--pull=never`) nem construir imagem.** Obtém por leitura pública GitHub a revisão `706cda089731263ee4f0b5e48e2bfe06047f57ef`, confirma `TEST_BLOB` e estado limpo, rejeitando arquivos de configuração `pytest` extras.

Executa um único contêiner temporário nomeado (`--name tkc-cap-r05-$$`) sob `timeout --signal=TERM --kill-after=10s 60s`, com `--rm --pull=never --network none --read-only --cap-drop ALL --security-opt no-new-privileges:true --user 10001:10001 --pids-limit 128 --memory 512m --cpus 1 --no-healthcheck --log-driver none --tmpfs /tmp:rw,nosuid,nodev,noexec,size=64m,mode=1777`, montagem `--mount ...readonly`, entrypoint explícito com ambiente mínimo, executando:
`python -m pytest -q -p no:cacheprovider --color=no --tb=no tests/unit/test_health_unit.py`

Após a execução (ou em timeout/interrupção/falha), o script executa encerramento e remoção explícitos (`docker stop -t 5`, `docker rm -f`), verifica ausência do contêiner residual, remove o diretório temporário em `cleanup()` e preserva o código de retorno real do comando após a limpeza.

Resultado esperado: `3 passed`, `PYTEST_RC=0`, `DOCKER_RUN_RC=0`, `ESTADO_ANTES=LIMPO`, `ESTADO_DEPOIS=LIMPO`. Saída restrita a versões, marcadores e contagens permitidas, sem logs brutos.

## Retorno e limites
HUMAN-001 envia apenas o resumo terminal (`CAP=ENTREGUE` ou `CAP=BLOQUEADA`). Registrar como `MEDIADO`, distinguir falha de ambiente de falha de teste, e não atribuir capacidade de `pytest` à AGT-004. Nenhum patch liberado; nenhuma homologação M3-02. Custo zero absoluto (R$ 0,00); sem pull, build, instalação, mudança de configuração/permissões do host ou alteração nos contêineres existentes (`tkc-postgres16` / `tkc_lab-backend-1`). `bash -n` foi verificado por AGT-003 após a correção C11; execução funcional na VM `NÃO_EXECUTADA`. Métricas `NÃO MEDIDO`.
