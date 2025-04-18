#!/bin/bash
# SPDX-FileCopyrightText: 2021-2024 Brighter AI Technologies GmbH
# SPDX-License-Identifier: MIT

set -o errexit
set -a

# check systemd
min_systemd_version=245
if [ $(systemd --version | grep -oE 'systemd [0-9]+' | grep -oE '[0-9]+') -lt "$min_systemd_version" ]; then
    echo "Please make sure you have Systemd version $min_systemd_version or greater installed."
    exit 1
fi

# check docker
min_docker_version=24
if [ $(docker --version | grep -oE 'Docker version [0-9]+' | grep -oE '[0-9]+') -lt "$min_docker_version" ]; then
    echo "Please make sure you have Docker version $min_docker_version or greater installed."
    exit 1
fi

# check installation directories
installation_dir="$1"
if [ -z "$installation_dir" ]; then
    echo "Please provide an installtion directory with './install.sh /path/to/installation'"
    exit 1
fi

if [ -f "/etc/systemd/system/redact.service" ]; then
    echo "A Redact service is already installed. Please remove it and install again."
    exit 1
fi

# copy license and external files
mkdir "$installation_dir"
cp docker-compose.env "$installation_dir"
cp high-throughput.env "$installation_dir"
cp docker-compose.yaml "$installation_dir"
cp license.bal "$installation_dir"
cp start_redact.sh "$installation_dir"
cp stop_redact.sh "$installation_dir"

# put unit files in directories
cp redact.service /etc/systemd/system/
mkdir /etc/systemd/system/redact.service.d
printf "[Service]\nEnvironment=\"INSTALLATION_DIR=$installation_dir\"" > /etc/systemd/system/redact.service.d/override.conf

# reload systemd daemon
systemctl daemon-reload
