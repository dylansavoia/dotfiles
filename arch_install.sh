#!/bin/bash

# Mount Partitions
echo "The installer assumes partitioning already performed. Continue? (Y|n)"
read answ
[[ $answ == "n" ]] && exit

echo -e "Specify the names for the root, home and boot devices\n(es. sda1 sda2 sda3):"
read partitions
partitions=( $partitions )

echo "/dev/${partitions[0]} --> /mnt"
mount "/dev/${partitions[0]}" /mnt

mkdir -p /mnt/home
echo "/dev/${partitions[1]} --> /mnt/home"
mount "/dev/${partitions[1]}" /mnt

mkdir -p /mnt/boot
echo "/dev/${partitions[2]} --> /mnt/boot"
mount "/dev/${partitions[2]}" /mnt/boot

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

# Install Arch Linux
timedatectl set-ntp true
pacstrap /mnt base base-devel

# Setup
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt

## Locale
echo -e "Set Region and City as in /usr/share/zoneinfo\n(es. Europe Rome):"
read city
city=( $city )
ln -sf "/usr/share/zoneinfo/${city[0]}/${city[1]}" /etc/localtime

hwclock --systohc

echo -e "Set Locale as in /etc/locale.gen (es. en_US):"
read locale
sed -e "/$locale/s/^#//"
locale-gen

flocale=`grep $locale | head -1`
echo "LANG=$flocale" > /etc/locale.conf

echo "Choose name for computer:"
read hostname
echo $hostname > /etc/hostname

echo -e "127.0.0.1\tlocalhost\n ::1\tlocalhost\n 127.0.1.1\t$hostname.localdomain\t$hostname" > /etc/hosts

echo "Set root password:"
passwd

# Install GRUB
pacman -S grub

if [[ $uefi = true ]]; then
    echo "Install UEFI GRUB"
    pacman -S efibootmgr
    grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
else
    echo "Install BIOS GRUB"
    grub-install --target=i386-pc "/dev/${partitions[2]}"
fi

grub-mkconfig -o /boot/grub/grub.cfg

# Done
echo "You can now Reboot"
