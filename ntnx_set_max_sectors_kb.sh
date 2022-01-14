#!/usr/bin/env bash
#
# Set Nutanix Best Practices
# Linux Disk Device Setting max_sectors_kb to 1024
#

set -o errexit

# Update existing disks
lsscsi | grep NUTANIX | awk '{print $NF}' | awk -F"/" '{print $NF}' | grep -v "-" | while read LUN
do
  echo "NTNX: Setting /sys/block/${LUN}/queue/max_sectors_kb = 1024"
  echo 1024 > /sys/block/${LUN}/queue/max_sectors_kb
done

# Add command to /etc/rc.local to update UDEV rule for any newly added disks
echo "NTNX: Creating /etc/udev/rules.d/99-nutanix-max_sectors_kb.rules"
tee -a /etc/udev/rules.d/99-nutanix-max_sectors_kb.rules > /dev/null <<EOT
ACTION=="add", SUBSYSTEMS=="scsi", ATTRS{vendor}=="NUTANIX ", ATTRS{model}=="VDISK", RUN+="/bin/sh -c 'echo 1024 >/sys$DEVPATH/queue/max_sectors_kb'"
EOT
