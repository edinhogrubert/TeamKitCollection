#!/usr/bin/env bash
set -e

VM_NAME="container"
VM_USER="ubuntu"
VM_RAM="6144"      # 6 GB em MB
VM_CPUS="4"
VM_DISK_MB="30720" # 30 GB em MB
SSH_PORT="2222"
DOWNLOADS_DIR="/home/grubert/Downloads"
VM_BASE_DIR="$HOME/VirtualBox VMs/$VM_NAME"

# 1. Busca automática da imagem (.iso ou .img) do Ubuntu em Downloads
IMAGE_PATH=$(find "$DOWNLOADS_DIR" -maxdepth 1 -type f \( -iname "*ubuntu*.iso" -o -iname "*ubuntu*.img" \) | head -n 1)

if [ -z "$IMAGE_PATH" ]; then
    echo "Erro: Nenhuma imagem Ubuntu (.iso ou .img) encontrada em $DOWNLOADS_DIR"
    exit 1
fi

echo "Imagem encontrada: $IMAGE_PATH"

# Se terminar em .img, cria um link simbólico .iso para o VirtualBox aceitar no boot
if [[ "$IMAGE_PATH" == *.img ]]; then
    ISO_LINK="/tmp/${VM_NAME}_install.iso"
    ln -sf "$IMAGE_PATH" "$ISO_LINK"
    IMAGE_PATH="$ISO_LINK"
fi

# 2. Solicita a senha de forma oculta no terminal
read -s -p "Digite a senha para o usuário '$VM_USER' na VM: " VM_PASS
echo ""
read -s -p "Confirme a senha: " VM_PASS_CONFIRM
echo ""

if [ "$VM_PASS" != "$VM_PASS_CONFIRM" ] || [ -z "$VM_PASS" ]; then
    echo "Erro: As senhas não coincidem ou estão vazias."
    exit 1
fi

# 3. Remove VM anterior com mesmo nome (caso esteja recriando do zero)
if VBoxManage list vms | grep -q "\"$VM_NAME\""; then
    echo "Removendo VM existente '$VM_NAME'..."
    VBoxManage controlvm "$VM_NAME" poweroff 2>/dev/null || true
    sleep 2
    VBoxManage unregistervm "$VM_NAME" --delete
fi

# 4. Cria e registra a VM
echo "Criando VM '$VM_NAME' ($VM_RAM MB RAM, $VM_CPUS CPUs)..."
VBoxManage createvm --name "$VM_NAME" --ostype "Ubuntu_64" --register

# 5. Configura Hardware, Rede NAT e Redirecionamento SSH (2222 -> 22)
VBoxManage modifyvm "$VM_NAME" \
    --memory "$VM_RAM" \
    --cpus "$VM_CPUS" \
    --vram 16 \
    --graphicscontroller vmsvga \
    --ioapic on \
    --rtcuseutc on \
    --boot1 dvd --boot2 disk --boot3 none --boot4 none \
    --nic1 nat \
    --natpf1 "ssh,tcp,,${SSH_PORT},,22"

# 6. Cria Disco Virtual e Controladora SATA
mkdir -p "$VM_BASE_DIR"
DISK_PATH="$VM_BASE_DIR/${VM_NAME}.vdi"
VBoxManage createmedium disk --filename "$DISK_PATH" --size "$VM_DISK_MB" --format VDI

VBoxManage storagectl "$VM_NAME" --name "SATA" --add sata --controller IntelAhci
VBoxManage storageattach "$VM_NAME" --storagectl "SATA" --port 0 --device 0 --type hdd --medium "$DISK_PATH"

# 7. Configura Instalação Desassistida (Unattended) com usuário, senha e OpenSSH
echo "Configurando instalação automática (usuário: $VM_USER)..."
VBoxManage unattended install "$VM_NAME" \
    --iso="$IMAGE_PATH" \
    --user="$VM_USER" \
    --password="$VM_PASS" \
    --full-user-name="$VM_USER" \
    --hostname="${VM_NAME}.local" \
    --time-zone="America/Sao_Paulo" \
    --install-additions \
    --package-selection-adjustment=minimal

# 8. Inicia a VM em segundo plano (headless)
echo "Iniciando a VM '$VM_NAME' em segundo plano..."
VBoxManage startvm "$VM_NAME" --type headless

echo "=================================================================="
echo "VM '$VM_NAME' criada e iniciada!"
echo "Aguarde cerca de 5 a 8 minutos para a instalação automática concluir."
echo "Depois, acesse via SSH com:"
echo "  ssh -p $SSH_PORT $VM_USER@localhost"
echo "=================================================================="
