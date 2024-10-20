#!/usr/bin/env bash
set -euo pipefail
##################################################################################################################
# Author 	: ArchN00B
# Website   : https://www.github.com/archn00b
######################################################################################
#
#   ITS ALL IN YOUR HANDS. READ & OBSERVE SCRIPT ESPECIALLY COMMENTS
#
######################################################################################
#tput setaf 0 = black 
#tput setaf 1 = red 
#tput setaf 2 = green
#tput setaf 3 = yellow 
#tput setaf 4 = dark blue 
#tput setaf 5 = purple
#tput setaf 6 = cyan 
#tput setaf 7 = gray 
#tput setaf 8 = light blue
######################################################################################

# SETTING VARIABLES
export Arch_Root=/mnt 
export Arch_Disk=/dev/sda

# CHECKING IF ARCH IS MOUNTED
if ! grep -q "Arch_Root" /proc/mounts; then
     # shellcheck disable=SC1091
     source format_disk.sh
     mount "${Arch_Disk}3" /mnt
     mount --mkdir "${Arch_Disk}1" /mnt/boot
     swapon "${Arch_Disk}2"
fi

# shellcheck disable=SC1091

# INSTALLING ESSENTIAL PKG'S
pacstrap -K /mnt base linux linux-firmware

# GENERATE FSTAB
genfstab -U /mnt >> /mnt/etc/fstab

# ENTERING ARCH-CHROOT
# shellcheck disable=SC1091
source chroot.sh



