#!/bin/bash
source $( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"/scripts/settings.sh"

echo "***********************************************"
echo "***********************************************"
echo "***   Installing PHP on Web Server   *******"
echo "***********************************************"
echo "***********************************************"
echo "This script is intended to:"
echo " 1. Install PHP"
echo " 2. Install Composer"
echo " 3. Install OCI driver"
echo " 4. Install PDF lib"
echo "***********************************************"

# install PHP 5.6
echo ""
echo "install PHP 5.6"
yum install -y php56w php56w-mcrypt php56w-pdo php56w-curl php56w-gd php56w-xml php56w-mbstring php56w-common php56w-devel php56w-bcmath php56w-ldap

## install php pear. It also install pecl
echo ""
echo "install PEAR and PECL"
yum install -y php56w-pear*
pecl channel-update pecl.php.net

#install Composer
echo ""
echo "install Composer"
mkdir -p $TMP_DIR
cd $TMP_DIR
curl -sS https://getcomposer.org/installer | php
chmod +x composer.phar
mv composer.phar /usr/bin/composer

## install pear Mail
echo ""
echo "install pear Mail"
pear install Mail Mail_mime

# install Oracle client
echo ""
echo "install Oralce client 11.2.0.2"
yum install -y libaio
cd $INSTALL_DIR
rpm -Uvh oracle-instantclient11.2-basic-11.2.0.2.0.x86_64.rpm oracle-instantclient11.2-devel-11.2.0.2.0.x86_64.rpm oracle-instantclient11.2-sqlplus-11.2.0.2.0.x86_64.rpm

echo ""
echo "put Oralce environment variables to /etc/profile.d/oracle_env.sh:"
cat <<EOF > /etc/profile.d/oracle_env.sh
export ORACLE_HOME=/usr/lib/oracle/11.2/client64
export LD_LIBRARY_PATH=\$ORACLE_HOME/lib
export PATH=\$ORACLE_HOME/bin:\$LD_LIBRARY_PATH:\$PATH
EOF
source /etc/profile.d/oracle_env.sh
cat /etc/profile.d/oracle_env.sh

# install Oracle driver
echo ""
echo "install oci8-2.0.8"
printf "shared,instantclient,"$LD_LIBRARY_PATH"\n" | pecl install oci8-2.0.8
echo "extension=oci8.so" > /etc/php.d/oci8.ini

# install PDF lib
echo ""
echo "install PDFlib-9.0.5"
cd $INSTALL_DIR
\cp PDFlib-9.0.5p1-Linux-x86_64-php/bind/php/php-560/php_pdflib.so $(php-config --extension-dir)/php_pdflib.so
echo "extension=php_pdflib.so" > /etc/php.d/libpdf.ini

#set time zone
echo ""
echo "configure PHP"
echo "put date.timezone ='Europe/Berlin' to /etc/php.d/timezone.ini"
echo "date.timezone ='Europe/Berlin'" > /etc/php.d/timezone.ini

#restart apache
echo ""
echo "restart apache"
systemctl restart httpd