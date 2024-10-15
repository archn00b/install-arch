
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
arch-chroot /mnt
/bin/ln -sf /usr/share/zoneinfo/Europe/Zurich /etc/localtime
hwclock --systohc
/bin/sed -i '178s/.//' /etc/locale.gen
locale-gen
/bin/echo "LANG=en_US.UTF-8" >> /etc/locale.conf
/bin/echo "arch" >> /etc/hostname
/bin/echo "127.0.0.1 localhost" >> /etc/hosts
/bin/echo "::1       localhost" >> /etc/hosts
/bin/echo "127.0.1.1 arch.localdomain arch" >> /etc/hosts
/bin/echo root:123 | chpasswd

