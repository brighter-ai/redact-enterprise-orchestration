#!/bin/bash
set -o errexit
set -o nounset

# start containers
docker-compose down --remove-orphans
