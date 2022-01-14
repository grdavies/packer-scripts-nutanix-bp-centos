#!/usr/bin/env bash
#
# Set Nutanix Best Practices
# Linux Disk Device Setting timout to 60
#

set -o errexit

# Update existing disks
lsscsi | grep NUTANIX | awk '{print $NF}' | awk -F"/" '{print $NF}' | grep -v "-" | while read LUN
do
  echo "NTNX: Setting /sys/block/${LUN}/device/timeout = 60"
  echo 60 > /sys/block/${LUN}/device/timeout
done

# Add command to /etc/rc.local to update UDEV rule for any newly added disks
echo "NTNX: Creating /etc/udev/rules.d/99-nutanix-disk_timeout.rules"
tee -a /etc/udev/rules.d/99-nutanix-disk_timeout.rules > /dev/null <<EOT
ACTION=="add", SUBSYSTEMS=="scsi", ATTRS{vendor}=="NUTANIX ", ATTRS{model}=="VDISK", RUN+="/bin/sh -c 'echo 60 >/sys$DEVPATH/device/timeout'"
EOT
