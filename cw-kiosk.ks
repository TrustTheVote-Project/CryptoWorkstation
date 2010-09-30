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
#   TTV Crypto Workstation.
# The Initial Developer of the Original Code is:
#   Open Source Digital Voting Foundation.
# Portions created by Open Source Digital Voting Foundation
#   are Copyright (C) 2010.
# All Rights Reserved.

# Contributors: Henry Robertson, Jeff Cook, Dan Walsh

# Maintained by the Dan Walsh
# http://people.fedoraproject.org/dwalsh/SELinux
# mailto:dwalsh@redhat.com

%include fedora-livecd-desktop.ks
#repo --name=local --baseurl=file:///var/tmp/repo

bootloader --timeout=1 
firewall --enabled 

%packages
@printing
hplip
devilspie
gpa
xguest
evolution-data-server
-setroubleshoot*
#gnome-panel*
-abrt*
-anaconda
-device-mapper-*
-pino
#-system-config-*
-telepathy*
-ImageMagick-*
-gnome-packagekit
-tiger*
-cdparanoia*
#-gedit*
-sqlite*
-gcalctool*
-createrepo
-compiz*
-nautilus*
-transmission*
-openssh*
#-evince*
-empathy-*
-@graphics
-@network-tools
#-@system-tools
#-@administration-tools
@hardware-support
wget
%end

%post
rm -f /etc/init.d/livesys-adduser 
cd /tmp/
wget http://192.168.1.106/cw-kspost.zip
unzip cw-kspost.zip
mkdir -p /home/liveuser/.mozilla/
mv Firefox /home/liveuser/.mozilla/firefox
mv .bash_profile /home/liveuser
mv .bashrc /home/liveuser
mv ballots /home/liveuser
mv decrypt /home/liveuser
mv test-clean /home/liveuser
mv test-decrypt /home/liveuser
mv test-same /home/liveuser
mkdir -p /home/liveuser/Documents
mv Icons/* /home/liveuser/Documents
mkdir -p /home/liveuser/Desktop
mv Samples /home/liveuser/Desktop
mv HOWTO.htm /home/liveuser/Desktop
mkdir -p /home/liveuser/Desktop/Encrypted
mkdir -p /home/liveuser/Desktop/Decrypted
mkdir -p /home/liveuser/.gnupg
mv gpg.conf /home/liveuser/.gnupg
sed -i -e 's/NoDisplay=true/NoDisplay=false/' /usr/share/applications/gpa.desktop
cp /usr/share/applications/gpa.desktop /home/liveuser/Desktop
chmod a+x /home/liveuser/Desktop/gpa.desktop
mkdir -p /home/liveuser/.config/autostart
mv devilspie.desktop /home/liveuser/.config/autostart
mkdir -p /home/liveuser/.devilspie
mv firefox.ds /home/liveuser/.devilspie
ln -s /usr/share/applications/mozilla-firefox.desktop /home/liveuser/.config/autostart/mozilla-firefox.desktop
cd /home/
chown -R 501:501 liveuser
yum remove wget -y
cd /home/liveuser/.mozilla/firefox/Profiles/0rprv5da.default/
sed -i 's/user_pref("browser.startup.homepage_override.mstone", "rv:1.9.2")\;/user_pref("browser.startup.homepage_override.mstone", "ignore")\;/g' prefs.js 
%end

%post
echo "** Setting Up Autostart for Liveuser"
cd /tmp/
echo "** Replacing custom.conf ..."
cat custom.conf > /etc/gdm/custom.conf
echo "** Done Autostart"
%end

%post
echo "** Firewall Configuration Started"
cd /tmp/
echo "** Replacing /etc/sysconfig/iptables ..."
cat Iptables-drop.txt > /etc/sysconfig/iptables
echo "** Done Firewall"
%end

%post
echo "** Removing Root Password"
passwd -l root
echo "** Done Removing"
%end
