#!/usr/bin/env bash
#
# Set Nutanix Best Practices
# Disable Transparent Hugepages
#

set -o errexit

# Set transparent_hugepage=never in /etc/default/grub
echo "NTNX: Setting transparent_hugepage=never in /etc/default/grub"
grep -q "transparent_hugepage=" /etc/default/grub && sed "s/^transparent_hugepage=.*/transparent_hugepage=never/" -i /etc/default/grub || sed -i 's/GRUB_CMDLINE_LINUX="[^"]*/& transparent_hugepage=never/' /etc/default/grub
