#!/usr/bin/env bash
# TKC-0005 Fase B / TKC-0009 — laboratório local, sem remover dados/containers.
# Ações: check (padrão), up, fault. Nunca iniciar sem autorização humana aplicável.
set -Eeuo pipefail
ACTION="${1:-check}"
[[ $# -le 1 && ( "$ACTION" == check || "$ACTION" == up || "$ACTION" == fault ) ]] || { echo "Uso: bash backend-lab.sh [check|up|fault]" >&2; exit 2; }
BACKEND_REV="959745e5513e313e477ef9cdd734111af2b9768f"
DB=tkc-postgres16
VOL=tkc-postgres16-data
NET=tkc-lab-net
BACKEND_CONTAINER=tkc_lab-backend-1
COMPOSE_FILE=infra/docker/docker-compose.lab.yml
ENV_PATH="${XDG_CONFIG_HOME:-$HOME/.config}/teamkitcollection/postgres16.env"
TMP=""
ATTEMPT_RECONNECT=0
SIGNAL_CAUGHT=""

fail(){ printf '[BLOQUEADO] %s\n' "$*" >&2; exit 1; }
info(){ printf '[INFO] %s\n' "$*"; }
ok(){ printf '[OK] %s\n' "$*"; }

on_signal(){
  SIGNAL_CAUGHT="$1"
  printf '\n[ATENÇÃO] Sinal %s recebido; acionando encerramento seguro e reconexão se aplicável...\n' "$SIGNAL_CAUGHT" >&2
  exit 130
}

cleanup(){
  local rc=$?
  trap '' INT TERM
  if [[ "$ATTEMPT_RECONNECT" == 1 ]]; then
    info 'Recuperando conectividade PostgreSQL na rede do laboratório...'
    local err_msg=""
    if err_msg="$(sudo docker network connect "$NET" "$DB" 2>&1)"; then
      ok 'PostgreSQL reconectado à rede tkc-lab-net.'
      ATTEMPT_RECONNECT=0
    elif sudo docker inspect "$DB" --format '{{json .NetworkSettings.Networks}}' 2>/dev/null | grep -Fq "\"$NET\""; then
      ok 'PostgreSQL já se encontra conectado à rede tkc-lab-net.'
      ATTEMPT_RECONNECT=0
    else
      printf '[ATENÇÃO] Falha ao reconectar automaticamente (%s); executar manualmente: sudo docker network connect %s %s\n' "${err_msg:-erro desconhecido}" "$NET" "$DB" >&2
      rc=1
    fi
  fi
  if [[ -n "$TMP" && -d "$TMP" ]]; then rm -rf -- "$TMP"; fi
  if [[ $rc -ne 0 ]]; then printf '[ERRO] Operação interrompida (status %s); banco/volume preservados.\n' "$rc" >&2; fi
}
trap cleanup EXIT
trap 'on_signal SIGINT' INT
trap 'on_signal SIGTERM' TERM

command -v docker >/dev/null 2>&1 || fail 'Docker não instalado.'
command -v curl >/dev/null 2>&1 || fail 'curl não instalado.'
command -v sudo >/dev/null 2>&1 || fail 'sudo não disponível.'
if [[ "$ACTION" != check ]]; then sudo -v; fi

inspect_pg(){
  sudo docker inspect "$DB" >/dev/null 2>&1 || fail "Container existente $DB não encontrado."
  [[ "$(sudo docker inspect -f '{{.State.Running}}' "$DB")" == true ]] || fail 'PostgreSQL não está em execução.'
  local ports mount
  ports="$(sudo docker port "$DB")"
  [[ -z "$ports" ]] || fail 'PostgreSQL possui porta publicada no host.'
  mount="$(sudo docker inspect -f '{{range .Mounts}}{{if eq .Destination "/var/lib/postgresql/data"}}{{.Type}}:{{.Name}}{{end}}{{end}}' "$DB")"
  [[ "$mount" == "volume:$VOL" ]] || fail "Volume inesperado: $mount"
}

ensure_tmp(){
  if [[ -z "$TMP" || ! -d "$TMP" ]]; then
    TMP="$(mktemp -d)"
    chmod 700 "$TMP"
  fi
}

health(){
  ensure_tmp
  curl --silent --show-error --max-time 7 --output "$TMP/response" \
    --write-out '%{http_code}' http://127.0.0.1:8000/health
}

check(){
  echo '=== TKC-0005 / TKC-0009 | LABORATÓRIO BACKEND ==='
  sudo docker info --format 'Docker Engine: {{.ServerVersion}}' || fail 'Daemon Docker indisponível'
  inspect_pg
  sudo docker exec "$DB" pg_isready -U tkc_app -d teamkitcollection || fail 'Banco indisponível.'
  if [[ -f "$ENV_PATH" ]]; then
    local mode
    mode="$(stat -c %a "$ENV_PATH" 2>/dev/null || echo 'desconhecido')"
    [[ "$mode" == 600 ]] || fail "Arquivo de credenciais em $ENV_PATH possui modo $mode (esperado 600)."
    ok 'Credenciais locais presentes e em modo 0600 (conteúdo não exibido).'
  else
    fail "Credenciais locais não encontradas em $ENV_PATH"
  fi
  if sudo docker network inspect "$NET" >/dev/null 2>&1; then
    ok "Rede Docker $NET existente."
    if sudo docker inspect "$DB" --format '{{json .NetworkSettings.Networks}}' | grep -Fq "\"$NET\""; then
      ok "PostgreSQL ($DB) conectado à rede $NET."
    else
      info "PostgreSQL ($DB) ainda não conectado à rede $NET."
    fi
  else
    info "Rede Docker $NET ainda não criada."
  fi
  local backend_id backend_running
  backend_id="$(sudo docker ps -a --filter "name=^/${BACKEND_CONTAINER}$" --format '{{.ID}}')"
  if [[ -n "$backend_id" ]]; then
    sudo docker ps -a --filter "name=^/${BACKEND_CONTAINER}$" --format 'Backend: {{.Names}} | {{.Status}} | Ports: {{.Ports}}'
    backend_running="$(sudo docker inspect -f '{{.State.Running}}' "$BACKEND_CONTAINER" 2>/dev/null || echo false)"
    if [[ "$backend_running" == true ]]; then
      local code
      code="$(health 2>/dev/null || true)"
      if [[ "$code" == 200 ]] && grep -q '"database":"up"' "$TMP/response" 2>/dev/null; then
        ok 'Sonda /health: HTTP 200 (database: up).'
      else
        info "Sonda /health: HTTP ${code:-000} (API em execução, mas /health não confirmou database up)."
      fi
    else
      info "Container $BACKEND_CONTAINER existe mas não está em execução (use opção 8 / up para recuperar)."
    fi
  else
    info "Container $BACKEND_CONTAINER ainda não existe."
  fi
  info 'Nenhuma alteração realizada no check.'
}

get_code(){
  ensure_tmp
  local archive="$TMP/app.tar.gz"
  curl -fsSL --proto '=https' --tlsv1.2 \
    "https://api.github.com/repos/edinhogrubert/TeamKitCollection/tarball/$BACKEND_REV" -o "$archive"
  rm -rf -- "$TMP/source"
  mkdir -p "$TMP/source"
  tar -xzf "$archive" -C "$TMP/source" --strip-components=1
  [[ -f "$TMP/source/$COMPOSE_FILE" && -f "$TMP/source/src/backend/main.py" ]] || fail 'Pacote Git não contém arquivos necessários.'
  info "Código obtido da revisão imutável $BACKEND_REV"
}

compose(){
  sudo env TKC_PG_ENV_FILE="$ENV_PATH" docker compose \
    --project-name tkc_lab --file "$TMP/source/$COMPOSE_FILE" "$@"
}

wait_for_health_200(){
  local loops="${1:-20}" delay="${2:-2}" status=000 i
  for ((i=1;i<=loops;i++)); do
    status="$(health 2>/dev/null || true)"
    if [[ "$status" == 200 ]] && grep -q '"database":"up"' "$TMP/response" 2>/dev/null; then
      return 0
    fi
    sleep "$delay"
  done
  printf '[INFO] Último código HTTP recebido de /health: %s\n' "${status:-000}" >&2
  return 1
}

up(){
  inspect_pg
  [[ -f "$ENV_PATH" ]] || fail "Credenciais inexistentes: $ENV_PATH"
  [[ "$(stat -c %a "$ENV_PATH")" == 600 ]] || fail 'Arquivo de credenciais não está em modo 0600.'
  if ! sudo docker network inspect "$NET" >/dev/null 2>&1; then
    sudo docker network create --driver bridge "$NET" >/dev/null
    ok "Rede interna criada: $NET"
  fi
  if ! sudo docker inspect "$DB" --format '{{json .NetworkSettings.Networks}}' | grep -Fq "\"$NET\""; then
    sudo docker network connect "$NET" "$DB"
    ok 'Banco conectado à nova rede privada, sem recriação.'
  fi
  local existing running code
  existing="$(sudo docker ps -a --filter "name=^/${BACKEND_CONTAINER}$" --format '{{.ID}}')"
  if [[ -n "$existing" ]]; then
    local proj
    proj="$(sudo docker inspect -f '{{ index .Config.Labels "com.docker.compose.project" }}' "$BACKEND_CONTAINER" 2>/dev/null || true)"
    if [[ -n "$proj" && "$proj" != "tkc_lab" ]]; then
      fail "Container $BACKEND_CONTAINER pertence a projeto inesperado ($proj). Interrompendo por segurança."
    fi
    running="$(sudo docker inspect -f '{{.State.Running}}' "$BACKEND_CONTAINER" 2>/dev/null || echo false)"
    if [[ "$running" == true ]]; then
      code="$(health 2>/dev/null || true)"
      if [[ "$code" == 200 ]] && grep -q '"database":"up"' "$TMP/response" 2>/dev/null; then
        ok 'Backend já está em execução e saudável (GET /health HTTP 200, database: up). Nenhuma recriação necessária.'
        ok 'Backend publicado somente em 127.0.0.1:8000.'
        return 0
      fi
      info "Backend em execução mas /health retornou HTTP ${code:-000}; tentando convergir apenas a API..."
    else
      info "Container $BACKEND_CONTAINER encontrado parado; iniciando recuperação não destrutiva..."
      sudo docker start "$BACKEND_CONTAINER" >/dev/null
      if wait_for_health_200 10 2; then
        ok 'Container backend existente iniciado e recuperado (GET /health HTTP 200, database: up).'
        ok 'Backend publicado somente em 127.0.0.1:8000.'
        return 0
      fi
      info 'Container existente não ficou saudável apenas com docker start; convergindo via docker compose...'
    fi
  fi
  get_code
  compose config --quiet
  info 'Construindo/convergindo SOMENTE a API (sem tocar no container PostgreSQL)...'
  compose up -d --build --no-deps backend
  if ! wait_for_health_200 20 2; then
    fail 'API não confirmou HTTP 200 com database:up após convergência. Verificar logs com: sudo docker logs --tail 30 tkc_lab-backend-1'
  fi
  ok 'GET /health retornou HTTP 200; consulta PostgreSQL realizada.'
  ok 'Backend publicado somente em 127.0.0.1:8000.'
}

fault(){
  inspect_pg
  sudo docker network inspect "$NET" >/dev/null 2>&1 || fail "Rede $NET não encontrada."
  local published
  published="$(sudo docker ps --filter "name=^/${BACKEND_CONTAINER}$" --format '{{.ID}}')"
  [[ -n "$published" ]] || fail 'Backend não está em execução.'
  local pg_network
  pg_network="$(sudo docker inspect "$DB" --format '{{json .NetworkSettings.Networks}}')"
  grep -Fq "\"$NET\"" <<<"$pg_network" || fail 'Banco não conectado à rede de laboratório.'
  info 'O teste corta TEMPORARIAMENTE somente a conexão do banco com tkc-lab-net.'
  info 'A conexão será restaurada pelo script mesmo se o teste falhar (exceto SIGKILL/queda da VM).'
  printf 'Digite TESTAR para confirmar: '
  local decision
  read -r decision || fail 'Confirmação não recebida.'
  [[ "$decision" == TESTAR ]] || fail 'Teste cancelado.'
  ensure_tmp
  local status
  status="$(health 2>/dev/null || true)"
  [[ "$status" == 200 ]] || fail "Antes do teste API não respondeu 200 (recebido HTTP ${status:-000})."
  if ! grep -q '"database":"up"' "$TMP/response" 2>/dev/null; then
    fail 'Antes do teste API respondeu 200 mas corpo não confirmou database:up.'
  fi
  trap '' INT TERM
  ATTEMPT_RECONNECT=1
  sudo docker network disconnect "$NET" "$DB"
  for ((i=1;i<=5;i++)); do
    status="$(health 2>/dev/null || true)"
    [[ "$status" == 503 ]] && break
    sleep 1
  done
  if [[ "$status" != 503 ]]; then
    fail "Esperado 503 durante falha; recebido HTTP ${status:-000}. Recuperação acionada pelo trap."
  fi
  grep -q '"error":"DB_UNAVAILABLE"' "$TMP/response" 2>/dev/null || fail 'HTTP 503 sem código DB_UNAVAILABLE.'
  ok 'Falha induzida: HTTP 503 e DB_UNAVAILABLE.'
  sudo docker network connect "$NET" "$DB"
  ATTEMPT_RECONNECT=0
  trap 'on_signal SIGINT' INT
  trap 'on_signal SIGTERM' TERM
  for ((i=1;i<=15;i++)); do
    status="$(health 2>/dev/null || true)"
    [[ "$status" == 200 ]] && break
    sleep 1
  done
  [[ "$status" == 200 ]] || fail "Recuperação não retornou HTTP 200 (recebido HTTP ${status:-000})."
  grep -q '"database":"up"' "$TMP/response" 2>/dev/null || fail 'Recuperação retornou HTTP 200 sem confirmar database:up.'
  ok 'Recuperação: HTTP 200 sem reiniciar backend nem PostgreSQL.'
}

case "$ACTION" in check) check ;; up) up ;; fault) fault ;; esac
