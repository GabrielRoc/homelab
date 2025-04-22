#!/bin/bash

TARGET_VM_IP="$1"
PARAM_TYPE="$2"
ANSIBLE_ARGS="$3"

HOMELAB_REPO_DIR="/home/gabriel/homelab"
ANSIBLE_DIR="$HOMELAB_REPO_DIR/ansible"

ANSIBLE_SSH_KEY="/home/gabriel/.ssh/ansible_node_key"
ANSIBLE_REMOTE_USER="gabriel"
LOG_FILE="/home/gabriel/ansible_pve_runs.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - VM $TARGET_VM_IP - $1" | tee -a $LOG_FILE
}

log "Recebido pedido. Tipo: $PARAM_TYPE, Args: $ANSIBLE_ARGS"

if [ -z "$TARGET_VM_IP" ] || [ -z "$PARAM_TYPE" ] || [ -z "$ANSIBLE_ARGS" ]; then
    log "ERRO: Argumentos inválidos recebidos."
    exit 1
fi

log "Navegando para $HOMELAB_REPO_DIR e atualizando..."
cd "$HOMELAB_REPO_DIR" || { log "ERRO: Não foi possível acessar o diretório $HOMELAB_REPO_DIR"; exit 1; }
git checkout main
git pull || { log "ERRO: Falha ao executar git pull."; exit 1; }

log "Navegando para o diretório Ansible: $ANSIBLE_DIR"
cd "$ANSIBLE_DIR" || { log "ERRO: Não foi possível acessar o diretório Ansible $ANSIBLE_DIR"; exit 1; }

ANSIBLE_CMD="ansible-playbook"
ANSIBLE_CMD+=" -i '$TARGET_VM_IP,'"
ANSIBLE_CMD+=" -u $ANSIBLE_REMOTE_USER"
ANSIBLE_CMD+=" --private-key $ANSIBLE_SSH_KEY"
export ANSIBLE_HOST_KEY_CHECKING=False

if [ "$PARAM_TYPE" == "playbooks" ]; then
    PLAYBOOK_PATHS=""
    for pb in $ANSIBLE_ARGS; do
        if [ -f "$pb" ]; then
             PLAYBOOK_PATHS+=" $pb"
        else
             log "AVISO: Playbook '$pb' não encontrado em $ANSIBLE_DIR."
        fi
    done
    if [ -z "$PLAYBOOK_PATHS" ]; then
        log "ERRO: Nenhum playbook válido especificado ou encontrado."
        exit 1
    fi
    ANSIBLE_CMD+="$PLAYBOOK_PATHS"

elif [ "$PARAM_TYPE" == "tags" ]; then
    ANSIBLE_CMD+=" playbook.yml"
    ANSIBLE_CMD+=" --tags '$ANSIBLE_ARGS'"
else
    log "ERRO: Tipo de parâmetro desconhecido: $PARAM_TYPE"
    exit 1
fi

log "Executando comando Ansible em $PWD: $ANSIBLE_CMD"

eval $ANSIBLE_CMD >> $LOG_FILE 2>&1

if [ $? -eq 0 ]; then
    log "Ansible executado com sucesso."
else
    log "ERRO: Falha na execução do Ansible. Verificar $LOG_FILE para detalhes."
    exit 1
fi

log "Configuração concluída."
exit 0