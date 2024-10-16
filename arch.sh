#!/bin/bash

# SETTING VARIABLES
export Arch=/mnt
export Arch_Disk=/dev/vda

# CHECKING IF ARCH IS MOUNTED
if ! grep -q "Arch_Root" /proc/mounts; then
     source formatdisk.sh "$Arch_Disk"
     # MOUNTING THE FILE SYSTEM
     mount "${Arch_Disk}3" $Arch
     mount "${Arch_Disk}1" $Arch/boot
     swapon "${Arch_Disk}2"
fi

# INSTAL ESSENTIAL PACKAGES
pacstrap -K /mnt base linux linux-firmware

# CONFIGURE THE SYSTEM
genfstab -U /mnt >> /mnt/etc/fstab
