#!/usr/bin/env bash

# ==========================================
# ARCH LINUX CHROOT SETUP
# ==========================================

set -e

# Make sure /mnt exists
if [ ! -d /mnt ]; then
    echo "ERROR: /mnt does not exist."
    exit 1
fi

# Make sure something is mounted on /mnt
if ! mountpoint -q /mnt; then
    echo "ERROR: /mnt is not mounted."
    exit 1
fi

echo
echo "=========================================="
echo " Entering Arch Linux chroot..."
echo "=========================================="
echo

# ==========================================
# Run setup inside chroot
# ==========================================

arch-chroot /mnt /bin/bash <<'CHROOT'

set -e

echo
echo "=========================================="
echo " Inside Arch Linux chroot"
echo "=========================================="
echo


# ------------------------------------------
# Timezone
# ------------------------------------------

echo "Setting timezone..."

ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime

hwclock --systohc

sleep 1


# ------------------------------------------
# Locale
# ------------------------------------------

echo "Generating locale..."

sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen

locale-gen

echo "LANG=en_US.UTF-8" > /etc/locale.conf

sleep 1


# ------------------------------------------
# Hostname
# ------------------------------------------

echo "Setting hostname..."

echo "arch" > /etc/hostname

sleep 1


# ------------------------------------------
# Hosts
# ------------------------------------------

echo "Configuring hosts..."

cat > /etc/hosts <<HOSTS
127.0.0.1   localhost
::1         localhost
127.0.1.1   arch.localdomain arch
HOSTS

sleep 1


# ------------------------------------------
# Root Password
# ------------------------------------------

echo "Setting root password..."

echo "root:123" | chpasswd

sleep 1


# ------------------------------------------
# Install Packages
# ------------------------------------------

echo
echo "Installing packages..."
echo

pacman -S --noconfirm \
    sudo \
    grub \
    efibootmgr \
    networkmanager \

sleep 2


# ------------------------------------------
# Enable Services
# ------------------------------------------

echo "Enabling services..."

systemctl enable NetworkManager

sleep 2


# ------------------------------------------
# Create User
# ------------------------------------------

echo "Creating user archn00b..."

if ! id archn00b &>/dev/null; then
    useradd -m archn00b
fi

echo "archn00b:123" | chpasswd

sleep 1


# ------------------------------------------
# Sudo Access
# ------------------------------------------

echo "Configuring sudo access..."

mkdir -p /etc/sudoers.d

echo "archn00b ALL=(ALL) ALL" > /etc/sudoers.d/archn00b

chmod 440 /etc/sudoers.d/archn00b

sleep 1


# ------------------------------------------
# GRUB
# ------------------------------------------

echo
echo "Installing GRUB..."
echo

grub-install \
    --target=x86_64-efi \
    --efi-directory=/boot \
    --bootloader-id=GRUB

sleep 2


# ------------------------------------------
# GRUB Configuration
# ------------------------------------------

echo
echo "Generating GRUB configuration..."
echo

grub-mkconfig -o /boot/grub/grub.cfg

sleep 2


# ------------------------------------------
# Finished
# ------------------------------------------

echo
echo "=========================================="
echo " Arch Linux setup completed!"
echo "=========================================="
echo

CHROOT


# ==========================================
# Enter interactive chroot
# ==========================================

echo
echo "=========================================="
echo " Opening interactive chroot..."
echo "=========================================="
echo

arch-chroot /mnt
