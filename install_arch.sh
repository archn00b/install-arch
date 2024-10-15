#!/usr/bin/env bash

# SETTING VARIABLES
export Arch_Root=/mnt
export Arch_Disk=/dev/vda

if ! grep -q "Arch_Root" /proc/mounts; then
    source formatdisk.sh "$Arch_Disk"
fi
