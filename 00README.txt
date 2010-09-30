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
  cw-kspost.zip - zip repository for kickstart post-processing
  DCDVBM-CW.iso - the ISO file holding the CW
  Log.txt - the log file generated while creating the ISO
  HOWTO-BURN-BOOTABLE-ISO.txt - the name says it all
  README-CRYPTO-WORKSTATION.txt - system reqs and installation instructions
  README-DCDVBM.txt - the CW is being developed under the DCdVBM project

Directories:

  Spin-Kickstarts/ - holds original copies of pre-installed Kickstart files
  Zip/ - holds configuration files for post-kickstarting the CW

****************
** make-cw.sh **
****************

The Bash script make-cw.sh creates the ISO for the CW.  Its primary function
is to provide LiveCD-Creator with the data necessary to "kickstart" the CW.
Two chunks of data are required: the pre-existing kickstart file cw-kiosk.ks
and a script-created zip repository holding the contents of the Zip directory,
which is copied to /var/www/html.  Once the kickstart process enters the
"post-processing" phase, LiveCD-Creator has no access to the local file
system, and any required data comes from "outside," in this case from the
local web (httpd) server, whose file system is rooted at /var/www/html.  The
IP address of the local host is required in order to access this web server.

The script performs the following operations:

- Ensures that the built-in local IP address is correct
- Ensures that the kickstart file uses the local IP address
- Ensures that the kickstart file uses the correct zip file name
- Copies the kickstart file to /usr/share/spin-kickstarts
- Compares Spin-Kickstarts files with pre-installed ones, must be identical
- Starts the httpd service
- Turns off SELinux enforcement mode
- Zips up the data for the zip repository, from the contents of Zip/
- Copies the zip repository to /var/www/html
- Checks if the target ISO file exists and if so asks for removal permission
- Starts LiveCD-Creator in the background, with output logged to Log.txt
- Then monitors progress via (tail -f of) the Log.txt file
- Finishes with "Setting supported flag to 0" followed by some line feeds

!!!!!!!!!!!!!
!! WARNING !!
!!!!!!!!!!!!!

Red Hat Bugzilla - Bug 624028 - livecd-creator creates iso that doesn't boot

The author has been struggling with this bug since late August, 2010.  It took
me about 10 days to get livecd-creator to work properly on my PC after first
encountering the bug, and I am unsure of exactly what I did to fix the
problem.  My current Fedora 13 development system uses livecd-creator to
generate ISOs that successfully re-boot my PC, after being burned to external
media such as CD/DVD/USB.  However, the local Virtual Machine Manager will not
boot these ISO, and still reports the error message mentioned in the bug.

So I am afraid that, under the currently broken state of Fedora 13, my
procedure for creating a Crypto Workstation from scratch is not replicable.  
I would appreciate feedback from anyone attempting this process who either
succeeds or fails.  My contact information appears at the end.

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
29 September 2010
