#!/bin/bash
set -o errexit
set -o nounset

#-----------------------------------------------------------------------

export REDACT_PIPELINE_IMAGE="brighter.azurecr.io/redact:v4.3.0-246"
export REDACT_INFER_IMAGE="brighter.azurecr.io/redact-infer:1.2.0"
export REDACT_UTILS_IMAGE="brighter.azurecr.io/redact-utils:0.12.2"

export REDACT_API_PORT=8787
export REDACT_UI_PORT=8786

export REDACT_LICENSE_FILE="./license.bal"

#-----------------------------------------------------------------------

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
