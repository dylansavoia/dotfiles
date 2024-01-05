#!/bin/bash

dev=$1
dotdir="./restore/arch"
tmpdir="/tmp/dotdir/"

vardir=./restore/variables
themes=(`ls -1d "$vardir"/*/ | cut -d / -f4`)
default_theme=`cat .current_theme`

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

# Choose Theme
if [[ "$3" == "" ]]; then
    echo "Choose Theme (Default \"$default_theme\"):"
    echo ${themes[*]} | tr ' ' '\n' | nl -v 0 -w 1
    read theme

    if [[ $theme == "" ]]; then
        theme=$default_theme
    elif [ $theme -ge ${#themes[*]} ]; then
        echo "Theme Out Of Boundaries"
        exit 1
    else
        theme=${themes[$theme]}
    fi
fi

## Save current theme name
echo -e "\nSelected Theme:\t\t$theme"
echo "$theme" > .current_theme


# Create Copy
cp -a "$dotdir" "$tmpdir"
for file in "$tmpdir"/*; do
    base_name=$(basename "$file")
    new_path="$tmpdir/.$base_name"
    mv "$file" "$new_path"
done

## Apply Substitutions
# NOTE: sed can use any character as a delimiter instead of /

### meta substitution for colorscheme
clrcmd=`head -n 16 "$vardir/$theme/colorscheme" |
     awk -F = '{print "s@{{" $1 "}}@" $2 "@"}' | tr '\n' ';'`
clrscheme=`sed "$clrcmd" "$vardir/$theme/colorscheme"`

### Create sed command 
sedcmd=`cat $vardir/$dev $vardir/default <(echo "$clrscheme") |
     sort -u -t= -k1,1 |
     awk -F = '{print "s@{{" $1 "}}@" $2 "@"}' | tr '\n' ';'`

### Apply sed to all $sed_files
for f in $sed_files; do sed -i "$sedcmd" "$tmpdir/$f"; done

### Wallpaper
echo -n "Download wallpaper? (y|N): "
read answ
[[ $answ == "y" ]] && scp `cat "$vardir/$theme/wallpaper.url"` "$tmpdir.config/awesome/wallpaper.jpg"

echo "Press Enter to apply changes. (Abort Ctrl-C)"
read

## Modify System Files
# sudo cp "$vardir/$theme/wallpaper.jpg" /usr/share/lightdm-webkit/themes/lightdm-webkit-theme-aether/src/img/wallpapers/main_wallpaper.jpg

### Everything else
shopt -s dotglob
cd "$tmpdir"
cp --parents -a * ~
cd ".."

## Cleanup
rm -rf "$tmpdir"

## Final Application
xrdb -merge "$HOME/.Xresources"
qutebrowser :config-source :reload
awesome-client "commons=require('commons'); commons.save_state(); awesome.restart()"
