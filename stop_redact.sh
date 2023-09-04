#!/bin/bash
set -o errexit
set -o nounset
set -a
source docker-compose.env
set +a

# start containers
export HOST_IP=$(hostname -I | awk '{print $1}')
docker compose down --remove-orphans
