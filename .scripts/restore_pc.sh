#!/bin/bash

dev=$1
theme=$2

dotdir="./dotdir"

sed_files='
.config/qutebrowser/config.py
.config/qutebrowser/custom.css
.config/awesome/theme.lua
.config/vifm/folders
.config/laser/laserrc
.config/zathura/zathurarc
.config/alacritty/alacritty.toml
.config/rofi/themes/shared/settings.rasi
.Xresources
'

# Create Copy
cp -a "$dotdir" "${dotdir}_tmp"
for file in "${dotdir}_tmp"/*; do
    base_name=$(basename "$file")
    new_path="${dotdir}_tmp/.$base_name"
    mv "$file" "$new_path"
done

## Apply Substitutions
# NOTE: sed can use any character as a delimiter instead of /

### meta substitution for colorscheme
clrcmd=`head -n 16 $vardir/$theme/colorscheme |
     awk -F = '{print "s@{{" $1 "}}@" $2 "@"}' | tr '\n' ';'`
clrscheme=`sed "$clrcmd" "$vardir/$theme/colorscheme"`

### Create sed command 
sedcmd=`cat $vardir/$dev $vardir/default <(echo "$clrscheme") |
     sort -u -t= -k1,1 |
     awk -F = '{print "s@{{" $1 "}}@" $2 "@"}' | tr '\n' ';'`

### Apply sed to all $sed_files
for f in $sed_files; do sed -i "$sedcmd" "./dotdir_tmp/$f"; done

### Wallpaper
echo -n "Download wallpaper? (y|N): "
read answ
[[ $answ == "y" ]] && scp `cat "$vardir/$theme/wallpaper.url"` ./dotdir_tmp/.config/awesome/wallpaper.jpg

echo "Press Enter to apply changes. (Abort Ctrl-C)"
read

## Modify System Files
# sudo cp "$vardir/$theme/wallpaper.jpg" /usr/share/lightdm-webkit/themes/lightdm-webkit-theme-aether/src/img/wallpapers/main_wallpaper.jpg

### Everything else
shopt -s dotglob
cd "${dotdir}_tmp"
cp --parents -a * ~
cd ".."

## Cleanup
rm -rf "${dotdir}_tmp"

## Final Application
xrdb -merge "$HOME/.Xresources"
qutebrowser :config-source :reload
awesome-client "commons=require('commons'); commons.save_state(); awesome.restart()"
