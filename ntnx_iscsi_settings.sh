#!/usr/bin/env bash
#
# Set Nutanix Best Practices
# iSCSI Initiator Settings
#

set -o errexit

# Install the in-guest iSCSI initiator
yum install -y iscsi-initiator-utils 2> /dev/null

# Configure the in-guest iSCSI initiator
echo "NTNX: Setting node.session.timeo.replacement_timeout = 5 in /etc/iscsi/iscsid.conf"
sed -i '/^node.session.timeo.replacement_timeout[[:space:]]=/{h;s/=.*/= 5  # Modified by Nutanix Automation/};${x;/^$/{s//node.session.timeo.replacement_timeout = 5  # Added by Nutanix Automation/;H};x}' /etc/iscsi/iscsid.conf

echo "NTNX: Setting node.conn[0].timeo.noop_out_interval = 10 in /etc/iscsi/iscsid.conf"
sed -i '/^node.conn\[0\].timeo.noop_out_interval[[:space:]]=/{h;s/=.*/= 10  # Modified by Nutanix Automation/};${x;/^$/{s//node.conn\[0\].timeo.noop_out_interval = 10  # Added by Nutanix Automation/;H};x}' /etc/iscsi/iscsid.conf

echo "NTNX: Setting node.conn[0].timeo.noop_out_timeout = 120 in /etc/iscsi/iscsid.conf"
sed -i '/^node.conn\[0\].timeo.noop_out_timeout[[:space:]]=/{h;s/=.*/= 120  # Modified by Nutanix Automation/};${x;/^$/{s//node.conn\[0\].timeo.noop_out_timeout = 120  # Added by Nutanix Automation/;H};x}' /etc/iscsi/iscsid.conf

echo "NTNX: Setting node.session.cmds_max = 2048 in /etc/iscsi/iscsid.conf"
sed -i '/^node.session.cmds_max[[:space:]]=/{h;s/=.*/= 2048  # Modified by Nutanix Automation/};${x;/^$/{s//node.session.cmds_max = 2048  # Added by Nutanix Automation/;H};x}' /etc/iscsi/iscsid.conf

echo "NTNX: Setting node.session.queue_depth = 1024 in /etc/iscsi/iscsid.conf"
sed -i '/^node.session.queue_depth[[:space:]]=/{h;s/=.*/= 1024  # Modified by Nutanix Automation/};${x;/^$/{s//node.session.queue_depth = 1024  # Added by Nutanix Automation/;H};x}' /etc/iscsi/iscsid.conf

echo "NTNX: Setting node.session.iscsi.ImmediateData = Yes in /etc/iscsi/iscsid.conf"
sed -i '/^node.session.iscsi.ImmediateData[[:space:]]=/{h;s/=.*/= Yes  # Modified by Nutanix Automation/};${x;/^$/{s//node.session.iscsi.ImmediateData = Yes  # Added by Nutanix Automation/;H};x}' /etc/iscsi/iscsid.conf

echo "NTNX: Setting node.session.cmds_max = 2048 in /etc/iscsi/iscsid.conf"
sed -i '/^node.session.iscsi.FirstBurstLength[[:space:]]=/{h;s/=.*/= 2048  # Modified by Nutanix Automation/};${x;/^$/{s//node.session.cmds_max = 2048  # Added by Nutanix Automation/;H};x}' /etc/iscsi/iscsid.conf

echo "NTNX: Setting node.session.iscsi.MaxBurstLength = 16776192 in /etc/iscsi/iscsid.conf"
sed -i '/^node.session.iscsi.MaxBurstLength[[:space:]]=/{h;s/=.*/= 16776192  # Modified by Nutanix Automation/};${x;/^$/{s//node.session.iscsi.MaxBurstLength = 16776192  # Added by Nutanix Automation/;H};x}' /etc/iscsi/iscsid.conf

echo "NTNX: Setting node.session.iscsi.MaxRecvDataSegmentLength = 1048576 in /etc/iscsi/iscsid.conf"
sed -i '/^node.session.iscsi.MaxRecvDataSegmentLength[[:space:]]=/{h;s/=.*/= 1048576  # Modified by Nutanix Automation/};${x;/^$/{s//node.session.iscsi.MaxRecvDataSegmentLength = 1048576  # Added by Nutanix Automation/;H};x}' /etc/iscsi/iscsid.conf

echo "NTNX: Setting discovery.sendtargets.iscsi.MaxRecvDataSegmentLength = 1048576 in /etc/iscsi/iscsid.conf"
sed -i '/^discovery.sendtargets.iscsi.MaxRecvDataSegmentLength[[:space:]]=/{h;s/=.*/= 1048576  # Modified by Nutanix Automation/};${x;/^$/{s//discovery.sendtargets.iscsi.MaxRecvDataSegmentLength = 1048576  # Added by Nutanix Automation/;H};x}' /etc/iscsi/iscsid.conf
