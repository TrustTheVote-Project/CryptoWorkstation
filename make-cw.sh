#!/bin/bash

# This script builds a Crypto Workstation ISO using LiveCD-Creator,
# a kickstart file, and a ZIP repository.

# Version: OSDV Public License 1.2
# The contents of this file are subject to the OSDV Public License
# Version 1.2 (the "License"); you may not use this file except in
# compliance with the License. You may obtain a copy of the License at
# http://www.osdv.org/license/
# Software distributed under the License is distributed on an "AS IS"
# basis, WITHOUT WARRANTY OF ANY KIND, either express or implied.
# See the License for the specific language governing rights and limitations
# under the License.

# The Original Code is:
#   TTV Crypto Workstation
# The Initial Developer of the Original Code is:
#   Open Source Digital Voting Foundation.
# Portions created by Open Source Digital Voting Foundation
#   are Copyright (C) 2010.
# All Rights Reserved.

# Contributors: Jeff Cook

CLIENT="DCDVBM"      # Name of client intended to use Crypto Workstation

IP="192.168.1.106"   # Expected IP address of local host
KS="cw-kiosk.ks"     # Name of kickstart file for LiveCD-Creator
ZIP="cw-kspost.zip"  # Name of ZIP repository for kickstart post-processing
ISO="$CLIENT-CW"     # Name of ISO file generated by LiveCD-Creator

echo "<<<<< Creating Crypto Workstation ISO >>>>>"

echo -n "Date: "
date

echo -n "Checking local IP address ... "
if `ifconfig -a | grep $IP 1>/dev/null 2>&1`
then
    echo $IP
else
    echo -e "\n**ERROR** Wrong local IP address, expecting: $IP"
    echo "**ERROR** Must change this script to use the correct IP."
    exit 1
fi

echo -n "Checking Kickstart usage of local IP address ... "
if grep $IP $KS 1>/dev/null 2>&1
then
    echo "OK"
else
    echo -e "\n**ERROR** Must change $KS to use correct IP."
    exit 1
fi

echo -n "Checking Kickstart usage of ZIP file ... "
if grep $ZIP $KS 1>/dev/null 2>&1
then
    echo "OK"
else
    echo -e "\n**ERROR** No mention in $KS of zip file: $ZIP"
    exit 1
fi

echo -n "Copying $KS to /usr/share/spin-kickstarts ... "
if sudo cp $KS /usr/share/spin-kickstarts
then
    echo "OK"
else
    echo -e "\n**ERROR** File copy failed: $KS"
    exit 1
fi

echo "Checking contents of pre-installed Kickstart files ..."
for ksf in `ls Spin-Kickstarts/*ks`
do
    ksfprint=`echo $ksf | sed 's/Spin-Kickstarts\///g'`
    if diff $ksf /usr/share/spin-kickstarts/
    then
	echo "  Unchanged: $ksfprint"
    else
	echo "**ERROR** Kickstart file changed from original: $ksfprint"
	exit 1
    fi
done

echo "Starting httpd ... "
if sudo service httpd start
then
    echo "  OK"
else
    echo -e "**ERROR** Failed to start service: httpd"
    exit 1
fi

echo -n "Turning off SELinux enforcement mode ... "
if sudo setenforce 0
then
    echo "OK"
else
    echo -e "\n**ERROR** Setenforce 0 failed."
    exit 1
fi

echo "Zipping up data for Kickstart post-processing phase ..."
rm -rf $ZIP
cd Zip
zip -r ../$ZIP .b* * 
if [ $? -ne "0" ]
then
    echo "**ERROR** Zip failed."
    exit 1
fi
cd ..

echo -n "Copying ZIP file to /var/www/html ... "
if sudo cp $ZIP /var/www/html
then
    echo "OK"
else
    echo -e "\n**ERROR** File copy failed: $ZIP"
    exit 1
fi

echo "Checking target ISO file ($ISO.iso) ..."
YON="no"
if [ -e $ISO.iso ]
then
    echo -n "File $ISO.iso exists, overwrite? [y/n]: "
    read YON
    if [ "$YON" = "y" ]
    then
        echo "Removing ISO file: $ISO.iso"
	rm -f $ISO.iso
    else
        echo "**ERROR** Must delete or authorize deletion of file: $ISO.iso"
	exit 1
    fi
fi

echo -n "Date: "
date
date > Log.txt

echo "Starting LiveCD-Creator in background, all output to Log.txt"
sudo livecd-creator --config=/usr/share/spin-kickstarts/$KS --fslabel=$ISO &>> Log.txt &
tail -f Log.txt
date
