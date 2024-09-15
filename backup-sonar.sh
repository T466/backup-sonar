#!/bin/bash

# Configurações
SOURCE_DIR="/opt/sonarqube"
BASE_DEST_DIR="/backup-sonar"
DATE_DIR=$(date +"%d%m%y")
DEST_DIR="${BASE_DEST_DIR}/backup-sonar-${DATE_DIR}"
LOG_FILE="/var/log/sonarqube_backup.log"

# Função para exibir mensagens de erro e sair
error_exit() {
    echo "$1" | tee -a "$LOG_FILE"
    exit 1
}

# Criar diretório de backup se não existir
if [ ! -d "$DEST_DIR" ]; then
    mkdir -p "$DEST_DIR" || error_exit "Falha ao criar o diretório de backup: $DEST_DIR"
fi

# Log de início do backup
echo "Iniciando backup do diretório $SOURCE_DIR para $DEST_DIR em $(date +"%Y-%m-%d %H:%M:%S")" | tee -a "$LOG_FILE"

# Executar rsync
rsync -a --delete "$SOURCE_DIR/" "$DEST_DIR/sonarqube/" >> "$LOG_FILE" 2>&1

# Verificar se rsync foi bem-sucedido
if [ $? -eq 0 ]; then
    echo "Backup concluído com sucesso em $(date +"%Y-%m-%d %H:%M:%S")" | tee -a "$LOG_FILE"
else
    error_exit "Falha no backup. Verifique o log para mais detalhes."
fi
