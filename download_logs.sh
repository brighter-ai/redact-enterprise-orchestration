#!/bin/bash

# Copyright (c) 2017-2025 Brighter AI Technologies GmbH. All rights reserved.
# Unauthorized use, copying, reproduction, or distribution of this file, via any medium,
# is strictly prohibited.

set -o errexit
set -o nounset
set -a
source docker-compose.env
export HOST_IP=$(hostname -I | awk '{print $1}')
set +a

curl "http://${HOST_IP}:${REDACT_API_PORT}/services/v3/errorlog" --output redact_logs.zip
