#!/usr/bin/env bash

# FORMATING DISK USING FDISK
format_disk() {
    fdisk /dev/sda <<EOF
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
mkfs.fat -F 32 /dev/sda1
mkswap /dev/sda2
mkfs.ext4 /dev/sda3
}
format_disk

