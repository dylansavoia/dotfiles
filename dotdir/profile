export DESKTOP_SESSION=gnome

# Clean
# export XDG_DATA_HOME="$HOME/.local/share"
# export XDG_CONFIG_HOME="$HOME/.config"
# export XDG_CACHE_HOME="$HOME/.cache"
# export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
# export GNUPGHOME="$XDG_DATA_HOME"/gnupg
# export IPYTHONDIR="$XDG_CONFIG_HOME"/jupyter
# export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc
# export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
# export LESSHISTFILE=-
# export CUDA_CACHE_PATH="$XDG_CACHE_HOME"/nv

[[ -r ~/.bashrc ]] && . ~/.bashrc

# Start graphical server if not already running.
if [ "$(tty)" = "/dev/tty1" ]; then
	pgrep -x awesome || exec startx
fi
