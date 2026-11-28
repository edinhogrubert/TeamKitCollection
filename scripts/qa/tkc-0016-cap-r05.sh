#!/usr/bin/env bash
# TKC-0016 CAP R05 — somente VM local, imagem existente, sudo interativo controlado, custo zero.
set -Eeuo pipefail
umask 077
export LC_ALL=C

unset DOCKER_HOST DOCKER_CONTEXT DOCKER_CONFIG DOCKER_TLS_VERIFY DOCKER_CERT_PATH DOCKER_API_VERSION   SUDO_ASKPASS HTTP_PROXY HTTPS_PROXY ALL_PROXY NO_PROXY http_proxy https_proxy all_proxy no_proxy   LD_PRELOAD LD_LIBRARY_PATH

readonly REV='706cda089731263ee4f0b5e48e2bfe06047f57ef'
readonly TEST_BLOB='a165e47889ddcc99c026a2562914336f9077738a'
readonly URL='https://github.com/edinhogrubert/TeamKitCollection.git'
readonly IMAGE='teamkitcollection/backend:lab'
readonly TIMEOUT_SEC=60
readonly CNAME="tkc-cap-r05-$$"

work=""
container_started=0
d=()

fail() {
  local msg="$1"
  local code="${2:-1}"
  printf 'CAP=BLOQUEADA | %s\n' "$msg"
  exit "$code"
}

