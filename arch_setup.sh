#!/bin/bash

# Create User  
echo -e"Create default user and edit /etc/sudoers file\n(You may just want to uncomment the wheel option)\nUsername: "
read username

adduser -m -g wheel $username
passwd $username
visudo

# Network Config
echo "noarp" >> /etc/dhcpcd.conf

# Install Packages
## Essential
pacman -S xorg-server xorg-xinit xorg-xrandr
pacman -S bspwm sxhkd rofi libnotify dunst compton pulseaudio
pacman -S git openssh feh python jupyter-notebook bpython
# pacman -S networkmanager

## Applications
pacman -S ffmpeg imagemagick arandr mpv sxiv                    # Image/Video
pacman -S vifm neovim qutebrowser zathura libreoffice-fresh     # Office
pacman -S firefox virtualbox                                    # Office
pacman -S entr rsync wget curl                                  # Utilities


## AUR
mkdir -p "/home/$username/.local/bin/"
cd "/home/$username/.local/bin/"

## rclone
curl https://rclone.org/install.sh | sudo bash

git clone https://aur.archlinux.org/dropbox.git
git clone https://aur.archlinux.org/polybar.git
git clone https://aur.archlinux.org/st.git
git clone https://aur.archlinux.org/jmtpfs.git

## Other
### Create RSA key for server
echo "Creating RSA key for server..."
ssh-keygen -t rsa
ssh-copy-id dylansavoia@dylansavoia.sytes.net

# Setup Imagemagick for pdf preview
# ... change in /etc/ImageMagick-6/policy.xml: pdf none to read|write
# Manually? pdfjs (for qutebrowser) tesseract-ocr ardour conda lightdm
