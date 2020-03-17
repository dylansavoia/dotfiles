[[ -r ~/.bashrc ]] && . ~/.bashrc
export DESKTOP_SESSION=gnome

# Start graphical server if not already running.
if [ "$(tty)" = "/dev/tty1" ]; then
	pgrep -x awesome || exec startx
fi
