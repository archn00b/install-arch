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

# Mount Kernel Virtual File Systems
mount -t proc proc $Arch/proc
mount -t sysfs sysfs $Arch/sys
mount -t devtmpfs devtmpfs $Arch/dev
mount -t tmpfs tmpfs $Arch/dev/shm
mount -t devpts devpts $Arch/dev/pts

# Copy /etc/hosts
/bin/cp -f /etc/hosts $Arch/etc/

# Copy /etc/resolv.conf 
/bin/cp -f /etc/resolv.conf $Arch/etc/resolv.conf

# Link /etc/mtab
chroot $Arch rm /etc/mtab 2> /dev/null 
chroot $Arch ln -s /proc/mounts /etc/mtab
echo "Inside of chroot"