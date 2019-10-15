xrdb -merge ~/.Xresources &
setxkbmap -option caps:swapescape &
setxkbmap -layout "us,it" -option "grp:alt_shift_toggle" &
xset r rate 200 30 &
exec awesome
