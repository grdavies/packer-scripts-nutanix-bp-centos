#!/usr/bin/env bash
##############################################################################
## Configure iscsid to Nutanix best practices
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
/usr/bin/echo "** ntnx_iscsi_settings.sh START" $(date +%F-%H%M-%S)

#################
## SET BASH ERREXIT OPTION
#################
set -o errexit

##################
## SET VARIBLES
##################

BACKUPDIR=/root/NtnxBestPractices

#################
## INSTALL PACKAGES
#################
# /usr/bin/yum install -y iscsi-initiator-utils 2> /dev/null
/usr/bin/yum install -y iscsi-initiator-utils

#################
## BACKUP FILES
#################

if [ ! -d "${BACKUPDIR}" ]; then mkdir -p ${BACKUPDIR}; fi

/bin/cp -fpd /etc/iscsi/iscsid.conf ${BACKUPDIR}/iscsid-DEFAULT

####################
## WRITE NEW FILES
####################

/usr/bin/cat > ${BACKUPDIR}/iscsid.conf << 'EOFISCSID'
#
# Open-iSCSI default configuration.
# Could be located at /etc/iscsi/iscsid.conf or ~/.iscsid.conf
#
# Note: To set any of these values for a specific node/session run
# the iscsiadm --mode node --op command for the value. See the README
# and man page for iscsiadm for details on the --op command.
#

######################
# iscsid daemon config
######################
# If you want iscsid to start the first time an iscsi tool
# needs to access it, instead of starting it when the init
# scripts run, set the iscsid startup command here. This
# should normally only need to be done by distro package
# maintainers.
#
# Default for Fedora and RHEL. (uncomment to activate).
# Use socket activation, but try to make sure the socket units are listening
iscsid.startup = /bin/systemctl start iscsid.socket iscsiuio.socket
#
# Default for upstream open-iscsi scripts (uncomment to activate).
# iscsid.startup = /sbin/iscsid

# Check for active mounts on devices reachable through a session
# and refuse to logout if there are any.  Defaults to "No".
iscsid.safe_logout = Yes

#############################
# NIC/HBA and driver settings
#############################
# open-iscsi can create a session and bind it to a NIC/HBA.
# To set this up see the example iface config file.

#*****************
# Startup settings
#*****************

# To request that the iscsi initd scripts startup a session set to "automatic".
# node.startup = automatic
#
# To manually startup the session set to "manual". The default is automatic.
node.startup = automatic

# For "automatic" startup nodes, setting this to "Yes" will try logins on each
# available iface until one succeeds, and then stop.  The default "No" will try
# logins on all available ifaces simultaneously.
node.leading_login = No

# *************
# CHAP Settings
# *************

# To enable CHAP authentication set node.session.auth.authmethod
# to CHAP. The default is None.
#node.session.auth.authmethod = CHAP

# To configure which CHAP algorithms to enable set
# node.session.auth.chap_algs to a comma seperated list.
# The algorithms should be listen with most prefered first.
# Valid values are MD5, SHA1, SHA256
# The default is MD5.
#node.session.auth.chap_algs = SHA256,SHA1,MD5

# To set a CHAP username and password for initiator
# authentication by the target(s), uncomment the following lines:
#node.session.auth.username = username
#node.session.auth.password = password

# To set a CHAP username and password for target(s)
# authentication by the initiator, uncomment the following lines:
#node.session.auth.username_in = username_in
#node.session.auth.password_in = password_in

# To enable CHAP authentication for a discovery session to the target
# set discovery.sendtargets.auth.authmethod to CHAP. The default is None.
#discovery.sendtargets.auth.authmethod = CHAP

# To set a discovery session CHAP username and password for the initiator
# authentication by the target(s), uncomment the following lines:
#discovery.sendtargets.auth.username = username
#discovery.sendtargets.auth.password = password

# To set a discovery session CHAP username and password for target(s)
# authentication by the initiator, uncomment the following lines:
#discovery.sendtargets.auth.username_in = username_in
#discovery.sendtargets.auth.password_in = password_in

# ********
# Timeouts
# ********
#
# See the iSCSI README's Advanced Configuration section for tips
# on setting timeouts when using multipath or doing root over iSCSI.
#
# To specify the length of time to wait for session re-establishment
# before failing SCSI commands back to the application when running
# the Linux SCSI Layer error handler, edit the line.
# The value is in seconds and the default is 120 seconds.
# Special values:
# - If the value is 0, IO will be failed immediately.
# - If the value is less than 0, IO will remain queued until the session
# is logged back in, or until the user runs the logout command.
# node.session.timeo.replacement_timeout = 120
node.session.timeo.replacement_timeout = 120  # Added by Nutanix per Linux Best Practices guide