cleanup() {
  local exit_rc=$?
  if [[ "${container_started:-0}" -eq 1 && ${#d[@]} -gt 0 ]]; then
    "${d[@]}" stop -t 5 "$CNAME" >/dev/null 2>&1 || true
    "${d[@]}" rm -f "$CNAME" >/dev/null 2>&1 || true
  fi
  if [[ -n "${work:-}" && -d "${work:-}" ]]; then
    rm -rf -- "$work" >/dev/null 2>&1 || true
  fi
  return "$exit_rc"
}

[[ $# -eq 1 && $1 == '--custo-zero-local-confirmado' ]] || fail 'Confirme VM, daemon Docker e acesso GitHub locais/sem qualquer cobrança antes de executar.'
[[ "$EUID" -ne 0 ]] || fail 'Execute como usuário normal com sudo disponível, não como root.'
printf 'TKC-0016 CAP R05 | execução HUMAN-001 | custo adicional permitido R$ 0,00\n'

for tool in git docker mktemp mkdir rm env grep chmod timeout; do
  command -v "$tool" >/dev/null 2>&1 || fail "Ferramenta ausente: $tool"
done
[[ -S /var/run/docker.sock ]] || fail 'Socket Docker local convencional indisponível; nenhum contexto remoto será usado.'
DOCKER=$(type -P docker)
[[ "$DOCKER" == /* ]] || fail 'Caminho Docker não confirmado.'

work=$(mktemp -d) || fail 'Diretório temporário indisponível.'
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
mkdir "$work/home" "$work/docker" "$work/template" "$work/repo"
repo="$work/repo"

# Ignorar contextos, configuração e credenciais Docker existentes; somente socket Unix e ambiente sanitizado.
d=(env -i PATH=/usr/bin:/bin HOME="$work/home" LC_ALL=C "$DOCKER" --config "$work/docker" --host unix:///var/run/docker.sock)
if "${d[@]}" info --format '{{.ServerVersion}}' >"$work/daemon" 2>&1; then
  printf 'DOCKER_ACESSO=direto\n'
else
  SUDO=$(type -P sudo || true)
  [[ -n "$SUDO" && "$SUDO" == /* ]] || fail 'Acesso Docker local indisponível.'
  "$SUDO" -v || fail 'Autenticação sudo para acesso Docker local falhou.'
  d=(env -i PATH=/usr/bin:/bin HOME="$work/home" LC_ALL=C "$SUDO" -- /usr/bin/env -i PATH=/usr/bin:/bin HOME="$work/home" LC_ALL=C "$DOCKER" --config "$work/docker" --host unix:///var/run/docker.sock)
  "${d[@]}" info --format '{{.ServerVersion}}' >"$work/daemon" 2>&1 || fail 'Acesso Docker local sanitizado indisponível após autenticação sudo; sem fallback não sanitizado e sem alterar permissões.'
  printf 'DOCKER_ACESSO=sudo_env\n'
fi
image_id=$("${d[@]}" image inspect --format '{{.Id}}' "$IMAGE" 2>"$work/inspect.log") || fail 'Imagem local teamkitcollection/backend:lab ausente; pull/build proibidos.'
[[ "$image_id" =~ ^sha256:[0-9a-f]{64}$ ]] || fail 'ID da imagem não confirmado.'
volumes=$("${d[@]}" image inspect --format '{{len .Config.Volumes}}' "$image_id" 2>>"$work/inspect.log") || fail 'Configuração da imagem não confirmada.'
[[ "$volumes" == 0 ]] || fail 'Imagem declara volumes; não criar volumes automaticamente.'
printf 'IMAGEM_LOCAL=%s\n' "$image_id"
# Aquisição somente leitura e pública, sem configuração Git real, credenciais, hooks ou submódulos.
g() { env -i PATH=/usr/bin:/bin HOME="$work/home" LC_ALL=C GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null GIT_TERMINAL_PROMPT=0 GIT_LFS_SKIP_SMUDGE=1 git -C "$repo" -c core.hooksPath=/dev/null -c credential.helper= -c http.followRedirects=false "$@"; }
g init --quiet --template="$work/template" >"$work/git.log" 2>&1 || fail 'Git init temporário falhou.'
g fetch --quiet --depth=1 --no-tags --no-recurse-submodules "$URL" "$REV" >>"$work/git.log" 2>&1 || fail 'Aquisição pública da revisão falhou; não usar credenciais nem contornar.'
g checkout --quiet --detach "$REV" >>"$work/git.log" 2>&1 || fail 'Checkout temporário falhou.'
[[ $(g rev-parse HEAD) == "$REV" ]] || fail 'SHA divergente.'
[[ $(g hash-object tests/unit/test_health_unit.py) == "$TEST_BLOB" ]] || fail 'Blob do teste divergente.'
for file in pytest.ini pyproject.toml setup.cfg tox.ini .pytest.ini conftest.py tests/conftest.py tests/unit/conftest.py; do
  [[ ! -e "$repo/$file" && ! -L "$repo/$file" ]] || fail "Configuração pytest inesperada: $file"
done
# Permitir leitura pelo UID não privilegiado apenas na cópia descartável.
chmod -R a+rX "$repo" || fail 'Leitura da cópia temporária não disponível.'
before=$(g status --porcelain --untracked-files=all --ignored) || fail 'Estado Git não confirmado.'
[[ -z "$before" ]] || fail 'Cópia inicial não está limpa.'
printf 'REVISAO=%s\nBLOB_TESTE=%s\nESTADO_ANTES=LIMPO\n' "$REV" "$TEST_BLOB"
printf 'COMANDO=python -m pytest -q -p no:cacheprovider --color=no --tb=no tests/unit/test_health_unit.py\n'
# Um único contêiner temporário, sem rede, sem pull, sem portas, sem escrita no checkout, com limite de duração.
# Não herdar ambiente do contêiner em execução; imagem por ID, entrypoint explícito, HOME temporário.
container_started=1
set +e
timeout --signal=TERM --kill-after=10s "${TIMEOUT_SEC}s" "${d[@]}" run --name "$CNAME" --rm --pull=never --network none --read-only --cap-drop ALL --security-opt no-new-privileges:true --user 10001:10001 --pids-limit 128 --memory 512m --cpus 1 --no-healthcheck --log-driver none --tmpfs /tmp:rw,nosuid,nodev,noexec,size=64m,mode=1777 --mount "type=bind,source=$repo,target=/work,readonly" --workdir /work --entrypoint /usr/bin/env "$image_id" -i PATH=/usr/local/bin:/usr/bin:/bin HOME=/tmp TMPDIR=/tmp LC_ALL=C PYTHONNOUSERSITE=1 PYTHONDONTWRITEBYTECODE=1 PYTEST_DISABLE_PLUGIN_AUTOLOAD=1 /bin/sh -ec '
  python -c '\''import sys; from importlib.metadata import version; print("PYTHON="+".".join(map(str,sys.version_info[:3]))); [print(n+"="+version(n)) for n in ("pytest","fastapi","httpx","psycopg")]'\''
  printf "DEPENDENCIAS=CONFIRMADAS\n"
  printf "PYTEST_INICIADO=SIM\n"
  set +e
  python -m pytest -q -p no:cacheprovider --color=no --tb=no tests/unit/test_health_unit.py
  rc=$?
  printf "PYTEST_RC=%s\n" "$rc"
  exit "$rc"
' >"$work/run.log" 2>&1
rc=$?
set -e
printf 'DOCKER_RUN_RC=%s\n' "$rc"

# Garantir encerramento, remoção e confirmação de ausência do contêiner temporário sem ignorar erros de consulta.
if ! remaining=$("${d[@]}" ps -a --filter "name=^/${CNAME}$" --format '{{.ID}}' 2>"$work/ps.log"); then
  fail 'Falha ao consultar ausência do contêiner temporário no daemon Docker.' "$(( rc != 0 ? rc : 1 ))"
fi
if [[ -n "$remaining" ]]; then
  "${d[@]}" stop -t 5 "$CNAME" >/dev/null 2>&1 || true
  "${d[@]}" rm -f "$CNAME" >/dev/null 2>&1 || true
  if ! remaining=$("${d[@]}" ps -a --filter "name=^/${CNAME}$" --format '{{.ID}}' 2>"$work/ps.log"); then
    fail 'Falha ao reconsultar ausência do contêiner temporário no daemon Docker.' "$(( rc != 0 ? rc : 1 ))"
  fi
  [[ -z "$remaining" ]] || fail 'Contêiner temporário não foi encerrado/removido com segurança.' "$(( rc != 0 ? rc : 1 ))"
fi
container_started=0

# Saída limitada a versões, marcadores e contagens; nunca divulgar logs brutos.
grep -E '^(PYTHON|pytest|fastapi|httpx|psycopg)=[0-9A-Za-z.+!_-]+$|^DEPENDENCIAS=CONFIRMADAS$|^PYTEST_INICIADO=SIM$|^PYTEST_RC=[0-9]+$|^[0-9]+ (passed|failed|errors?|skipped|xfailed|xpassed)(, [0-9]+ (passed|failed|errors?|skipped|xfailed|xpassed|warnings?|deselected))* in [0-9.]+s$' "$work/run.log" || true
after=$(g status --porcelain --untracked-files=all --ignored) || fail 'Estado posterior não confirmado.' "$(( rc != 0 ? rc : 1 ))"
[[ -z "$after" && $(g rev-parse HEAD) == "$REV" ]] || fail 'Cópia alterada; resultado não aceito.' "$(( rc != 0 ? rc : 1 ))"
printf 'ESTADO_DEPOIS=LIMPO\n'
if [[ $rc -eq 124 || $rc -eq 137 ]]; then
  fail "Tempo limite (${TIMEOUT_SEC}s) excedido; contêiner temporário encerrado com segurança." "$rc"
fi
grep -Fxq 'PYTEST_INICIADO=SIM' "$work/run.log" || fail 'Contêiner ou dependências indisponíveis; pytest não confirmado como iniciado.' "$(( rc != 0 ? rc : 1 ))"
[[ $rc -eq 0 ]] && grep -Fxq 'PYTEST_RC=0' "$work/run.log" || fail 'Execução não retornou zero; sem repetição automática.' "$(( rc != 0 ? rc : 1 ))"
grep -Eq '^3 passed(, [0-9]+ warnings?)? in [0-9.]+s$' "$work/run.log" || fail 'Três testes aprovados não confirmados.'
printf 'CAP=ENTREGUE | 3 testes aprovados | evidência HUMANA, MEDIADO\n'
