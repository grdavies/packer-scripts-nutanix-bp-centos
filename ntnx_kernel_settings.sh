#!/usr/bin/env bash
##############################################################################
## Configure kernel settings to Nutanix best practices
##############################################################################
## Files modified
##
##############################################################################
## License
##
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 2 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License along
## with this program; if not, write to the Free Software Foundation, Inc.,
## 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
##############################################################################
## References
##
## Linux on Nutanix AHV Best Practices guide
## https://portal.nutanix.com/page/documents/solutions/details?targetId=BP-2105-Linux-on-AHV:BP-2105-Linux-on-AHV
##
##############################################################################
## Notes
##
##############################################################################

#timestamp
/usr/bin/echo "** ntnx_kernel_settings.sh START" $(date +%F-%H%M-%S)

#################
## SET BASH ERREXIT OPTION
#################
set -o errexit

##################
## SET VARIBLES
##################

BACKUPDIR=/root/NtnxBestPractices

#################
## BACKUP FILES
#################

if [ ! -d "${BACKUPDIR}" ]; then mkdir -p ${BACKUPDIR}; fi

#################
## BACKUP FILES
#################

if [ ! -d "${BACKUPDIR}" ]; then mkdir -p ${BACKUPDIR}; fi

/bin/cp -fpd /proc/sys/vm/overcommit_memory ${BACKUPDIR}/sys_vm_overcommit_memory-DEFAULT
/bin/cp -fpd /proc/sys/vm/dirty_background_ratio ${BACKUPDIR}/sys_vm_dirty_background_ratio-DEFAULT
/bin/cp -fpd /proc/sys/vm/dirty_ratio ${BACKUPDIR}/sys_vm_dirty_ratio-DEFAULT
/bin/cp -fpd /proc/sys/vm/dirty_expire_centisecs ${BACKUPDIR}/sys_vm_dirty_expire_centisecs-DEFAULT
/bin/cp -fpd /proc/sys/vm/dirty_writeback_centisecs ${BACKUPDIR}/sys_vm_dirty_writeback_centisecs-DEFAULT
/bin/cp -fpd /proc/sys/vm/swappiness ${BACKUPDIR}/sys_vm_swappiness-DEFAULT

#################
## UPDATE CONFIGURATION
#################

/usr/bin/echo 1 > /proc/sys/vm/overcommit_memory
/usr/bin/echo 5 > /proc/sys/vm/dirty_background_ratio
/usr/bin/echo 15 > /proc/sys/vm/dirty_ratio
/usr/bin/echo 500 > /proc/sys/vm/dirty_expire_centisecs
/usr/bin/echo 100 > /proc/sys/vm/dirty_writeback_centisecs
/usr/bin/echo 0 > /proc/sys/vm/swappiness

#################
## SAVE KERNEL SETTINGS
#################
/usr/sbin/sysctl -p

#timestamp
/usr/bin/echo "** ntnx_kernel_settings.sh COMPLETE" $(date +%F-%H%M-%S)
