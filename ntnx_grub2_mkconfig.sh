#!/usr/bin/env bash
#
# Set Nutanix Best Practices
# Set elevator to noop
#

set -o errexit

# Update grub2
grub2-mkconfig –o /boot/grub2/grub.cfg 2> /dev/null
