#!/bin/bash

echo "This is to be executed from the new system. Do you know what you're doing?"
read

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

# Locale
echo -e "Set Region and City as in /usr/share/zoneinfo\n(es. Europe Rome):"
read city
city=( $city )
ln -sf "/usr/share/zoneinfo/${city[0]}/${city[1]}" /etc/localtime

hwclock --systohc

echo -e "Set Locale as in /etc/locale.gen (es. en_US):"
read locale
sed -i -e "/$locale/s/^#//" /etc/locale.gen
locale-gen

flocale=`grep $locale /etc/locale.gen | head -1`
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

# Create User  
echo -e "Create default user and edit /etc/sudoers file\n(You may just want to uncomment the wheel option)\nUsername: "
read username

useradd -m -g wheel $username
passwd $username
visudo

# Network Config
echo "noarp" >> /etc/dhcpcd.conf

# Install Packages
## Essential
pacman -S xorg-server xorg-xinit xorg-xrandr xsel bash-completion
pacman -S awesome rofi libnotify compton pulseaudio
pacman -S git openssh feh python jupyter-notebook bpython unzip
pacman -S ttf-liberation noto-fonts
# pacman -S networkmanager

## Applications
pacman -S ffmpeg imagemagick arandr vlc sxiv                    # Image/Video
pacman -S vifm neovim qutebrowser zathura zathura-pdf-mupdf libreoffice-fresh     # Office
pacman -S firefox virtualbox                                    
pacman -S entr rsync rclone wget curl tree htop pdfgrep         # Utilities
pacman -S lxappearance arc-gtk-theme arc-icon-theme

pacman -S python-numpy python-eyed3 python-pip                  # Python Essentials
pip install pynvim


## AUR
mkdir -p "/home/$username/.local/bin/"
mkdir -p "/media/$username/phone"
mkdir -p "/media/$username/server"
mkdir -p "/media/$username/default"
cd "/home/$username/.local/bin/"

## rclone
curl https://rclone.org/install.sh | sudo bash

git clone https://aur.archlinux.org/dropbox.git
git clone https://aur.archlinux.org/polybar.git
git clone https://aur.archlinux.org/xst-git.git
git clone https://aur.archlinux.org/mp3gain.git
git clone https://aur.archlinux.org/jmtpfs.git
git clone https://aur-dev.archlinux.org/tesseract-git.git
pacman -S tesseract-data-eng

echo "Install youtube-dl:"
curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
chmod a+rx /usr/local/bin/youtube-dl

## Other
### Create RSA key for server
echo "Creating RSA key for server..."
ssh-keygen -t rsa
ssh-copy-id dylansavoia@dylansavoia.sytes.net

echo "Check arch_setup.sh comments for last steps."
# Setup Imagemagick for pdf preview
# ... change in /etc/ImageMagick-6/policy.xml: pdf none to read|write
# Manually? pdfjs (for qutebrowser) tesseract-ocr ardour conda lightdm
