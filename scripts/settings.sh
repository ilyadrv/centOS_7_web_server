#!/bin/bash
#Setting variables
SCRIPT_NAME="centos_7_web_server"
MAIN_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )
UPDATE_DIR=$MAIN_DIR"/system_update"
SCRIPTS_DIR=$MAIN_DIR"/scripts"
SETUP_DIR=$MAIN_DIR"/system_setup"
TMP_DIR="/tmp/setup_script"
INSTALL_DIR=$MAIN_DIR"/install"
LOG="/var/log/"$SCRIPT_NAME"_setup.log"

###############################################
REMOVE_FILES_ROOT=true
CHECKOUT_SOURCE=true
WRITE_DUO_CONFIGS=true

###############################################
WEB_DOMAIN="upex-centos7-web.localdomain"
SERVER_ADMIN="webmaster@upex-centos7-web.localdomain"

FILES_ROOT="/data/www"
PROJECT_ROOT=$FILES_ROOT"/upex"
DOC_ROOT=$PROJECT_ROOT"/w3"
SVN_PATH="https://svnsrv.desy.de/desy/EuXFEL/WP76/web_services/user_portal/trunk/"

#leave blank to not setting this
POSTFIX_REDIRECT_ALL_EMAIL_TO="illia.derevianko@xfel.eu"