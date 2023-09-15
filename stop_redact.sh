#!/bin/bash
set -o errexit
set -o nounset
set -a
source ${INSTALLATION_DIR}/docker-compose.env
set +a

# start containers
export HOST_IP=$(hostname -I | awk '{print $1}')
docker compose -f ${INSTALLATION_DIR}/docker-compose.yaml down --remove-orphans
