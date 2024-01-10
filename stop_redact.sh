#!/bin/bash
# SPDX-FileCopyrightText: 2021-2024 Brighter AI Technologies GmbH
# SPDX-License-Identifier: MIT

set -o errexit
set -a
# systemd service provides installation_dir as an environment variable
if [ -z ${INSTALLATION_DIR} ]; then
    installation_dir="$(realpath '.')"
    export INSTALLATION_DIR="${installation_dir}"
else
    installation_dir="$INSTALLATION_DIR"
fi
source "$installation_dir/docker-compose.env"
set +a

# start containers
export HOST_IP=$(hostname -I | awk '{print $1}')
docker compose -f "$installation_dir/docker-compose.yaml" down --remove-orphans
