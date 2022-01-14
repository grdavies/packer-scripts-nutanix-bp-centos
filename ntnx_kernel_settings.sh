#!/usr/bin/env bash
#
# Set Nutanix Best Practices
# Kernel Settings
#

set -o errexit

echo "NTNX: Setting /proc/sys/vm/overcommit_memory = 1"
echo 1 > /proc/sys/vm/overcommit_memory

echo "NTNX: Setting /proc/sys/vm/dirty_background_ratio = 5"
echo 5 > /proc/sys/vm/dirty_background_ratio

echo "NTNX: Setting /proc/sys/vm/dirty_ratio = 15"
echo 15 > /proc/sys/vm/dirty_ratio

echo "NTNX: Setting /proc/sys/vm/dirty_expire_centisecs = 500"
echo 500 > /proc/sys/vm/dirty_expire_centisecs

echo "NTNX: Setting /proc/sys/vm/dirty_writeback_centisecs = 100"
echo 100 > /proc/sys/vm/dirty_writeback_centisecs

echo "NTNX: Setting /proc/sys/vm/swappiness = 0"
echo 0 > /proc/sys/vm/swappiness

# Save Settings
sysctl -p
