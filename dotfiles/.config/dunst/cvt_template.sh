#!/bin/bash

colors=( $(grep -Eo '#[0-9A-Fa-f]{6,8}' /home/dylansavoia/.Xresources) )

sed -e "s/\[bkg0\]/${colors[0]}/" /home/dylansavoia/.config/dunst/dunstrc_template > /home/dylansavoia/.config/dunst/dunstrc
sed -i "s/\[acc0\]/${colors[4]}/" /home/dylansavoia/.config/dunst/dunstrc

