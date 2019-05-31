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
case "$TERM" in
    xterm-color|*-256color)
        color_prompt=yes;
esac

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\e[1;32m\]\w\[\e[0m\] \$ '
fi

unset color_prompt

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

source /usr/share/bash-completion/bash_completion

######################################################
##################    Custom     #####################
######################################################

# Environment Defaults 
export INPUTRC="~/.config/inputrc"
export EDITOR=nvim
export TERMINAL=xst
export BROWSER=qutebrowser

# set PATH so it includes user's private bin directories
PATH="$PATH:$HOME/.local/scripts/:."

alias normalize="mp3gain -r *"
alias ffplay="ffplay -x 1"
alias extract="~/.local/scripts/extract"
alias calc="bpython -i ~/.local/scripts/calc.py"

alias mserver="sshfs dylansavoia@dylansavoia.sytes.net:/var/www/html/Main /media/dylansavoia/server"
alias umserver="sudo umount /media/dylansavoia/server"
alias mphone="jmtpfs /media/dylansavoia/phone"
alias umphone="sudo umount /media/dylansavoia/phone"

alias server="mountpoint -q /media/dylansavoia/server/ || mserver; cd /media/dylansavoia/server/"
alias phone="mountpoint -q /media/dylansavoia/phone/ || mphone; cd /media/dylansavoia/phone/"

bookmark() {
    path=$(pwd)
    echo "nnoremap $1 :cd $path<CR>" >> ~/.config/vifm/folders
}

sortline() {
    read input
    output=$( echo $input | tr "," "\n" | sort -n | awk '{printf("%s, ",$1)}')
    echo ${output%??}
}
