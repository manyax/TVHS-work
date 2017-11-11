#!/bin/bash
#----------------------------------------------------------------------
# Description:
# Author: manyax,,, <>
# Created at: Thu Jul  9 21:09:07 CEST 2015
# Computer: debian-manyax
# System: Linux 3.16.0-4-amd64 on x86_64
#
# Copyright (c) 2015 manyax,,,  All rights reserved.
#
#----------------------------------------------------------------------
# Configure section:

ADMIN="admin@tvhs"
WEBFILE="https://oscam_key"
TEMP="/opt/oscam_update/SoftCam.temp"
OLD="/opt/oscam_update/SoftCam.old"
FILE="/opt/oscam_update/SoftCam.Key"
LOC="/usr/local/etc/SoftCam.Key"

wget -q $WEBFILE -O $TEMP
cat $TEMP |grep "Digi TV" > $FILE
if [ ! -s $FILE ];
    then
        echo "File empty! Softcam URL down.. ?"
        echo -e "Could not retrieve $WEBFILE\nURL down.. ?\n$(date +"%a %x %X")\n" |sudo -u hts mail -sendwait -s "Could not retrieve Softcam.key $(hostname)" $ADMIN
        rm $TEMP
        exit 0
elif diff -q $OLD $FILE > /dev/null;
    then
        echo "No changes .."
        rm $FILE
        rm $TEMP
        exit 0
    else
        echo "New key found"
        cp $FILE $LOC
        echo '### Last updated on: '$(date +"%m-%d-%Y %r") >> $LOC
        echo -e "oscam key updated.\n$(date +"%a %x %X")\n" |sudo -u hts mail -sendwait -s "New oscam key $(hostname)" -A $FILE $ADMIN
        mv $FILE $OLD
        rm $TEMP
        /usr/sbin/service oscam stop && { echo "/usr/sbin/service oscam start" | at now + 1 min; }
fi
exit 0
