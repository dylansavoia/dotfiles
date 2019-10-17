[[ -r ~/.bashrc ]] && . ~/.bashrc

# Start graphical server if bspwm not already running.
if [ "$(tty)" = "/dev/tty1" ]; then
	pgrep -x awesome || exec startx
fi
