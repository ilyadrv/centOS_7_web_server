#!/bin/bash
source $( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"/scripts/settings.sh"

echo "***********************************************"
echo "***********************************************"
echo "***   Installing Apache on Web Server   *******"
echo "***********************************************"
echo "***********************************************"
echo "This script is intended to:"
echo " 1. Install Apache"
echo "***********************************************"

echo ""
echo "install Apache 2.4"
yum install -y httpd-2.4.* mod_ssl
#start Apache at boot time
chkconfig --levels 235 httpd on

echo ""
echo "set selinux permissions for Apache (may takes few minutes)"
#set selinux permissions for Apache.
#allow remote db connetc
setsebool -P httpd_can_network_connect_db 1
#allows to execute oci8 lib
setsebool -P httpd_execmem 1
#allow sending emails
setsebool -P httpd_can_sendmail 1


echo ""
echo "put ServerName $(hostname) to /etc/httpd/conf.d/httpd_custom.conf"
cat <<EOF > /etc/httpd/conf.d/httpd_custom.conf
ServerName $(hostname)
EOF

echo ""
echo "start apache"
systemctl start httpd
