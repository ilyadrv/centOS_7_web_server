#!/bin/bash
clear;
source $( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"/scripts/settings.sh"

# Validate if user is ROOT
if [[ $EUID -ne 0 ]]; then
  echo "*** Unfortunatly you must be a root user to run this script." 
  echo "Please login as ROOT and try this again." 
  exit 1
else
  echo "You run this script as a ROOT."
fi

#creating tmp dir
mkdir -p $TMP_DIR
echo "Tmp dir "$TMP_DIR" created"

# Scratch to data
echo $(date '+%T')" scratch_to_data"
cd $MAIN_DIR
. scratch_to_data.sh > $LOG

# Update Operating System
echo $(date '+%T')" Updating OS"
cd $UPDATE_DIR
. update.sh > $LOG

# Install APACHE
echo $(date '+%T')" Installing Apache"
cd $SCRIPTS_DIR
. install_apache.sh >> $LOG

# Install PHP
echo $(date '+%T')" Installing PHP"
cd $SCRIPTS_DIR
. install_php.sh >> $LOG

# Configure web server
echo $(date '+%T')" Configuring web server"
cd $SCRIPTS_DIR
. configure_web_server.sh >> $LOG

# Configure postfix
echo $(date '+%T')" Configuring postfix"
cd $SCRIPTS_DIR
. configure_postfix.sh >> $LOG

# Checkout sources
echo $(date '+%T')" Checking out source files"
cd $SCRIPTS_DIR
. checkout_src.sh >> $LOG

#removing tmp dir
rm -rf $TMP_DIR
echo "Tmp dir "$TMP_DIR" removed"

echo ""

echo "Apache:"
httpd -v
echo ""

echo "PHP:"
echo -n "php version: "
php -v
php --ri oci8 | grep -i "version"
php --ri PDFlib | grep -i -w "pdflib.*version"
echo ""

echo "*********************************************"
echo "*********************************************"
echo "************** IMPORTANT ********************"
echo " "
echo "- You MUST edit $PROJECT_ROOT/upex/.env"
echo " "
echo "- Run manualy 'source /etc/profile.d/oracle_env.sh' to set up oracle enironment variables if 'sqlplus not found'"
echo " "
echo "- To create new DB use $PROJECT_ROOT/sql/init_new_db.sh"
echo " "
echo "- If use virtualbox shared folder for document root you may need to add apache user to vboxsf group: usermod -a -G vboxsf apache"
echo " "
echo "- If use virtualbox shared folder for document root you may need to turm off SeLInux vi /etc/selinux/config  and set SELINUX=permissive. Reboot required ((("
echo ""
echo "- Setup firewall"
echo "firewall-cmd --zone=public --add-port=80/tcp --permanent"
echo "firewall-cmd --zone=public --add-port=443/tcp --permanent"
echo "systemctl restart firewalld"
echo "*********************************************"
echo "*********************************************"
echo "Finish. See $LOG for details"
