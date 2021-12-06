#!/bin/bash
set -o errexit
set -o nounset
set -a
source docker-compose.env
set +a

# check license file
if [ ! -f ${REDACT_LICENSE_FILE} ]; then
    echo "Please make sure that license file with path \"${REDACT_LICENSE_FILE}\" exists."
    exit 1
fi

# start containers
export HOST_IP=$(hostname -I | awk '{print $1}')
docker-compose -f docker-compose.yaml up --force-recreate -d --remove-orphans

# print some urls
echo "redact API running at http://${HOST_IP}:${REDACT_API_PORT}"
echo "redact UI  running at http://${HOST_IP}:${REDACT_UI_PORT}/ui"
echo "redact SRA running at http://${HOST_IP}:${REDACT_UI_PORT}/sra"
