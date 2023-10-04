#!/bin/bash
set -o errexit
set -a

# check systemd
min_systemd_version=245
if [ $(systemd --version | grep -oE 'systemd [0-9]+' | grep -oE '[0-9]+') -lt "$min_systemd_version" ]; then
    echo "Please make sure you have Systemd version $min_systemd_version or greater installed."
    exit 1
fi

# check installation directories
installation_dir=$1
if [ -z "$installation_dir" ]; then
    echo "Please provide an installtion directory with './install.sh /path/to/installation'"
    exit 1
fi

systemctl stop redact.service

# remove installation files
rm -rf $installation_dir/redact
rm /etc/systemd/system/redact.service
rm -rf /etc/systemd/system/redact.service.d

# reload systemd daemon
systemctl daemon-reload
