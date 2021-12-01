#!/bin/bash
set -o errexit
set -o nounset

docker stop redact-infer redact-pipeline redact-utils
docker rm redact-infer redact-pipeline redact-utils
