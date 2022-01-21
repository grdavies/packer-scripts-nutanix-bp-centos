#!/usr/bin/env bash
##############################################################################
## Configure each disk max_sectors_kb to Nutanix best practices
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
/usr/bin/echo "** ntnx_set_max_sectors_kb.sh START" $(date +%F-%H%M-%S)

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

##################
## CREATE UDEV RULE
##################
/usr/bin/cat > ${BACKUPDIR}/99-nutanix-max_sectors_kb.rules << 'EOFUDEVRULE'
ACTION=="add", SUBSYSTEMS=="scsi", ATTRS{vendor}=="NUTANIX ", ATTRS{model}=="VDISK", RUN+="/bin/sh -c 'echo 1024 >/sys$DEVPATH/queue/max_sectors_kb'"
EOFUDEVRULE

# /usr/bin/tee -a /etc/udev/rules.d/99-nutanix-max_sectors_kb.rules > /dev/null <<EOT
# ACTION=="add", SUBSYSTEMS=="scsi", ATTRS{vendor}=="NUTANIX ", ATTRS{model}=="VDISK", RUN+="/bin/sh -c 'echo 1024 >/sys$DEVPATH/queue/max_sectors_kb'"
# EOT

#####################
## DEPLOY NEW FILES
#####################
/bin/cp -f ${BACKUPDIR}/99-nutanix-max_sectors_kb.rules /etc/udev/rules.d/99-nutanix-max_sectors_kb.rules
/bin/chown root:root /etc/udev/rules.d/99-nutanix-max_sectors_kb.rules
/bin/chmod 0600      /etc/udev/rules.d/99-nutanix-max_sectors_kb.rules

##################
## UPDATE ANY EXISTING DISKS
##################
/usr/bin/lsscsi | /usr/bin/grep NUTANIX | /usr/bin/awk '{print $NF}' | /usr/bin/awk -F"/" '{print $NF}' | /usr/bin/grep -v "-" | while read LUN
do
  /usr/bin/echo 1024 > /sys/block/${LUN}/queue/max_sectors_kb
done

#timestamp
/usr/bin/echo "** ntnx_set_max_sectors_kb.sh COMPLETE" $(date +%F-%H%M-%S)
