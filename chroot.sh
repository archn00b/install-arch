```bash
#!/usr/bin/env bash

arch-chroot /mnt /bin/bash <<EOF

# Timezone
ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
sleep 1

hwclock --systohc
sleep 1

# Locale
sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
sleep 1

echo "LANG=en_US.UTF-8" > /etc/locale.conf
sleep 1

# Hostname
echo "arch" > /etc/hostname
sleep 1

# Hosts
cat > /etc/hosts <<HOSTS
127.0.0.1   localhost
::1         localhost
127.0.1.1   arch.localdomain arch
HOSTS

sleep 1

# Root password
echo "root:123" | chpasswd
sleep 2

# Install packages
pacman -S --noconfirm \
    grub \
    efibootmgr \
    networkmanager \

sleep 3

# Enable services
systemctl enable NetworkManager
systemctl enable sddm
sleep 2

# Create user
useradd -m archnoob
sleep 1

echo "archn00b:123" | chpasswd
sleep 1

# Sudo access
echo "archn00b ALL=(ALL) ALL" > /etc/sudoers.d/archn00b
chmod 440 /etc/sudoers.d/archnoob

sleep 1

# Install GRUB
grub-install \
    --target=x86_64-efi \
    --efi-directory=/boot \
    --bootloader-id=GRUB

sleep 3

# Generate GRUB configuration
grub-mkconfig -o /boot/grub/grub.cfg

sleep 3

echo
echo "=========================================="
echo "        Arch Linux Setup Complete!"
echo "=========================================="
echo
echo "Type: exit"
echo "Then: umount -R /mnt"
echo "Then: reboot"
echo

EOF
```
