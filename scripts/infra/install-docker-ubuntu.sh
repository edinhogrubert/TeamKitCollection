#!/usr/bin/env bash
# TeamKitCollection — preparação do Docker para o laboratório Ubuntu 24.04.
# Uso: bash install-docker-ubuntu.sh [--check|--install]
# --check é o padrão e não altera o sistema.
# --install exige decisão humana e instala Docker Engine + Compose Plugin.
# Não cria containers, volumes, redes, swap ou regras de firewall.
set -Eeuo pipefail

on_error() {
  printf '[ERRO] Falha na linha %s (status %s). Nenhum container foi iniciado por este script.\n' "$2" "$1" >&2
}
trap 'on_error "$?" "$LINENO"' ERR

usage() {
  printf 'Uso: bash %s [--check|--install]\n' "${0##*/}"
}
mode="${1:---check}"
if [[ $# -gt 1 ]] || [[ "$mode" != "--check" && "$mode" != "--install" ]]; then
  usage >&2
  exit 2
fi
if [[ ! -r /etc/os-release ]]; then
  echo '[ERRO] /etc/os-release indisponível.' >&2
  exit 1
fi
# shellcheck disable=SC1091
. /etc/os-release
if [[ "${ID:-}" != ubuntu || "${VERSION_ID:-}" != 24.04 ]]; then
  printf '[ERRO] Suportado somente Ubuntu 24.04; detectado: %s %s.\n' "${ID:-?}" "${VERSION_ID:-?}" >&2
  exit 1
fi
if ! command -v apt-get >/dev/null || ! command -v dpkg-query >/dev/null; then
  echo '[ERRO] apt/dpkg não disponíveis.' >&2
  exit 1
fi

is_installed() {
  [[ "$(dpkg-query -W -f='${db:Status-Abbrev}' "$1" 2>/dev/null || true)" == ii* ]]
}
conflicts=(docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc)
check_conflicts() {
  local package
  for package in "${conflicts[@]}"; do
    if is_installed "$package"; then
      printf '[BLOQUEADO] Pacote conflitante instalado: %s. Não remover automaticamente.\n' "$package" >&2
      return 1
    fi
  done
}

echo "[INFO] SO: $PRETTY_NAME; arquitetura: $(dpkg --print-architecture)"
if command -v docker >/dev/null 2>&1; then
  docker --version
  docker compose version 2>/dev/null || echo '[INFO] Docker Compose Plugin não disponível.'
else
  echo '[INFO] Docker ainda não instalado.'
fi
if [[ "$mode" == "--check" ]]; then
  if check_conflicts; then
    echo '[OK] Nenhum pacote conflitante conhecido foi encontrado.'
  else
    echo '[ATENÇÃO] Resolver conflitos antes de instalar.'
  fi
  if command -v systemctl >/dev/null; then
    systemctl is-active docker 2>/dev/null || true
  fi
  echo '[INFO] Diagnóstico concluído. Nenhuma alteração realizada.'
  exit 0
fi

check_conflicts
if command -v docker >/dev/null && ! is_installed docker-ce; then
  echo '[BLOQUEADO] Existe outro Docker no PATH. Verifique origem antes de instalar.' >&2
  exit 1
fi
if ! command -v sudo >/dev/null; then
  echo '[ERRO] sudo não disponível; instalação não iniciada.' >&2
  exit 1
fi
sudo -v
echo '[ETAPA 1/3] Dependências e chave do repositório oficial Docker'
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
tmp_key="$(mktemp)"
trap 'rm -f "${tmp_key:-}"' EXIT
curl --fail --show-error --silent --location --proto '=https' --tlsv1.2 \
  https://download.docker.com/linux/ubuntu/gpg -o "$tmp_key"
test -s "$tmp_key"
sudo install -m 0644 "$tmp_key" /etc/apt/keyrings/docker.asc

echo '[ETAPA 2/3] Registro do repositório Docker para Ubuntu 24.04'
arch="$(dpkg --print-architecture)"
printf 'Types: deb\nURIs: https://download.docker.com/linux/ubuntu\nSuites: noble\nComponents: stable\nArchitectures: %s\nSigned-By: /etc/apt/keyrings/docker.asc\n' "$arch" \
  | sudo tee /etc/apt/sources.list.d/docker.sources >/dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo '[ETAPA 3/3] Verificação do Docker e Compose'
sudo systemctl enable --now docker
docker --version
docker compose version
sudo docker info --format 'Docker Engine servidor: {{.ServerVersion}}'
echo '[OK] Docker Engine e Compose instalados. Nenhum container de teste foi criado.'
echo '[INFO] Usuário não foi adicionado ao grupo docker. Use sudo para operações administrativas.'
