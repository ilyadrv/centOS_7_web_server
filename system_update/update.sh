#!/bin/bash
source $( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"/scripts/settings.sh"

echo "*********************************************************************************"
echo "*********************************************************************************"
echo "******************************    Updating OS            ************************"
echo "*********************************************************************************"
echo "*********************************************************************************"
echo "This script is intended to:"
echo " 1. Update Operating System"
echo " 2. Install common tools"
echo "*********************************************************************************"

# Validate if user is ROOT
if [[ $EUID -ne 0 ]]; then
  echo "*** Unfortunatly you must be a root user to run this script."
  echo "Please login as ROOT and try this again." 
  exit 1
else
  echo "You will run this script as a ROOT." 
fi

# Update System
echo ""
echo "update system"
yum install -y yum-priorities
yum -y clean metadata
yum -y clean all
yum -y update

#Install common stuff
echo ""
echo "install common tools"
yum install -y yum-plugin-replace wget rpm-build make gcc svn
echo "install SVN"
yum install -y svn

#adding Webtatic EL yum repository
echo ""
echo "add Webtatic EL yum repository"
rpm --import http://repo.webtatic.com/yum/RPM-GPG-KEY-webtatic-el7
rpm --import http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7
rpm -Uvh https://mirror.webtatic.com/yum/el7/epel-release.rpm
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
yum history new