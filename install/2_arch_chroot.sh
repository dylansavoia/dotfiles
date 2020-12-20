#!/bin/bash

timedatectl set-ntp true

# Locale
echo -e "Set Region and City as in /usr/share/zoneinfo:"
ls /usr/share/zoneinfo
echo -n "Choose: "
read continent

while [[ ! -d /usr/share/zoneinfo/$continent ]]; do
    echo "It wasn't on that list, try again."
    read continent
done

ls /usr/share/zoneinfo/$continent
echo -n "Choose: "
read city

while [[ ! -f /usr/share/zoneinfo/$continent/$city ]]; do
    echo "It wasn't on that list, try again."
    read city
done

ln -sf "/usr/share/zoneinfo/$continent/$city" /etc/localtime

hwclock --systohc
systemctl enable --now systemd-timesyncd.service

echo -e "Set Locale as in /etc/locale.gen (es. en_US):"
read locale
sed -i -e "/^#$locale/s/^#//" /etc/locale.gen
locale-gen

flocale=(`grep -m 1 "^$locale" /etc/locale.gen`)
echo "LANG=$flocale" > /etc/locale.conf

echo -n "Choose name for computer: "
read hostname
echo $hostname > /etc/hostname

echo -e "127.0.0.1\tlocalhost\n::1\t\tlocalhost\n127.0.1.1\t$hostname.localdomain\t$hostname" > /etc/hosts

echo "Set root password:"
passwd


# Check UEFI Support
echo "Verifying boot type (BIOS, UEFI)..."
if [ -e /sys/firmware/efi/efivars ]; then
    echo "UEFI Supported"
    uefi=true
else
    echo "UEFI Not Supported, Proceed (y|N)?"
    read answ
    [[ $answ != "y" ]] && exit 
    uefi=false
fi

# Install GRUB
pacman -S grub

if [[ $uefi = true ]]; then
    echo "Install UEFI GRUB"
    pacman -S efibootmgr
    grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
# else
#     echo "Install BIOS GRUB"
#     grub-install --target=i386-pc "/dev/${partitions[2]}"
fi

grub-mkconfig -o /boot/grub/grub.cfg
