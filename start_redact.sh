#!/bin/bash
set -o errexit
set -a
installation_dir=${INSTALLATION_DIR}
if [ -z $installation_dir ]; then
    installation_dir=$(realpath ".")
    export INSTALLATION_DIR=${installation_dir}
fi
source $installation_dir/docker-compose.env
set +a

while getopts "ud" opt; do
    case $opt in
        u) ui="SET"
        ;;
        d) detach="SET"
        ;;
    esac
done

# check license file
if [ ! -f $installation_dir/${REDACT_LICENSE_FILE} ]; then
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
if [ -v detach ]; then
    args="${args} -d"
fi

export HOST_IP=$(hostname -I | awk '{print $1}')
docker compose -f $installation_dir/docker-compose.yaml up ${args} ${services}

if [ -v detach ]; then
    # print some urls
    echo "redact API running at http://${HOST_IP}:${REDACT_API_PORT}"
    if [ ${ui+x} ]; then
        echo "redact UI  running at http://${HOST_IP}:${REDACT_UI_PORT}/ui";
        echo "redact SRA running at http://${HOST_IP}:${REDACT_UI_PORT}/sra";
    fi
fi
