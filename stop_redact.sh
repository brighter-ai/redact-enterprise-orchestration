#!/bin/bash
set -o errexit
set -o nounset
set -a
installation_dir=${INSTALLATION_DIR}
if [ -z $installation_dir ]; then
    installation_dir="."
fi
source $installation_dir/docker-compose.env
set +a

# start containers
export HOST_IP=$(hostname -I | awk '{print $1}')
docker compose -f $installation_dir/docker-compose.yaml down --remove-orphans
