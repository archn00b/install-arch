#!/usr/bin/env bash

Arch_Disk="$1"

# FORMATING DISK USING FDISK
format_disk() {
    fdisk "$Arch_Disk" <<EOF
g
n
1

+1G
t
1
n
2

+8G
t
2
19
n
3


p
w
q
EOF

# FORMAT THE FILE SYSTEM
echo " Formating the file system"
mkfs.fat -F 32 "${Arch_Disk}1"
mkswap "${Arch_Disk}2"
mkfs.ext4 "${Arch_Disk}3"
}
format_disk

