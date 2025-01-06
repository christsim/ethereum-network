#!/bin/bash

# Exit on error
set -e

# Check for root privileges
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root." >&2
  exit 1
fi

apt update && apt upgrade
apt install docker-compose btop