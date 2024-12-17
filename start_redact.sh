#!/bin/bash
# SPDX-FileCopyrightText: 2021-2024 Brighter AI Technologies GmbH
# SPDX-License-Identifier: MIT

set -o errexit
# enable automatic EXPORT of all vars defined or sourced after this line
set -a
# systemd service provides installation_dir as an environment variable
if [ -z ${INSTALLATION_DIR} ]; then
    installation_dir="$(realpath '.')"
    export INSTALLATION_DIR="${installation_dir}"
else
    installation_dir="$INSTALLATION_DIR"
fi
source "$installation_dir/docker-compose.env"

while getopts "uah" opt; do
    case $opt in
        u) ui="SET"
        ;;
        a) attach="SET"
        ;;
        h) source "$installation_dir/high-throughput.env"
        ;;
    esac
done

# turn of automatic exporting of env vars defined or sourced from env files after this line.
# Variables already sourced, like from source ... docker-compose.env above, will remain exported.
set +a

# check license file
if [ ! -f "$installation_dir/${REDACT_LICENSE_FILE}" ]; then
    echo "Please make sure that license file with path \"$installation_dir/${REDACT_LICENSE_FILE}\" exists."
    exit 1
fi

# select the container names based on the -u flag
container_name="${REDACT_CONTAINER_NAME} ${REDACT_GPU_CONTAINER_NAME}"
if [ ${ui+x} ]; then
    container_name="${container_name} ${REDACT_UTILS_CONTAINER_NAME}";
fi

# make sure there aren't any containers with the same names yet
for container in ${container_name}; do
    if [ $(docker ps -a -q -f name="^${container}$") ]; then
        echo "A Container with the name '${container}' already exists please make sure to remove it before starting a new one."
        echo "If you intend to start a seperate instance please choose a differnt container name in the env file."
        exit 1
    fi
done

# start containers
# select what services to start depending on the -u flag
services="redact redact-gpu"
if [ ${ui+x} ]; then
    services="${services} redact-utils";
fi

args="--force-recreate --remove-orphans"
if [ ! -v attach ]; then
    args="${args} -d"
fi

export HOST_IP=$(hostname -I | awk '{print $1}')
docker compose -f "$installation_dir/docker-compose.yaml" up ${args} ${services}

if [ ! -v attach ]; then
    # print some urls
    echo "redact API running at http://${HOST_IP}:${REDACT_API_PORT}"
    if [ ${ui+x} ]; then
        echo "redact UI  running at http://${HOST_IP}:${REDACT_UI_PORT}/ui";
        echo "redact SRA running at http://${HOST_IP}:${REDACT_UI_PORT}/sra";
    fi
fi