# To specify the time to wait for login to complete, edit the line.
# The value is in seconds and the default is 15 seconds.
node.conn[0].timeo.login_timeout = 15

# To specify the time to wait for logout to complete, edit the line.
# The value is in seconds and the default is 15 seconds.
node.conn[0].timeo.logout_timeout = 15

# Time interval to wait for on connection before sending a ping.
# node.conn[0].timeo.noop_out_interval = 5
node.conn[0].timeo.noop_out_interval = 5  # Added by Nutanix per Linux Best Practices guide

# To specify the time to wait for a Nop-out response before failing
# the connection, edit this line. Failing the connection will
# cause IO to be failed back to the SCSI layer. If using dm-multipath
# this will cause the IO to be failed to the multipath layer.
# node.conn[0].timeo.noop_out_timeout = 5
node.conn[0].timeo.noop_out_timeout = 10  # Added by Nutanix per Linux Best Practices guide

# To specify the time to wait for abort response before
# failing the operation and trying a logical unit reset edit the line.
# The value is in seconds and the default is 15 seconds.
node.session.err_timeo.abort_timeout = 15

# To specify the time to wait for a logical unit response
# before failing the operation and trying session re-establishment
# edit the line.
# The value is in seconds and the default is 30 seconds.
node.session.err_timeo.lu_reset_timeout = 30

# To specify the time to wait for a target response
# before failing the operation and trying session re-establishment
# edit the line.
# The value is in seconds and the default is 30 seconds.
node.session.err_timeo.tgt_reset_timeout = 30


#******
# Retry
#******

# To specify the number of times iscsid should retry a login
# if the login attempt fails due to the node.conn[0].timeo.login_timeout
# expiring modify the following line. Note that if the login fails
# quickly (before node.conn[0].timeo.login_timeout fires) because the network
# layer or the target returns an error, iscsid may retry the login more than
# node.session.initial_login_retry_max times.
#
# This retry count along with node.conn[0].timeo.login_timeout
# determines the maximum amount of time iscsid will try to
# establish the initial login. node.session.initial_login_retry_max is
# multiplied by the node.conn[0].timeo.login_timeout to determine the
# maximum amount.
#
# The default node.session.initial_login_retry_max is 8 and
# node.conn[0].timeo.login_timeout is 15 so we have:
#
# node.conn[0].timeo.login_timeout * node.session.initial_login_retry_max =
#								120 seconds
#
# Valid values are any integer value. This only
# affects the initial login. Setting it to a high value can slow
# down the iscsi service startup. Setting it to a low value can
# cause a session to not get logged into, if there are distuptions
# during startup or if the network is not ready at that time.
node.session.initial_login_retry_max = 8

################################
# session and device queue depth
################################

# To control how many commands the session will queue set
# node.session.cmds_max to an integer between 2 and 2048 that is also
# a power of 2. The default is 128.
# node.session.cmds_max = 128
node.session.cmds_max = 2048  # Added by Nutanix per Linux Best Practices guide

# To control the device's queue depth set node.session.queue_depth
# to a value between 1 and 1024. The default is 32.
# node.session.queue_depth = 32
node.session.queue_depth = 1024  # Added by Nutanix per Linux Best Practices guide

##################################
# MISC SYSTEM PERFORMANCE SETTINGS
##################################

# For software iscsi (iscsi_tcp) and iser (ib_iser) each session
# has a thread used to transmit or queue data to the hardware. For
# cxgb3i you will get a thread per host.
#
# Setting the thread's priority to a lower value can lead to higher throughput
# and lower latencies. The lowest value is -20. Setting the priority to
# a higher value, can lead to reduced IO performance, but if you are seeing
# the iscsi or scsi threads dominate the use of the CPU then you may want
# to set this value higher.
#
# Note: For cxgb3i you must set all sessions to the same value, or the
# behavior is not defined.
#
# The default value is -20. The setting must be between -20 and 20.
node.session.xmit_thread_priority = -20


#***************
# iSCSI settings
#***************

# To enable R2T flow control (i.e., the initiator must wait for an R2T
# command before sending any data), uncomment the following line:
#
#node.session.iscsi.InitialR2T = Yes
#
# To disable R2T flow control (i.e., the initiator has an implied
# initial R2T of "FirstBurstLength" at offset 0), uncomment the following line:
#
# The defaults is No.
node.session.iscsi.InitialR2T = No

#
# To disable immediate data (i.e., the initiator does not send
# unsolicited data with the iSCSI command PDU), uncomment the following line:
#
#node.session.iscsi.ImmediateData = No
#
# To enable immediate data (i.e., the initiator sends unsolicited data
# with the iSCSI command packet), uncomment the following line:
#
# The default is Yes
# node.session.iscsi.ImmediateData = Yes
node.session.iscsi.ImmediateData = Yes  # Added by Nutanix per Linux Best Practices guide

