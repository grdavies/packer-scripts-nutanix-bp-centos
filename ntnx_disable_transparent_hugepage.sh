#!/usr/bin/env bash
##############################################################################
## Disable Transparent Hugepages to meet Nutanix best practices
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
/usr/bin/echo "** ntnx_disable_transparent_hugepage.sh START" $(date +%F-%H%M-%S)

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

/bin/cp -fpd /etc/default/grub ${BACKUPDIR}//etc/default/grub-DISABLE-THP

#################
## UPDATE FILES
#################
/usr/bin/grep -q "transparent_hugepage=" /etc/default/grub && sed "s/^transparent_hugepage=.*/transparent_hugepage=never/" -i /etc/default/grub || sed -i 's/GRUB_CMDLINE_LINUX="[^"]*/& transparent_hugepage=never/' /etc/default/grub

##################
## REBUILD GRUB CONFIG
##################
/usr/sbin/grub2-mkconfig –o /boot/grub2/grub.cfg 2> /dev/null

#timestamp
/usr/bin/echo "** ntnx_disable_transparent_hugepage.sh COMPLETE" $(date +%F-%H%M-%S)
