#!/usr/bin/env bash

# FORMATING DISK USING FDISK
format_disk() {
    echo "Formatting /dev/sda..."

    fdisk /dev/sda <<EOF
g
n
1

+1G
t
1
1
n
2

+4G
t
2
19
n
3


w
EOF

    # FORMAT THE FILE SYSTEM
    echo "Formatting the file systems..."

    mkfs.fat -F 32 /dev/sda1
    mkswap /dev/sda2
    mkfs.ext4 /dev/sda3

    echo "Disk formatting complete."
}

format_disk