# To specify the maximum number of unsolicited data bytes the initiator
# can send in an iSCSI PDU to a target, edit the following line.
#
# The value is the number of bytes in the range of 512 to (2^24-1) and
# the default is 262144
# node.session.iscsi.FirstBurstLength = 262144
node.session.iscsi.FirstBurstLength = 1048576  # Added by Nutanix per Linux Best Practices guide

# To specify the maximum SCSI payload that the initiator will negotiate
# with the target for, edit the following line.
#
# The value is the number of bytes in the range of 512 to (2^24-1) and
# the defauls it 16776192
# node.session.iscsi.MaxBurstLength = 16776192
node.session.iscsi.MaxBurstLength = 16776192  # Added by Nutanix per Linux Best Practices guide

# To specify the maximum number of data bytes the initiator can receive
# in an iSCSI PDU from a target, edit the following line.
#
# The value is the number of bytes in the range of 512 to (2^24-1) and
# the default is 262144
# node.conn[0].iscsi.MaxRecvDataSegmentLength = 262144
node.conn[0].iscsi.MaxRecvDataSegmentLength = 1048576  # Added by Nutanix per Linux Best Practices guide

# To specify the maximum number of data bytes the initiator will send
# in an iSCSI PDU to the target, edit the following line.
#
# The value is the number of bytes in the range of 512 to (2^24-1).
# Zero is a special case. If set to zero, the initiator will use
# the target's MaxRecvDataSegmentLength for the MaxXmitDataSegmentLength.
# The default is 0.
node.conn[0].iscsi.MaxXmitDataSegmentLength = 0

# To specify the maximum number of data bytes the initiator can receive
# in an iSCSI PDU from a target during a discovery session, edit the
# following line.
#
# The value is the number of bytes in the range of 512 to (2^24-1) and
# the default is 32768
#
# discovery.sendtargets.iscsi.MaxRecvDataSegmentLength = 32768
discovery.sendtargets.iscsi.MaxRecvDataSegmentLength = 1048576  # Added by Nutanix per Linux Best Practices guide

# To allow the targets to control the setting of the digest checking,
# with the initiator requesting a preference of enabling the checking, uncomment
# the following lines (Data digests are not supported.):
#node.conn[0].iscsi.HeaderDigest = CRC32C,None

#
# To allow the targets to control the setting of the digest checking,
# with the initiator requesting a preference of disabling the checking,
# uncomment the following line:
#node.conn[0].iscsi.HeaderDigest = None,CRC32C
#
# To enable CRC32C digest checking for the header and/or data part of
# iSCSI PDUs, uncomment the following line:
#node.conn[0].iscsi.HeaderDigest = CRC32C
#
# To disable digest checking for the header and/or data part of
# iSCSI PDUs, uncomment the following line:
#node.conn[0].iscsi.HeaderDigest = None
#
# The default is to never use DataDigests or HeaderDigests.
#
node.conn[0].iscsi.HeaderDigest = None

# For multipath configurations, you may want more than one session to be
# created on each iface record.  If node.session.nr_sessions is greater
# than 1, performing a 'login' for that node will ensure that the
# appropriate number of sessions is created.
node.session.nr_sessions = 1

#************
# Workarounds
#************

# Some targets like IET prefer after an initiator has sent a task
# management function like an ABORT TASK or LOGICAL UNIT RESET, that
# it does not respond to PDUs like R2Ts. To enable this behavior uncomment
# the following line (The default behavior is Yes):
node.session.iscsi.FastAbort = Yes

# Some targets like Equalogic prefer that after an initiator has sent
# a task management function like an ABORT TASK or LOGICAL UNIT RESET, that
# it continue to respond to R2Ts. To enable this uncomment this line
# node.session.iscsi.FastAbort = No

# To prevent doing automatic scans that would add unwanted luns to the system
# we can disable them and have sessions only do manually requested scans.
# Automatic scans are performed on startup, on login, and on AEN/AER reception
# on devices supporting it.  For HW drivers all sessions will use the value
# defined in the configuration file.  This configuration option is independent
# of scsi_mod scan parameter. (The default behavior is auto):
node.session.scan = auto
EOFISCSID

#####################
## DEPLOY NEW FILES
#####################
/bin/cp -f ${BACKUPDIR}/iscsid.conf /etc/iscsi/iscsid.conf
/bin/chown root:root /etc/iscsi/iscsid.conf
/bin/chmod 0600      /etc/iscsi/iscsid.conf

#timestamp
/usr/bin/echo "** ntnx_iscsi_settings.sh COMPLETE" $(date +%F-%H%M-%S)