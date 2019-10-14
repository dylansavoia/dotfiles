#!/bin/bash

maindir=`pwd`

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
    awesome rofi libnotify compton pulseaudio pasystray \
    git openssh python jupyter-notebook bpython unzip \
    ttf-liberation ttf-font-awesome noto-fonts
# pacman -S networkmanager network-manager-applet

## Applications
pacman -S ffmpeg imagemagick arandr vlc sxiv \
    vifm neovim qutebrowser zathura zathura-pdf-mupdf libreoffice-fresh \
    firefox virtualbox \
    entr rsync rclone wget curl tree htop pdfgrep \
    lxappearance arc-gtk-theme arc-icon-theme \
    python-numpy python-eyed3 python-pip

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
git clone https://aur.archlinux.org/mp3gain.git
git clone https://aur.archlinux.org/jmtpfs.git
git clone https://aur.archlinux.org/xst-git.git

for app in `ls "/home/$username/.local/bin/"`; do
    echo "Installing $app"
    cd "/home/$username/.local/bin/$app"
    makepkg -si
    cd ..
done

cd "/home/$username/.local/bin/xst-git/src/xst/"
cp "$maindir/patches/xst/config.h" "./src/"
make
sudo make install

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

# Manually? pdfjs (for qutebrowser) ardour conda lightdm tex
# lxappearance: change to arc
