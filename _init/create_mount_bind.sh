#!/bin/bash

# Exit on error
set -e

# Check for root privileges
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root." >&2
  exit 1
fi

# Check if the source and target directories are provided
if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <source_dir> <target_dir>"
  echo "Example: $0 /mnt/disk0/data /opt/data"
  exit 1
fi

SOURCE_DIR="$1"
TARGET_DIR="$2"

# Create the directories if they don't exist
echo "Ensuring directories exist..."
mkdir -p "$SOURCE_DIR"
mkdir -p "$TARGET_DIR"

# Mount the source directory to the target directory
echo "Creating bind mount from $SOURCE_DIR to $TARGET_DIR..."
mount --bind "$SOURCE_DIR" "$TARGET_DIR"

# Add the bind mount to /etc/fstab if not already present
echo "Adding bind mount to /etc/fstab..."
if ! grep -q "^[[:space:]]*$SOURCE_DIR[[:space:]]*$TARGET_DIR[[:space:]]*bind" /etc/fstab; then
  echo "$SOURCE_DIR $TARGET_DIR none bind 0 0" >> /etc/fstab
else
  echo "Bind mount already exists in /etc/fstab."
fi

# Reload systemd daemon to apply changes
echo "Reloading system daemon..."
systemctl daemon-reload

echo "Bind mount created successfully and added to /etc/fstab."