#!/usr/bin/env bash
##############################################################################
## Set elevator to noop to meet Nutanix best practices
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
/usr/bin/echo "** ntnx_set_noop.sh START" $(date +%F-%H%M-%S)

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

/bin/cp -fpd /etc/default/grub ${BACKUPDIR}/grub-DISABLE-NOOP

#################
## BACKUP FILES
#################

if [ ! -d "${BACKUPDIR}" ]; then mkdir -p ${BACKUPDIR}; fi

#################
## UPDATE GRUB
#################
/usr/bin/grep -q "elevator=" /etc/default/grub && /usr/bin/sed "s/^elevator=.*/elevator=noop/" -i /etc/default/grub || /usr/bin/sed -i 's/GRUB_CMDLINE_LINUX="[^"]*/& elevator=noop/' /etc/default/grub

##################
## UPDATE ANY EXISTING DISKS
##################
lsscsi | grep NUTANIX | awk '{print $NF}' | awk -F"/" '{print $NF}' | grep -v "-" | while read LUN
do
  /usr/bin/echo noop > /sys/block/${LUN}/queue/scheduler
done

##################
## REBUILD GRUB CONFIG
##################
/usr/sbin/grub2-mkconfig –o /boot/grub2/grub.cfg 2> /dev/null

#timestamp
/usr/bin/echo "** ntnx_set_noop.sh COMPLETE" $(date +%F-%H%M-%S)
