#!/usr/bin/env bash
# TeamKitCollection — PostgreSQL 16 no Docker, SOMENTE laboratório local.
# Uso: bash postgres16-lab.sh [--check|--start]
# --check (padrão): apenas leitura, nenhuma alteração.
# --start: FUTURO, somente com autorização humana ESPECÍFICA para criar recursos.
# Publicação deste script não autoriza executá-lo com --start.
# Nunca usa portas publicadas, não remove volumes e não modifica firewall.
set -Eeuo pipefail

MODE="${1:---check}"
if [[ $# -gt 1 || ( "$MODE" != "--check" && "$MODE" != "--start" ) ]]; then
  echo "Uso: bash ${0##*/} [--check|--start]" >&2
  exit 2
fi

CONTAINER="tkc-postgres16"
VOLUME="tkc-postgres16-data"
IMAGE="postgres:16"
ENV_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/teamkitcollection/postgres16.env"

die() { printf '[BLOQUEADO] %s\n' "$*" >&2; exit 1; }
info() { printf '[INFO] %s\n' "$*"; }
on_error() {
  printf '[ERRO] Linha %s; código %s. Recursos já criados foram preservados para inspeção.\n' "$2" "$1" >&2
}
trap 'on_error "$?" "$LINENO"' ERR

command -v docker >/dev/null 2>&1 || die 'Docker não está instalado.'
docker compose version >/dev/null 2>&1 || die 'Docker Compose Plugin não está disponível.'
info "Imagem planejada: $IMAGE (tag flutuante da versão 16; resolver e revisar digest antes de uso operacional)."
info "Container: $CONTAINER; volume persistente: $VOLUME"
info 'Sem publicação da porta 5432 no host. Ambiente de laboratório, não produção.'

# Consultar Docker sem privilégios persistentes: sudo somente para comandos Docker.
if [[ "$MODE" == "--check" ]]; then
  if ! sudo -n docker info --format 'Docker Engine: {{.ServerVersion}}' 2>/dev/null; then
    info 'Sem consulta ao daemon via sudo não interativo. Se necessário, valide Docker separadamente.'
    exit 0
  fi
  sudo -n docker ps -a --filter "name=^/${CONTAINER}$" --format 'Container: {{.Names}} | estado: {{.Status}}'
  if sudo -n docker volume inspect "$VOLUME" >/dev/null 2>&1; then
    info 'Volume persistente já existe; nenhuma alteração realizada.'
  else
    info 'Volume persistente ainda não existe.'
  fi
  if [[ -f "$ENV_FILE" ]]; then
    info 'Arquivo de credenciais local já existe (conteúdo não exibido).'
  else
    info 'Arquivo de credenciais local ainda não existe.'
  fi
  info 'Diagnóstico finalizado. Nenhum container, volume ou credencial criado.'
  exit 0
fi

# A partir daqui: ALTERA o daemon Docker e o filesystem local. NÃO EXECUTAR
# sem nova autorização humana para POSTGRESQL 16 na VM Container.
[[ "$EUID" -ne 0 ]] || die 'Execute como usuário normal com sudo disponível, não como root.'
command -v openssl >/dev/null 2>&1 || die 'openssl é obrigatório para gerar senha local.'
sudo -v
sudo docker info >/dev/null

# Evitar colisão, recriação ou adoção silenciosa de dados existentes.
if [[ -n "$(sudo docker ps -a --filter "name=^/${CONTAINER}$" --format '{{.ID}}')" ]]; then
  die "Container $CONTAINER já existe; não sobrescrever nem recriar."
fi
if sudo docker volume inspect "$VOLUME" >/dev/null 2>&1; then
  die "Volume $VOLUME já existe; preservado. Exige avaliação antes de reutilizar."
fi
if [[ -e "$ENV_FILE" ]]; then
  die "Arquivo $ENV_FILE já existe; não sobrescrever credenciais."
fi

# Segredos são criados SOMENTE na VM, sem Git e sem saída em terminal.
umask 077
install -d -m 0700 "$(dirname "$ENV_FILE")"
PASSWORD="$(openssl rand -hex 32)"
{
  printf 'POSTGRES_USER=tkc_app\n'
  printf 'POSTGRES_DB=teamkitcollection\n'
  printf 'POSTGRES_PASSWORD=%s\n' "$PASSWORD"
} > "$ENV_FILE"
unset PASSWORD
chmod 0600 "$ENV_FILE"
info 'Credenciais locais criadas com permissões restritas; valor não exibido.'

# tag postgres:16 deliberadamente identificada acima; confirmar imagem/digest antes
# de autorização de execução, conforme SEC-005.
info 'Criando volume e iniciando PostgreSQL (sem portas publicadas)...'
sudo docker volume create "$VOLUME" >/dev/null
sudo docker run -d \
  --name "$CONTAINER" \
  --restart unless-stopped \
  --memory 1g \
  --cpus 2 \
  --env-file "$ENV_FILE" \
  --mount "type=volume,source=${VOLUME},target=/var/lib/postgresql/data" \
  "$IMAGE" >/dev/null

info 'Container criado. Verifique saúde e logs sanitizados antes de declarar pronto.'
info "Status: sudo docker ps -a --filter name=$CONTAINER"
info "Health: sudo docker exec $CONTAINER pg_isready -U tkc_app -d teamkitcollection"
info 'A persistência exige teste explícito de reinício com autorização apropriada.'
