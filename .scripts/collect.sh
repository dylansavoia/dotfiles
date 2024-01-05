#!/bin/bash
name="$1"

if [[ $name == '' ]]; then
    echo "Write dotfolder location:"
    read name
fi

if [[ -d "$name" ]]; then
    echo "$name already exists: overwrite? (y|N)"
    read answ
    [[ "$answ" != 'y' ]] && exit 1
fi

mkdir -p "$name"
# Home dotfiles
rsync ~/.bashrc         "$name"
rsync ~/.profile        "$name"
rsync ~/.xinitrc        "$name"
rsync ~/.Xresources     "$name"
rsync ~/.gtkrc-2.0      "$name"

# .config
mkdir -p "$name/.config"
rsync -a --delete ~/.config/inputrc      "$name/.config"
rsync -a --delete ~/.config/awesome      "$name/.config"
rsync -a --delete ~/.config/picom        "$name/.config"
rsync -a --delete ~/.config/rclone       "$name/.config"
rsync -a --delete ~/.config/zathura      "$name/.config"
rsync -a --delete ~/.config/kitty        "$name/.config"
rsync -a --delete ~/.config/rofi         "$name/.config"
rsync -a --delete ~/.config/laser        "$name/.config"
rsync -a --delete ~/.config/qutebrowser  "$name/.config"
rsync -a --delete ~/.config/gtk-3.0      "$name/.config"
rsync -a --delete ~/.config/sxiv         "$name/.config"

mkdir -p "$name/.config/coc"
rsync -a --delete ~/.config/coc/ultisnips  "$name/.config/coc"
rsync -a --delete ~/.config/nvim --exclude plugged --exclude spell  "$name/.config"
rsync -a --delete ~/.config/vifm --exclude Trash --exclude vifminfo "$name/.config"

# .local
mkdir -p "$name/.local"
mkdir -p "$name/.local/bin/qutebrowser"
rsync -a --delete ~/.local/scripts       "$name/.local"
rsync -a --delete ~/.local/share/qutebrowser/greasemonkey "$name/.local/bin/qutebrowser"
