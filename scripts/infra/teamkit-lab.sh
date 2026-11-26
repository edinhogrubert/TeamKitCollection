#!/usr/bin/env bash
# TeamKitCollection — Console do laboratório Ubuntu 24.04 (TKC-0008 / TKC-0009).
# Um único ponto de entrada. Uso: bash teamkit-lab.sh [menu|status|docker-check|docker-install|pg-check|pg-start|persist|backend-check|backend-up|backend-fault]
# Não realiza reset, remoção de volumes/containers, alteração do firewall ou edição do aplicativo.
set -Eeuo pipefail

# Instalações existentes versionadas neste commit; não baixar versões móveis.
SCRIPTS_REV="e26def6a4a2da84e57c88a4e384874e38c4cebc5"
BASE_URL="https://raw.githubusercontent.com/edinhogrubert/TeamKitCollection/${SCRIPTS_REV}/scripts/infra"
BACKEND_REV="8d0cfa789f055f139c8f6efc06fe59f7ca71be8d"
PG_NAME="tkc-postgres16"
PG_VOLUME="tkc-postgres16-data"
PG_DB="teamkitcollection"
PG_USER="tkc_app"
TMP_DIR=""
trap 'rc=$?; if [[ -n "$TMP_DIR" && -d "$TMP_DIR" ]]; then rm -rf -- "$TMP_DIR"; fi; if (( rc != 0 )); then printf "[ERRO] Operação interrompida (código %s); nenhum recurso de banco foi removido.\n" "$rc" >&2; fi' EXIT

info() { printf '[INFO] %s\n' "$*"; }
ok() { printf '[OK] %s\n' "$*"; }
die() { printf '[BLOQUEADO] %s\n' "$*" >&2; exit 1; }
require_docker() { command -v docker >/dev/null 2>&1 || die 'Docker não encontrado. Use o menu para instalá-lo.'; }
require_sudo() { command -v sudo >/dev/null 2>&1 || die 'sudo não encontrado.'; sudo -v; }
fetch_script() {
  command -v curl >/dev/null 2>&1 || die 'curl é necessário para baixar instaladores versionados.'
  if [[ -z "$TMP_DIR" ]]; then TMP_DIR="$(mktemp -d)"; chmod 700 "$TMP_DIR"; fi
  local name="$1"
  case "$name" in install-docker-ubuntu.sh|postgres16-lab.sh|backend-lab.sh) ;; *) die 'Nome de script não permitido.' ;; esac
  local script_ref="$SCRIPTS_REV"
  if [[ "$name" == backend-lab.sh ]]; then script_ref="$BACKEND_REV"; fi
  curl --fail --silent --show-error --location --proto '=https' --tlsv1.2 \
    "https://raw.githubusercontent.com/edinhogrubert/TeamKitCollection/${script_ref}/scripts/infra/${name}" -o "${TMP_DIR}/${name}"
  bash -n "${TMP_DIR}/${name}" || die "Sintaxe inválida: $name"
  info "Instalador revisionado: ${name} @ ${script_ref:0:12}"
}

status() {
  echo '=== ESTADO DO LABORATÓRIO ==='
  printf 'SO: '; ( . /etc/os-release; printf '%s\n' "$PRETTY_NAME" )
  if command -v docker >/dev/null 2>&1; then
    docker --version
    docker compose version || true
    if sudo -n docker info --format 'Servidor Docker: {{.ServerVersion}}' 2>/dev/null; then
      echo 'Containers relevantes:'
      sudo -n docker ps -a --filter "name=^/${PG_NAME}$" --format '  {{.Names}}: {{.Status}} ({{.Image}})'
      echo 'Portas publicadas pelo PostgreSQL (vazio = nenhuma):'
      sudo -n docker port "$PG_NAME" 2>/dev/null || true
      if sudo -n docker volume inspect "$PG_VOLUME" >/dev/null 2>&1; then
        ok "Volume encontrado: $PG_VOLUME"
      else
        info 'Volume PostgreSQL ainda não existe.'
      fi
    else
      info 'Sem acesso não interativo ao daemon Docker. Execute uma ação para autenticar sudo.'
    fi
  else
    info 'Docker não instalado.'
  fi
}

run_existing() {
  local script="$1" mode="$2"
  fetch_script "$script"
  bash "${TMP_DIR}/${script}" "$mode"
}

ensure_pg_running() {
  require_docker
  sudo docker inspect "$PG_NAME" >/dev/null 2>&1 || die "Container $PG_NAME não encontrado."
  [[ "$(sudo docker inspect -f '{{.State.Running}}' "$PG_NAME")" == true ]] || die "Container $PG_NAME não está em execução."
  local ports mount
  ports="$(sudo docker port "$PG_NAME")" || die 'Falha consultando portas.'
  [[ -z "$ports" ]] || die "PostgreSQL possui portas publicadas: $ports"
  mount="$(sudo docker inspect -f '{{range .Mounts}}{{if eq .Destination "/var/lib/postgresql/data"}}{{.Type}}:{{.Name}}{{end}}{{end}}' "$PG_NAME")"
  [[ "$mount" == "volume:$PG_VOLUME" ]] || die "Montagem inesperada para PGDATA: $mount"
}

