# History
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000

shopt -s histappend
shopt -s checkwinsize
shopt -s autocd

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Prompt colors
PS1='\[\e[1;32m\]\w\[\e[0m\] \$ '

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# set PATH so it includes user's private bin directories
PATH="$PATH:$HOME/.local/scripts/:."

#############################################################
######################    Custom     ########################
#############################################################
export INPUTRC="~/.config/inputrc"
export EDITOR="nvim"
export TERMINAL=alacritty
export BROWSER=qutebrowser
export LS_COLORS='di=1;93'

#############################################################
######################    Aliases    ########################
#############################################################
alias normalize="mp3gain -r *"
alias calc="bpython -i ~/.local/scripts/calc.py"
alias recordmydesktop='recordmydesktop --no-frame --v_quality 1 --v_bitrate 2000000'
alias emacs="emacsclient -c"
alias autocrop='mogrify -trim +repage'

# Mounts
alias mserver="sshfs dylansavoia@dylansavoia.sytes.net:/srv/http/Main /media/dylansavoia/server"
alias umserver="sudo umount /media/dylansavoia/server"
alias mphone="jmtpfs /media/dylansavoia/phone"
alias umphone="sudo umount /media/dylansavoia/phone"
alias server="mountpoint -q /media/dylansavoia/server/ || mserver; vifm /media/dylansavoia/server/"
alias phone="mountpoint -q /media/dylansavoia/phone/ || mphone; vifm /media/dylansavoia/phone/"

function cphoto () {
    mogrify -sampling-factor 4:2:0 -quality 85 "$@"
}

function aur_install () {
    git clone "https://aur.archlinux.org/$1.git" "$HOME/.local/bin/$1" &&
    cd "$HOME/.local/bin/$1" &&
    makepkg -si
}


# >>> conda initialize >>>
function conda_init () {
    __conda_setup="$('/home/dylansavoia/.miniconda/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "/home/dylansavoia/.miniconda/etc/profile.d/conda.sh" ]; then
            . "/home/dylansavoia/.miniconda/etc/profile.d/conda.sh"
        else
            export PATH="/home/dylansavoia/.miniconda/bin:$PATH"
        fi
    fi
    unset __conda_setup
}
# <<< conda initialize <<<
