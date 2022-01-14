#!/usr/bin/env bash
#
# Set Nutanix Best Practices
# Set elevator to noop
#

set -o errexit

# Update existing disks
lsscsi | grep NUTANIX | awk '{print $NF}' | awk -F"/" '{print $NF}' | grep -v "-" | while read LUN
do
  echo "NTNX: Setting /sys/block/${LUN}/queue/scheduler = noop"
  echo noop > /sys/block/${LUN}/queue/scheduler
done

# Set elevator=noop in /etc/default/grub
echo "NTNX: Setting elevator=noop in /etc/default/grub"
grep -q "elevator=" /etc/default/grub && sudo sed "s/^elevator=.*/elevator=noop/" -i /etc/default/grub || sudo sed -i 's/GRUB_CMDLINE_LINUX="[^"]*/& elevator=noop/' /etc/default/grub
