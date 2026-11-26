#!/usr/bin/env bash
# TKC-0005 Fase B — laboratório local, sem remover dados/containers.
# Ações: check (padrão), up, fault. Nunca iniciar sem autorização humana aplicável.
set -Eeuo pipefail
ACTION="${1:-check}"
[[ $# -le 1 && ( "$ACTION" == check || "$ACTION" == up || "$ACTION" == fault ) ]] || { echo "Uso: bash backend-lab.sh [check|up|fault]" >&2; exit 2; }
BACKEND_REV="959745e5513e313e477ef9cdd734111af2b9768f"
DB=tkc-postgres16
VOL=tkc-postgres16-data
NET=tkc-lab-net
COMPOSE_FILE=infra/docker/docker-compose.lab.yml
ENV_PATH="${XDG_CONFIG_HOME:-$HOME/.config}/teamkitcollection/postgres16.env"
TMP=""
ATTEMPT_RECONNECT=0
fail(){ printf '[BLOQUEADO] %s\n' "$*" >&2; exit 1; }
info(){ printf '[INFO] %s\n' "$*"; }
ok(){ printf '[OK] %s\n' "$*"; }
cleanup(){
  local rc=$?
  if [[ "$ATTEMPT_RECONNECT" == 1 ]]; then
    info 'Recuperando conectividade PostgreSQL na rede do laboratório...'
    if sudo docker network connect "$NET" "$DB" 2>/dev/null; then
      ok 'PostgreSQL reconectado à rede tkc-lab-net.'
    else
      printf '[ATENÇÃO] Não consegui reconectar; executar: sudo docker network connect %s %s\n' "$NET" "$DB" >&2
      rc=1
    fi
  fi
  if [[ -n "$TMP" && -d "$TMP" ]]; then rm -rf -- "$TMP"; fi
  if [[ $rc -ne 0 ]]; then printf '[ERRO] Operação interrompida (status %s); banco/volume preservados.\n' "$rc" >&2; fi
}
trap cleanup EXIT
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

check(){
  echo '=== TKC-0005 | LABORATÓRIO BACKEND ==='
  sudo docker info --format 'Docker Engine: {{.ServerVersion}}' || fail 'Daemon Docker indisponível'
  inspect_pg
  sudo docker exec "$DB" pg_isready -U tkc_app -d teamkitcollection || fail 'Banco indisponível.'
  if [[ -f "$ENV_PATH" ]]; then ok 'Credenciais locais presentes (conteúdo não exibido).'; else fail "Credenciais locais não encontradas em $ENV_PATH"; fi
  if sudo docker network inspect "$NET" >/dev/null 2>&1; then
    ok "Rede Docker $NET existente."
  else info "Rede Docker $NET ainda não criada."; fi
  sudo docker ps -a --filter name='^/tkc_lab-backend-1$' --format 'Backend: {{.Names}} {{.Status}}'
  info 'Nenhuma alteração realizada no check.'
}

get_code(){
  TMP="$(mktemp -d)"
  chmod 700 "$TMP"
  local archive="$TMP/app.tar.gz"
  curl -fsSL --proto '=https' --tlsv1.2 \
    "https://api.github.com/repos/edinhogrubert/TeamKitCollection/tarball/$BACKEND_REV" -o "$archive"
  mkdir -p "$TMP/source"
  tar -xzf "$archive" -C "$TMP/source" --strip-components=1
  [[ -f "$TMP/source/$COMPOSE_FILE" && -f "$TMP/source/src/backend/main.py" ]] || fail 'Pacote Git não contém arquivos necessários.'
  info "Código obtido da revisão imutável $BACKEND_REV"
}

compose(){
  sudo env TKC_PG_ENV_FILE="$ENV_PATH" docker compose \
    --project-name tkc_lab --file "$TMP/source/$COMPOSE_FILE" "$@"
}

health(){
  curl --silent --show-error --max-time 7 --output "$TMP/response" \
    --write-out '%{http_code}' http://127.0.0.1:8000/health
}

up(){
  inspect_pg
  [[ -f "$ENV_PATH" ]] || fail "Credenciais inexistentes: $ENV_PATH"
  [[ "$(stat -c %a "$ENV_PATH")" == 600 ]] || fail 'Arquivo de credenciais não está em modo 0600.'
  local existing
  existing="$(sudo docker ps -a --filter name='^/tkc_lab-backend-1$' --format '{{.ID}}')"
  [[ -z "$existing" ]] || fail 'Backend já existe. Não recriar automaticamente; usar check.'
  if ! sudo docker network inspect "$NET" >/dev/null 2>&1; then
    sudo docker network create --driver bridge "$NET" >/dev/null
    ok "Rede interna criada: $NET"
  fi
  if ! sudo docker inspect "$DB" --format '{{json .NetworkSettings.Networks}}' | grep -Fq "\"$NET\""; then
    sudo docker network connect "$NET" "$DB"
    ok 'Banco conectado à nova rede privada, sem recriação.'
  fi
  get_code
  compose config --quiet
  info 'Construindo e iniciando SOMENTE a API (sem tocar no container PostgreSQL)...'
  compose up -d --build --no-deps backend
  local status=000
  for ((i=1;i<=20;i++)); do
    status="$(health 2>/dev/null || true)"
    [[ "$status" == 200 ]] && break
    sleep 2
  done
  [[ "$status" == 200 ]] || fail "API não retornou 200 (HTTP $status). Verificar com menu e logs."
  if ! grep -q '"database":"up"' "$TMP/response"; then
    fail 'API retornou HTTP 200 mas corpo não confirmou banco up.'
  fi
  ok 'GET /health retornou HTTP 200; consulta PostgreSQL realizada.'
  ok 'Backend publicado somente em 127.0.0.1:8000.'
}
fault(){
  inspect_pg
  sudo docker network inspect "$NET" >/dev/null 2>&1 || fail "Rede $NET não encontrada."
  local published
  published="$(sudo docker ps --filter name='^/tkc_lab-backend-1$' --format '{{.ID}}')"
  [[ -n "$published" ]] || fail 'Backend não está em execução.'
  local pg_network
  pg_network="$(sudo docker inspect "$DB" --format '{{json .NetworkSettings.Networks}}')"
  grep -Fq "\"$NET\"" <<<"$pg_network" || fail 'Banco não conectado à rede de laboratório.'
  info 'O teste corta TEMPORARIAMENTE somente a conexão do banco com tkc-lab-net.'
  info 'A conexão será restaurada pelo script mesmo se o teste falhar.'
  printf 'Digite TESTAR para confirmar: '
  local decision
  read -r decision || fail 'Confirmação não recebida.'
  [[ "$decision" == TESTAR ]] || fail 'Teste cancelado.'
  TMP="$(mktemp -d)"
  chmod 700 "$TMP"
  local status
  status="$(health)"
  [[ "$status" == 200 ]] || fail "Antes do teste API não respondeu 200: $status"
  ATTEMPT_RECONNECT=1
  sudo docker network disconnect "$NET" "$DB"
  for ((i=1;i<=5;i++)); do
    status="$(health 2>/dev/null || true)"
    [[ "$status" == 503 ]] && break
    sleep 1
  done
  if [[ "$status" != 503 ]]; then
    fail "Esperado 503 durante falha; recebido HTTP $status. Recuperação acionada pelo trap."
  fi
  grep -q '"error":"DB_UNAVAILABLE"' "$TMP/response" || fail 'HTTP 503 sem código DB_UNAVAILABLE.'
  ok 'Falha induzida: HTTP 503 e DB_UNAVAILABLE.'
  sudo docker network connect "$NET" "$DB"
  ATTEMPT_RECONNECT=0
  for ((i=1;i<=15;i++)); do
    status="$(health 2>/dev/null || true)"
    [[ "$status" == 200 ]] && break
    sleep 1
  done
  [[ "$status" == 200 ]] || fail "Recuperação não retornou HTTP 200: $status"
  ok 'Recuperação: HTTP 200 sem reiniciar backend nem PostgreSQL.'
}
case "$ACTION" in check) check ;; up) up ;; fault) fault ;; esac
