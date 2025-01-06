#!/bin/bash

# Exit on error
set -e

# Check for root privileges
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root." >&2
  exit 1
fi

# Function to print usage
usage() {
  echo "Usage: $0 -d <disk1,disk2,...> -m <mount_point>"
  echo "  -d   Comma-separated list of disks (e.g., /dev/sdb,/dev/sdc)"
  echo "  -m   Mount point for the RAID array (e.g., /mnt/raid)"
  exit 1
}

# Parse arguments
while getopts "d:m:" opt; do
  case $opt in
    d) DISKS="$OPTARG" ;;
    m) MOUNT_POINT="$OPTARG" ;;
    *) usage ;;
  esac
done

# Validate arguments
if [[ -z "$DISKS" || -z "$MOUNT_POINT" ]]; then
  usage
fi

# Convert comma-separated disks to space-separated for RAID creation
DISK_LIST=$(echo "$DISKS" | tr ',' ' ')

# Create the RAID array
# Find the next available RAID device
RAID_DEVICE=$(ls /dev/md* 2>/dev/null | sort | tail -n 1)
if [[ -z "$RAID_DEVICE" ]]; then
  RAID_DEVICE="/dev/md0"
else
  RAID_DEVICE="/dev/md$(( $(echo $RAID_DEVICE | grep -o '[0-9]*$') + 1 ))"
fi

echo "Using RAID device: $RAID_DEVICE"

echo "Creating RAID array on: $DISK_LIST"
mdadm --create --verbose $RAID_DEVICE --level=0 --raid-devices=$(echo "$DISK_LIST" | wc -w) $DISK_LIST

# Save the RAID configuration
echo "Saving RAID configuration..."
mdadm --detail --scan >> /etc/mdadm/mdadm.conf
update-initramfs -u

# Create a filesystem on the RAID array
echo "Creating filesystem on $RAID_DEVICE..."
mkfs.ext4 $RAID_DEVICE

# Create the mount point if it doesn't exist
if [[ ! -d "$MOUNT_POINT" ]]; then
  echo "Creating mount point: $MOUNT_POINT"
  mkdir -p "$MOUNT_POINT"
fi

# Mount the RAID array
echo "Mounting $RAID_DEVICE to $MOUNT_POINT..."
mount $RAID_DEVICE $MOUNT_POINT

# Add to /etc/fstab
echo "Adding $RAID_DEVICE to /etc/fstab..."
UUID=$(blkid -s UUID -o value $RAID_DEVICE)
echo "UUID=$UUID $MOUNT_POINT ext4 defaults,nofail 0 0" >> /etc/fstab

systemctl daemon-reload

echo "RAID array successfully created, mounted, and added to /etc/fstab."