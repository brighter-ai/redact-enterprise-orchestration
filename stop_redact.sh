#!/bin/bash
set -o errexit
set -a
# systemd service provides installation_dir as an environment variable
installation_dir=${INSTALLATION_DIR}
if [ -z $installation_dir ]; then
    installation_dir="$(realpath '.')"
    export INSTALLATION_DIR="${installation_dir}"
fi
source "$installation_dir/docker-compose.env"
set +a

# start containers
export HOST_IP=$(hostname -I | awk '{print $1}')
docker compose -f "$installation_dir/docker-compose.yaml" down --remove-orphans
