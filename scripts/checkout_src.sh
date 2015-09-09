#!/bin/bash
source $( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"/scripts/settings.sh"

#clear
echo "***********************************************"
echo "***********************************************"
echo "***   Checkout src files of web app   *******"
echo "***********************************************"
echo "***********************************************"
echo "This script is intended to:"
echo " 1. Checkout src"
echo " 2. Install dependencies"
echo " 3. Create config from example"
echo "***********************************************"

#Checkout src files
echo ""
if $REMOVE_FILES_ROOT; then
    echo "remove $FILES_ROOT"
    rm -rf $FILES_ROOT
fi

echo "create  $PROJECT_ROOT"
mkdir -p $PROJECT_ROOT
#creating folders
echo "Creating dirs pdf doc gwusers"
mkdir -p $FILES_ROOT/pdf/
mkdir -p $FILES_ROOT/doc/
mkdir -p $FILES_ROOT/gwusers/

if $CHECKOUT_SOURCE; then
    echo "checkout project files from SVN to $PROJECT_ROOT"
    cd $PROJECT_ROOT
    svn co $SVN_PATH . --no-auth-cache

    echo ""
    echo "install dependecies via composer"
    composer install

    #setup permissions
    chgrp apache $FILES_ROOT -R
    chmod 775 $PROJECT_ROOT"/logs" -R
    chmod 775 $PROJECT_ROOT"/upex/storage" -R
    chmod 775 $DOC_ROOT"/pdf" -R
fi

if $WRITE_DUO_CONFIGS; then
#Creare config from template
    echo ""
    echo "Create $PROJECT_ROOT/upex/.env:"
    cp $PROJECT_ROOT"/upex/.env.example" $PROJECT_ROOT"/upex/.env"
fi

chmod 755 $PROJECT_ROOT"/sql/init_new_db.sh"

