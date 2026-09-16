#!/usr/bin/env bash

# ==========================================
# ARCH LINUX CHROOT CONFIGURATION
# ==========================================

arch-chroot /mnt /bin/bash <<EOF

# ------------------------------------------
# Timezone
# ------------------------------------------

ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime

sleep 1

hwclock --systohc

sleep 1


# ------------------------------------------
# Locale
# ------------------------------------------

sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen

sleep 1

locale-gen

sleep 1

echo "LANG=en_US.UTF-8" > /etc/locale.conf

sleep 1


# ------------------------------------------
# Hostname
# ------------------------------------------

echo "arch" > /etc/hostname

sleep 1


# ------------------------------------------
# Hosts
# ------------------------------------------

cat > /etc/hosts <<HOSTS
127.0.0.1   localhost
::1         localhost
127.0.1.1   arch.localdomain arch
HOSTS

sleep 1


# ------------------------------------------
# Root Password
# ------------------------------------------

echo "root:123" | chpasswd

sleep 2


# ------------------------------------------
# Install Packages
# ------------------------------------------

pacman -S --noconfirm \
    grub \
    efibootmgr \
    networkmanager \
    network-manager-applet \

sleep 3


# ------------------------------------------
# Enable Services
# ------------------------------------------

systemctl enable NetworkManager

sleep 1

# ------------------------------------------
# Create User
# ------------------------------------------

useradd -m archnoob

sleep 1

echo "archnoob:123" | chpasswd

sleep 1


# ------------------------------------------
# Give User Sudo Access
# ------------------------------------------

echo "archnoob ALL=(ALL) ALL" > /etc/sudoers.d/archnoob

chmod 440 /etc/sudoers.d/archnoob

sleep 1


# ------------------------------------------
# Install GRUB
# ------------------------------------------

grub-install \
    --target=x86_64-efi \
    --efi-directory=/boot \
    --bootloader-id=GRUB

sleep 3


# ------------------------------------------
# Generate GRUB Configuration
# ------------------------------------------

grub-mkconfig -o /boot/grub/grub.cfg

sleep 3


# ------------------------------------------
# Finished
# ------------------------------------------

printf '\\e[1;32m\\n==========================================\\n'
printf '        Arch Linux Setup Complete!\\n'
printf '==========================================\\n'
printf '\\n'
printf 'Type: exit\\n'
printf 'Then: umount -R /mnt\\n'
printf 'Then: reboot\\n'
printf '\\n\\e[0m'

EOF
