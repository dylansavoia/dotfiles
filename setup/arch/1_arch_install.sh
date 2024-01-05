#!/bin/bash

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

echo "Do you need to create partitions? (Y|n):"
read answ
if [[ $answ == "" ]]; then
    lsblk
    echo "Which device? (es. sda)"
    read answ
    fdisk /dev/"$answ"
fi

echo "Do you need to connect to Wi-Fi? (Y|n):"
read answ
if [[ $answ == "" ]]; then
    wifi-menu
fi

# Mount Partitions
lsblk
echo -e "Specify the names for the root, home, boot and swap devices\n(es. sda1 sda2 sda3 sda4):"
read partitions
partitions=( $partitions )

mkfs.ext4 "/dev/${partitions[0]}"
mkfs.ext4 "/dev/${partitions[1]}"
mkfs.fat -F32 "/dev/${partitions[2]}"

mkswap "/dev/${partitions[3]}"
swapon "/dev/${partitions[3]}"


echo "/dev/${partitions[0]} --> /mnt"
mount "/dev/${partitions[0]}" /mnt

mkdir -p /mnt/home
echo "/dev/${partitions[1]} --> /mnt/home"
mount "/dev/${partitions[1]}" /mnt/home

mkdir -p /mnt/boot
echo "/dev/${partitions[2]} --> /mnt/boot"
mount "/dev/${partitions[2]}" /mnt/boot

# Install Arch Linux
timedatectl set-ntp true
pacstrap /mnt base base-devel linux linux-firmware

# Setup
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt ./2_arch_chroot.sh

echo "Reboot. Press any key to continue"
read
reboot


