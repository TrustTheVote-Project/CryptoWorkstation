*********************************
** Making a Crypto Workstation **
*********************************

The scripts and support files necessary for creating, from scratch, the Crypto
Workstation (CW), are here. 

The CW is a LiveCD version of Fedora 13 Linux created using the kickstart
methodology on a PC running Fedora 13 Linux.  The kickstart file for the CW
was derived from the kickstart file for Dan Walsh's Fedora Kiosk project
(https://fedoraproject.org/wiki/Fedora_Kiosk).  The result of the LiveCD
creation process is an ISO suitable for writing to bootable media.  The CW is
typically delivered in the form of a bootable DVD/CD/USB-drive.  For more
details consult the file README-CRYPTO-WORKSTATION.txt.  For information on
burning bootable media from ISOs, see HOWTO-BURN-BOOTABLE-ISO.txt.

The CW uses GnuPG to perform cryptographic key generation and backup, and
provides commands that automate the decryption of encrypted files stored on
external media.  The CW operates while completely disconnected from the
Internet, using a built-in firewall (iptables) to disallow all network
operations, by instructing the firewall to DROP all network packets.

Scripts:

  make-cw.sh - creates the CW, using a kickstart file and a zip repository

Files:

  00README.txt - this file, you are reading it now
  cw-kiosk.ks - the kickstart file for the CW
  cw-kspost.zip - zip repository for kickstart post-processing the CW
  DCDVBM-CW.iso - the ISO file holding the CW
  Log.txt - the log file generated while creating the ISO
  HOWTO-BURN-BOOTABLE-ISO.txt - the name says it all
  README-CRYPTO-WORKSTATION.txt - system reqs and installation instructions
  README-DCDVBM.txt - the CW is being developed under the DCdVBM project

Directories:

  Spin-Kickstarts - holds original copies of the pre-installed Kickstart files
  Zip - holds the configuration files for kickstarting the CW

****************
** make-cw.sh **
****************

This script creates the CW.  It performs the following operations:

- Checks to see if the local IP address is the same as the built-in one
- Ensures that the CW kickstart file uses the local IP address
- Ensures that the CW kickstart file uses the correct zip file
- Copies the CW kickstart file to /usr/share/spin-kickstarts
- Compares Spin-Kickstarts files with pre-installed ones, must be identical
- Starts the httpd service
- Turns off SELinux enforcement mode
- Zips up data for the kickstart process
- Copies the zip file to /var/www/html
- Checks if the target ISO file exists and if so asks for removal permission
- Starts LiveCD-Creator in the background, with output logged to Log.txt
- Then monitors progress via the Log.txt file
- Finishes with "Setting supported flag to 0" followed by some line feeds

The LiveCD-Creator program creates the CW, a bootable ISO, using the
instructions in the kickstart file and the configuration data in the zip
repository.

*********************
** Spin-Kickstarts **
*********************

This subdirectory holds copies of the basic kickstart files expected to be
installed on the computer making the CW.  The actually-installed files are
checked to ensure they are identical to these files.  They are:

  fedora-live-base.ks
  fedora-livecd-desktop.ks
  fedora-live-desktop.ks
  fedora-live-minimization.ks

*********
** Zip **
*********

This subdirectory holds the files used to configure the CW, which is done
during the "post" kickstart process.  It contains the following:

  .bash_profile - BASH profile
  .bashrc - BASH startup script
  ballots - script for finding ballots on a DVD/CD/USB-drive 
  custom.conf - GDM configuration file for auto-login
  decrypt - decrypt ballots on a CD/DVD/USB-drive and put in Decrypted/ folder
  devilspie.desktop - Devil's Pie auto-start file 
  Firefox/ - Firefox configuration files, so Firefox starts on correct page
  firefox.ds - Devil's Pie Firefox config, so Firefox starts at bottom right
  gpg.conf - GnuPG configuration file
  HOWTO.htm - HOWTO HTML file describing the operation of the CW
  Icons/ - holds icons (JPEGs) used by the HOWTO file above
  Iptables-drop.txt - iptables that DROP all packets, shutting off networking
  Samples/ - sample ballots (PDF files)
  test-clean - clean out encrypted ballots from Encrypted/ & Decrypted/ folders
  test-decrypt - decrypt the contents of the Samples/ and or Encrypted/
                 folders and put decrypted files into Decrypted/
  test-same - test to see if the plain ballots in the Decrypted/ folder are
              identical to those in the Samples/ folder

----------------------------------------
Please send any comments or feedback to:
jeff.the.cook@gmail.com

Jeffrey V. Cook
27 September 2010
