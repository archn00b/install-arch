#!/usr/bin/env bash


# shellcheck disable=SC2154
arch-chroot /mnt /bin/bash <<EOF
ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
hwclock --systohc
sed -i 's/^#en_US.UTF-8/en_US.UTF-8/g' /etc/locale.gen
locale-gen
sleep 2
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "arch" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 arch.localdomain arch" >> /etc/hosts
echo root:123 | chpasswd
sleep 5

pacman -S --noconfirm grub efibootmgr networkmanager network-manager-applet xorg xfce4 xfce4-goodies sddm firefox alacritty
sleep 5

systemctl enable NetworkManager
systemctl enable sddm
sleep 5

useradd -m archnoob
echo archnoob:123 | chpasswd
sleep 5

echo "archnoob ALL=(ALL) ALL" >> /etc/sudoers.d/archnoob

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
sleep 5
grub-mkconfig -o /boot/grub/grub.cfg
sleep 5

printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"
sleep 5
EOF
