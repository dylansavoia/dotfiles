#!/bin/bash

function die () {
    echo $1
    exit
}

maindir=`pwd`

# Create User  
echo -e "Create default user and edit /etc/sudoers file\n(You may just want to uncomment the wheel option)\nUsername: "
read username

useradd -m -g wheel $username
passwd $username
export EDITOR=vi
visudo

# Network Config
echo "noarp" >> /etc/dhcpcd.conf

# Install Packages
## Essential
# udisk2: (u)mount in user space
# redshift: blue-light filter
# tesseract-data: OCR data for tesseract-git (from AUR)

pacman --noconfirm -S xorg-server xorg-xinit xorg-xrandr xclip bash-completion \
    lightdm lightdm-webkit2-greeter man grep wmctrl ripgrep \
    awesome rofi libnotify pulseaudio pasystray pavucontrol\
    git openssh sshfs python python-pip jupyter-notebook unzip \
    ttf-liberation ttf-font-awesome noto-fonts \
    cmake tesseract-data-eng redshift udisks2 networkmanager network-manager-applet


echo "Does your hardware required a battery? (Y|n)"
read answ
if [[ "$answ" == "" ]]; then
    pacman -S cbatticon
fi

systemctl enable lightdm.service
systemctl enable NetworkManager.service

## control backlight
echo -e 'ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", RUN+="/bin/chgrp wheel /sys/class/backlight/%k/brightness"\nACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", RUN+="/bin/chmod g+w /sys/class/backlight/%k/brightness"' > /etc/udev/rules.d/backlight.rules

## Applications
pacman --noconfirm -S ffmpeg imagemagick arandr mpv sxiv \
    qutebrowser python-adblock firefox zathura zathura-pdf-mupdf \
    vifm highlight handbrake unclutter \
    entr rsync rclone wget curl tree htop pdfgrep \
    lxappearance materia-theme arc-icon-theme \
    texlive-core texlive-latexextra texlive-science \
    python-eyed3

# pacman -S emacs ripgrep clang tar fd aspell aspell-en
pacman --noconfirm -S neovim nodejs ctags npm python-pynvim go

echo "Create directories..."
mkdir -p "/home/$username/{.local/bin,Downloads}"
mkdir -p "/media/$username/{phone,server,default}"
chown -R "$username":wheel "/home/$username"
chown -R "$username":wheel "/media/$username"

echo "From now on we'll proceed in user-space..."
read
su - "$username"

echo "Download dotfiles..."
cd "$maindir"
git clone https://github.com/dylansavoia/dotfiles.git

if [[ ! -e "/dotfiles" ]]; then
    cd "$maindir/dotfiles"
    bash "./dotfiles" restore

    echo "Copying AccountsService files for lightdm..."
    cp -ar dotdir/install/structural/lightdm/AccountsService /var/lib/

    rm -rf "$maindir/dotfiles"

else
    echo "[WARNING] dotfiles NOT downloaded."
    read
fi

## Install non-repository applications
echo -n "Install non-repository apps\n(rclone, youtube-dl, miniconda, ...)"

cd "/home/$username/.local/bin/"

echo "Install youtube-dl:"
curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
chmod a+rx /usr/local/bin/youtube-dl

echo "Installing miniconda (note: specify /home/username/.miniconda as dir)..."
read
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
rm Miniconda3-latest-Linux-x86_64.sh

## AUR
git clone https://aur.archlinux.org/yay.git
cd yay; makepkg -si
yay --useask -S mp3gain jmtpfs tesseract-git pdfjs mons \
    chromium-widevine xmacro dragon-drag-and-drop-git \
    lightdm-webkit-theme-aether picom-jonaburg-git

echo "Attempt to create RSA key for server..."
ssh-keygen -t rsa
ssh-copy-id dylansavoia@dylansavoia.sytes.net

echo "It may be required to copy over the lightdm.conf configuration from the structural/lightdm directory"
