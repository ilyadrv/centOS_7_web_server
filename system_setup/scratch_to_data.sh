#!/bin/bash
source $( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"/scripts/settings.sh"

# Validate if user is ROOT
if [[ $EUID -ne 0 ]]; then
  echo "*** Unfortunatly you must be a root user to run this script." 2>&1
  echo "Please login as ROOT and try this again." 2>&1
  exit 1
fi

# Validate if /data directory exists
data_dir_exists=`df | grep /data | wc -l`
if [[ $data_dir_exists -eq 0 ]]; then
  # Validate if /scratch directory exists
  scratch_dir_exists=`df | grep /scratch | wc -l`
  if [[ $scratch_dir_exists -eq 1 ]]; then
    #Print partitions
    df

    #Copy content from /data folder if it exists
    cp -a /data/* /scratch
    rm -rf /data/*

    #Create new folder if it doesn't exist
    mkdir -p /data

    #Unmount partition to be renamed
    umount /scratch/

    #Rename partion on /etc/fstab file
    sed -i 's/scratch/data   /g' /etc/fstab
    #UUID=6c9e7b70-331c-41f7-9ac6-ceadb4760d56 /data                ext3    defaults        1 2

    #Mount the new partion
    mount /data/

    #Print partitions
    df -h

    echo "/scratch partition was successfully rename to /data " 2>&1
  else
    echo "PROBLEM!!! Partition /data and /scratch  don't exists..." 2>&1
    exit 1
  fi
else
  echo "/data partition already exists." 2>&1
fi





