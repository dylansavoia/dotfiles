#!/bin/bash

# Create User  
echo -e "Create default user and edit /etc/sudoers file\n(You may just want to uncomment the wheel option)\nUsername: "
read username

adduser -m -g wheel $username
passwd $username
visudo

# Network Config
echo "noarp" >> /etc/dhcpcd.conf

# Install Packages
## Essential
pacman -S xorg-server xorg-xinit xorg-xrandr xsel bash-completion
pacman -S bspwm sxhkd rofi libnotify dunst compton pulseaudio
pacman -S git openssh feh python jupyter-notebook bpython unzip
pacman -S ttf-liberation noto-fonts
# pacman -S networkmanager

## Applications
pacman -S ffmpeg imagemagick arandr mpv sxiv                    # Image/Video
pacman -S vifm neovim qutebrowser zathura libreoffice-fresh     # Office
pacman -S firefox virtualbox                                    
pacman -S entr rsync rclone wget curl tree htop                 # Utilities

pacman -S python-numpy python-eyed3 python-pip                  # Python Essentials
sudo pip install pynvim


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
sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
sudo chmod a+rx /usr/local/bin/youtube-dl

## Other
### Create RSA key for server
echo "Creating RSA key for server..."
ssh-keygen -t rsa
ssh-copy-id dylansavoia@dylansavoia.sytes.net

# Setup Imagemagick for pdf preview
# ... change in /etc/ImageMagick-6/policy.xml: pdf none to read|write
# Manually? pdfjs (for qutebrowser) tesseract-ocr ardour conda lightdm
