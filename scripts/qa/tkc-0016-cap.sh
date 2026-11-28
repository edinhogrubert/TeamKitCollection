#!/usr/bin/env bash
# TKC-0016 CAP R03 | Diagnóstico local humano, sem instalação ou alteração do produto.
set -Eeuo pipefail
umask 077
export LC_ALL=C
readonly REV='706cda089731263ee4f0b5e48e2bfe06047f57ef'
readonly TEST_BLOB='a165e47889ddcc99c026a2562914336f9077738a'
readonly URL='https://github.com/edinhogrubert/TeamKitCollection.git'
fail() { printf 'CAP=BLOQUEADA | %s\n' "$1"; exit 1; }
[[ $# -eq 1 && $1 == '--custo-zero-confirmado' ]] || fail 'Confirme acesso existente sem qualquer custo ou cobrança futura antes de executar.'
printf 'TKC-0016 CAP R03 | execução HUMAN-001 | custo adicional permitido R$ 0,00\n'
for tool in git mktemp mkdir rm env unshare grep id; do
  command -v "$tool" >/dev/null 2>&1 || fail "Ferramenta local ausente: $tool"
done
PYTHON=$(type -P python || type -P python3 || true)
[[ -n "$PYTHON" && -x "$PYTHON" ]] || fail 'Python não localizado; nenhuma instalação será feita.'
[[ "$PYTHON" == /* ]] || fail 'Python sem caminho absoluto.'
work=$(mktemp -d) || fail 'Não foi possível criar diretório temporário local.'
trap 'rm -rf -- "$work"' EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
mkdir "$work/home" "$work/tmp" "$work/template" "$work/repo" || fail 'Diretório temporário indisponível.'
repo="$work/repo"
# A aquisição Git não utiliza credenciais, configuração de usuário, submódulos ou hooks.
g() { env -i PATH=/usr/bin:/bin HOME="$work/home" LC_ALL=C GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null GIT_TERMINAL_PROMPT=0 GIT_LFS_SKIP_SMUDGE=1 git -C "$repo" -c core.hooksPath=/dev/null -c credential.helper= -c http.followRedirects=false "$@"; }
# Isolamento de rede efêmero existente no kernel, sem sudo ou mudança de configuração.
if [[ $(id -u) == 0 ]]; then ns=(unshare --net --); else ns=(unshare --user --map-root-user --net --); fi
"${ns[@]}" /bin/true >/dev/null 2>&1 || fail 'Isolamento de rede indisponível; sem tentativa alternativa ou sudo.'
printf 'ISOLAMENTO_REDE=namespace disponível\n'
# O processo de teste recebe ambiente mínimo; não usa variáveis ou HOME reais.
run_local() { "${ns[@]}" env -i PATH=/usr/bin:/bin HOME="$work/home" TMPDIR="$work/tmp" LC_ALL=C PYTHONNOUSERSITE=1 PYTHONDONTWRITEBYTECODE=1 PYTEST_DISABLE_PLUGIN_AUTOLOAD=1 "$PYTHON" "$@"; }
if ! run_local -c 'import sys; from importlib.metadata import version; print("PYTHON="+".".join(map(str,sys.version_info[:3]))); [print(n+"="+version(n)) for n in ("pytest","fastapi","httpx","psycopg")]' >"$work/versions" 2>&1; then
  fail 'Dependências locais não confirmadas; nenhuma instalação será feita.'
fi
grep -E '^(PYTHON|pytest|fastapi|httpx|psycopg)=[0-9A-Za-z.+!_-]+$' "$work/versions" || fail 'Versões não confirmadas.'
# Rede exclusivamente para leitura pública de revisão fixa do GitHub; nenhum push.
g init --quiet --template="$work/template" >"$work/git.log" 2>&1 || fail 'Git init temporário falhou.'
g fetch --quiet --depth=1 --no-tags --no-recurse-submodules "$URL" "$REV" >>"$work/git.log" 2>&1 || fail 'Aquisição pública da revisão falhou; não usar credenciais nem contornar.'
g checkout --quiet --detach "$REV" >>"$work/git.log" 2>&1 || fail 'Checkout temporário falhou.'
[[ $(g rev-parse HEAD) == "$REV" ]] || fail 'Revisão diferente da autorizada.'
[[ $(g hash-object tests/unit/test_health_unit.py) == "$TEST_BLOB" ]] || fail 'Blob do teste original divergente.'
before=$(g status --porcelain --untracked-files=all --ignored) || fail 'Estado Git não confirmado.'
[[ -z "$before" ]] || fail 'Cópia inicial não está limpa.'
# Não executar hooks/configuração pytest inesperados. O teste original usa mock in-process.
for file in pytest.ini pyproject.toml setup.cfg tox.ini .pytest.ini conftest.py tests/conftest.py tests/unit/conftest.py; do
  [[ ! -e "$repo/$file" && ! -L "$repo/$file" ]] || fail "Configuração pytest inesperada: $file"
done
printf 'REVISAO=%s\nBLOB_TESTE=%s\nESTADO_ANTES=LIMPO\n' "$REV" "$TEST_BLOB"
printf 'COMANDO=python -m pytest -q -p no:cacheprovider --color=no --tb=no tests/unit/test_health_unit.py\n'
cd "$repo"
set +e
run_local -m pytest -q -p no:cacheprovider --color=no --tb=no tests/unit/test_health_unit.py >"$work/pytest.log" 2>&1
rc=$?
set -e
printf 'PYTEST_RC=%s\n' "$rc"
# Exibir somente contagens e duração reconhecidas; não publicar logs brutos, tracebacks ou ambiente.
grep -E '^[0-9]+ (passed|failed|errors?|skipped|xfailed|xpassed)(, [0-9]+ (passed|failed|errors?|skipped|xfailed|xpassed|warnings?|deselected))* in [0-9.]+s$' "$work/pytest.log" || true
after=$(g status --porcelain --untracked-files=all --ignored) || fail 'Estado posterior não confirmado.'
[[ -z "$after" && $(g rev-parse HEAD) == "$REV" ]] || fail 'Cópia alterada durante o ensaio; não aceitar resultado.'
printf 'ESTADO_DEPOIS=LIMPO\n'
[[ $rc -eq 0 ]] || fail 'Pytest não retornou zero; não repetir nem corrigir automaticamente.'
grep -Eq '^3 passed(, [0-9]+ warnings?)? in [0-9.]+s$' "$work/pytest.log" || fail 'Três testes aprovados não confirmados na saída.'
printf 'CAP=ENTREGUE | 3 testes aprovados | evidência HUMANA, MEDIADO\n'
printf 'Nenhuma instalação, alteração de produto, push ou provisionamento solicitado pelo script.\n'
