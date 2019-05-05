touch /home/dylansavoia/.local/share/udev_kb
ls /home/dylansavoia/.local/share/udev_kb | entr /home/dylansavoia/.local/scripts/udev_kb &
xrdb -merge ~/.Xresources &
~/.local/scripts/monitors &
exec i3
