*********************************************************
** D.C. Digital Vote-By-Mail (DCdVBM) Bootable Modules **
*********************************************************

The DCdVBM project utilizes two separate bootable modules, derived from Dan
Walsh's Fedora Kiosk (https://fedoraproject.org/wiki/Fedora_Kiosk), and
described thusly: "The Fedora Kiosk spin, is a secure kiosk live operating
system, that will allow users to login to a system and access the internet in
a secure manner."

Each module comes in the form of a bootable DVD/CD/USB-drive that contains a
secure operating system (Fedora 13 Linux) and software suitable for its
specific task.

The first module is called the Crypto Workstation (CW).  It uses GnuPG to
perform cryptographic key generation and backup, and ballot decryption.  It
operates while completely disconnected from the Internet, using the built-in
firewall (iptables) to disallow all network operations, by instructing the
firewall to DROP all network packets.

The second module is called the Browser Appliance (BA). It is a bare-bones
system that basically allows the use of the Firefox Internet browser for a
single IP address (and corresponding host name) only.  This limitation is
enforced by instructing the local firewall (iptables) to disallow all network
connections other than TCP back and forth from the specified IP address.  For
DCdVBM, this allows remote voting over the Internet, by restricting the BA to
access only the DCdVBM server on which the voting takes place.

***************************
** Bootable Module Setup **
***************************

The DCdVBM bootable modules were built using the Fedora 13 version of Linux.

The following commands were used to setup the initial build environment:

  sudo yum install livecd-tools
  sudo yum install liveusb-creator
  sudo yum install spin-kickstarts

These install the LiveCD/USB tools for creating bootable LiveCDs from
kickstart files and burning them to USB drives (software for burning to CD/DVD
is typically pre-installed).

The custom kickstart files for creating the two DCdVBM bootable modules were
derived from Dan Walsh's kickstart file that created his Fedora Kiosk:

   http://people.fedoraproject.org/~dwalsh/SELinux/kiosk/kiosk.ks

For more details, please consult the README files for the individual modules.

----------------------------------------
Please send any comments or feedback to:
jeff.the.cook@gmail.com

Jeffrey V. Cook
27 September 2010
