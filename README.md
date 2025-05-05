# Geth, Lighthouse, and Base Setup via Docker Compose

This repository provides a streamlined setup to deploy Geth, Lighthouse, and Base services using Docker Compose. The configurations are designed to facilitate running and managing Ethereum-based nodes efficiently in a containerized environment.

## Features
- **Geth**: Ethereum client for handling full-node or archive-node functionalities.
- **Lighthouse**: Ethereum consensus client for managing Beacon Chain operations.
- **Base**: Provides the infrastructure for rollups and L2 networks.

## Requirements
Ensure your system meets the following prerequisites:

- **Operating System**: Linux
- **Docker**: Version 20.x or higher
- **Docker Compose**: Version 2.x or higher
- **Git**: Installed and configured


## folder layout:

- /dev/md0 (raided disk for example) mount onto /mnt/disk0
- /dev/md1 (raided disk for example) mount onto /mnt/disk1
- then we mount bind folder in those disks to /opt
- for example /mnt/disk0/data /opt/data
- but we can do it more complicated once there are more blockchain nodes using multiple disks.
