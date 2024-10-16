
Arch_Disk="$1"

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
mkfs.fat -F 32 "${Arch_Disk}1"
mkswap "${Arch_Disk}2"
mkfs.ext4 "${Arch_Disk}3"

# MOUNTING THE FILE SYSTEM
mount "${Arch_Disk}3" /mnt
mount "${Arch_Disk}1" /mnt/boot
swapon "${Arch_Disk}2"

# INSTAL ESSENTIAL PACKAGES
pacstrap -K /mnt base linux linux-firmaware

# CONFIGURE THE SYSTEM
genfstab -U /mnt >> /mnt/etc/fstab

# CHANGE ROOT INTO THE NEW SYSTEM
arch-chroot /mnt /bin/bash
chroot /mnt /bin/bash
pacman -S vim

# pacman -S --noconfirm xf86-video-amdgpu






 



