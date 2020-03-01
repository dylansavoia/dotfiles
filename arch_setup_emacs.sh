#!/bin/bash

maindir=`pwd`

# Locale
echo -e "Set Region and City as in /usr/share/zoneinfo\n(es. Europe Rome):"
read city
city=( $city )
ln -sf "/usr/share/zoneinfo/${city[0]}/${city[1]}" /etc/localtime

hwclock --systohc
systemctl enable --now systemd-timesyncd.service

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
pacman -S xorg-server xorg-xinit xorg-xrandr xsel bash-completion \
    lightdm lightdm-gtk-greeter \
    awesome rofi libnotify compton pulseaudio pasystray \
    git openssh python jupyter-notebook bpython unzip \
    ttf-liberation ttf-font-awesome noto-fonts \
    cmake tesseract-data-eng
# pacman -S networkmanager network-manager-applet

systemctl enable lightdm.service
systemctl enable NetworkManager.service

mkdir -p "/etc/lightdm/"
echo -e "[greeter]
theme-name = Arc-Dark
icon-theme-name = Arc
background = /usr/share/pixmaps/lightdm.jpg" > /etc/lightdm/lightdm-gtk-greeter.conf

mkdir -p "/usr/share/pixmaps/"
[[ -e "./dotdir" ]] && mv ./dotdir/.config/awesome/wallpaper.jpg /usr/share/pixmaps/lightdm.jpg

## Applications
pacman -S ffmpeg imagemagick arandr mpv sxiv \
    vifm qutebrowser zathura zathura-pdf-mupdf libreoffice-fresh \
    firefox virtualbox \
    entr rsync rclone wget curl tree htop pdfgrep \
    lxappearance arc-gtk-theme arc-icon-theme dconf-editor \
    python-eyed3

## For Emacs
pacman -S emacs ripgrep clang tar fd aspell aspell-en
git clone https://github.com/hlissner/doom-emacs ~/.emacs.d
~/.emacs.d/bin/doom install


echo "From now on we'll proceed in user-space..."
read
su - "$username"

## AUR
mkdir -p "/home/$username/.local/bin/"
mkdir -p "/media/$username/phone"
mkdir -p "/media/$username/server"
mkdir -p "/media/$username/default"
mkdir -p "/home/$username/Downloads"

cd "/home/$username/.local/bin/"

## rclone
curl https://rclone.org/install.sh | sudo bash

git clone https://aur.archlinux.org/dropbox.git
git clone https://aur.archlinux.org/mp3gain.git
git clone https://aur.archlinux.org/jmtpfs.git
git clone https://aur.archlinux.org/xst-git.git
git clone https://aur.archlinux.org/pdfjs.git


echo "Installing miniconda (note: specify /home/username/.miniconda as dir)..."
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh

for app in `ls "/home/$username/.local/bin/"`; do
    echo "Installing $app"
    cd "/home/$username/.local/bin/$app"
    makepkg -si
    cd ..
done

if [[ -e "./dotdir" ]]; then
    echo "dotdir found: copying configs..."
    bash ./dotfiles restore 

    echo "Compiling xst with new config.h"
    cd "/home/$username/.local/bin/xst-git/src/xst/"
    make
    sudo make install

fi


echo "Install youtube-dl:"
curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
chmod a+rx /usr/local/bin/youtube-dl

## Other
### Create RSA key for server
# echo "Creating RSA key for server..."
# ssh-keygen -t rsa
# ssh-copy-id dylansavoia@dylansavoia.sytes.net

echo "Check arch_setup.sh comments for last steps."


echo "There are a few optional packages left..."

echo "LaTeX? (Y|n)"
if [[ "$answ" == "" ]]; then
    sudo pacman -S texlive-core texlive-latexextra texlive-science
fi

read answ
[[ "$answ" != "" ]] && exit

# ardour tex?
# lxappearance: change to arc
# sudo pacman -S cbatticon 
