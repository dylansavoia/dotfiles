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

echo "You now have to reboot"
