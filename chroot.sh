#!/usr/bin/env bash

Arch_Root="$1"

arch-chroot /mnt /bin/bash <<EOF
ln -sf /usr/share/zoneinfo/Europe/Zurich /etc/localtime
hwclock --systohc
sed -i 's/^#en_US.UTF-8/en_US.UTF-8/g' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "arch" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 arch.localdomain arch" >> /etc/hosts
echo root:ilovecoding | chpasswd

pacman -S grub efibootmgr networkmanager network-manager-applet 


grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB  
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager


useradd -m archnoob
echo archnoob:ilovecoding | chpasswd

echo "archnoob ALL=(ALL) ALL" >> /etc/sudoers.d/archnoob

printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"
exit
EOF

umount -a "$Arch_Root" 
reboot  