pg_sql() {
  local sql="$1"
  sudo docker exec "$PG_NAME" psql -X -q -v ON_ERROR_STOP=1 \
    -U "$PG_USER" -d "$PG_DB" -tAc "$sql"
}

persist() {
  require_sudo
  ensure_pg_running
  command -v openssl >/dev/null 2>&1 || die 'openssl necessário para gerar ID aleatório.'
  info 'Teste: INSERT sintético, RESTART apenas do container PostgreSQL e SELECT.'
  info 'Não remove volumes nem containers. Pode interromper conexões ativas durante o reinício.'
  printf 'Para autorizar o reinício deste container digite REINICIAR: '
  local answer
  read -r answer || die 'Confirmação não recebida.'
  [[ "$answer" == REINICIAR ]] || die 'Reinício cancelado.'
  local token before after ready=0
  token="tkc-$(openssl rand -hex 16)"
  pg_sql 'CREATE TABLE IF NOT EXISTS public.tkc_lab_persistence_probe (token text PRIMARY KEY, created_at timestamptz NOT NULL DEFAULT now());' >/dev/null
  pg_sql "INSERT INTO public.tkc_lab_persistence_probe (token) VALUES ('$token');" >/dev/null
  before="$(pg_sql "SELECT count(*) FROM public.tkc_lab_persistence_probe WHERE token = '$token';")"
  [[ "$before" == 1 ]] || die 'Registro não confirmado antes do reinício. Nenhuma exclusão realizada.'
  ok 'Inserção sintética confirmada antes do reinício.'
  info 'Reiniciando somente tkc-postgres16...'
  sudo docker restart "$PG_NAME" >/dev/null
  for ((i=1;i<=20;i++)); do
    if sudo docker exec "$PG_NAME" pg_isready -U "$PG_USER" -d "$PG_DB" >/dev/null 2>&1; then ready=1; break; fi
    sleep 2
  done
  [[ "$ready" -eq 1 ]] || die 'PostgreSQL não ficou pronto após reinício. Recursos preservados para diagnóstico.'
  after="$(pg_sql "SELECT count(*) FROM public.tkc_lab_persistence_probe WHERE token = '$token';")"
  [[ "$after" == 1 ]] || die 'Registro não encontrado após reinício; persistência não comprovada.'
  ok 'TKC-0008: persistência COMPROVADA por SELECT após reinício do container.'
  ok "Banco: $PG_DB; volume: $PG_VOLUME; token de teste: $token"
}

action() {
  case "$1" in
    status) status ;;
    docker-check) run_existing install-docker-ubuntu.sh --check ;;
    docker-install)
      info 'Instalação do Docker modifica pacotes e serviços do Ubuntu; exige autorização humana aplicável.'
      run_existing install-docker-ubuntu.sh --install
      ;;
    pg-check) run_existing postgres16-lab.sh --check ;;
    pg-start)
      info 'Cria imagem/credenciais/volume/container; exige autorização operacional humana aplicável.'
      run_existing postgres16-lab.sh --start
      ;;
    persist) persist ;;
    backend-check) run_existing backend-lab.sh check ;;
    backend-up) run_existing backend-lab.sh up ;;
    backend-fault) run_existing backend-lab.sh fault ;;
    *) die "Opção desconhecida: $1" ;;
  esac
}

run_menu_action() {
  local act="$1" rc=0
  if ( action "$act" ); then
    return 0
  else
    rc=$?
    printf '[ATENÇÃO] Ação "%s" finalizou com código %s. O menu permanece ativo para diagnóstico.\n' "$act" "$rc" >&2
    return 0
  fi
}

menu() {
  while true; do
    echo
    echo '========== TEAMKITCOLLECTION | LABORATÓRIO =========='
    echo '1) Painel de estado'
    echo '2) Diagnosticar Docker (sem alterar)'
    echo '3) Instalar Docker Engine e Compose'
    echo '4) Diagnosticar PostgreSQL (sem alterar)'
    echo '5) Iniciar PostgreSQL 16 (se não existir)'
    echo '6) Testar persistência (INSERT + RESTART + SELECT)'
    echo '7) Diagnosticar API e PostgreSQL'
    echo '8) Preparar rede e iniciar backend /health'
    echo '9) Testar HTTP 503 e recuperação 200'
    echo '0) Sair'
    printf 'Escolha: '
    local choice
    read -r choice || break
    case "$choice" in
      0) break ;;
      1) run_menu_action status ;;
      2) run_menu_action docker-check ;;
      3) run_menu_action docker-install ;;
      4) run_menu_action pg-check ;;
      5) run_menu_action pg-start ;;
      6) run_menu_action persist ;;
      7) run_menu_action backend-check ;;
      8) run_menu_action backend-up ;;
      9) run_menu_action backend-fault ;;
      *) info 'Selecione uma opção de 0 a 9.' ;;
    esac
  done
  ok 'Menu encerrado.'
}

main() {
  local choice="${1:-menu}"
  if [[ $# -gt 1 ]]; then die 'Uso: bash teamkit-lab.sh [menu|status|docker-check|docker-install|pg-check|pg-start|persist|backend-check|backend-up|backend-fault]'; fi
  if [[ "$choice" == menu ]]; then menu; else action "$choice"; fi
}
main "$@"
