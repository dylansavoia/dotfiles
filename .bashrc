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

source /etc/bash_completion

######################################################
##################    Custom     #####################
######################################################

# Environment Defaults 
export INPUTRC="~/.config/i3/inputrc"
export EDITOR=nvim
export TERMINAL=st
export BROWSER=qutebrowser

# set PATH so it includes user's private bin directories
PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/.config/i3/scripts/:."

alias parallel="parallel --no-notice"
alias normalize="mp3gain -r *"
alias ffplay="ffplay -x 1"
alias extract="~/.config/i3/scripts/extract"
alias math="bpython3 -i ~/.config/i3/scripts/math.py"
alias vifm="/home/dylansavoia/.config/i3/scripts/vifmrun"

alias mserver="sshfs dylansavoia@dylansavoia.sytes.net:/var/www/html/Main /media/dylansavoia/server"
alias umserver="sudo umount /media/dylansavoia/server"
alias mstorage="sudo mount -U 01D1D60B2FF5D780 /media/dylansavoia/storage"
alias umstorage="sudo umount /media/dylansavoia/storage"
alias mphone="jmtpfs /media/dylansavoia/phone"
alias umphone="sudo umount /media/dylansavoia/phone"

alias server="mountpoint -q /media/dylansavoia/server/ || mserver; cd /media/dylansavoia/server/"
alias storage="mountpoint -q /media/dylansavoia/storage/ || mstorage; cd /media/dylansavoia/storage/"
alias phone="mountpoint -q /media/dylansavoia/phone/ || mphone; cd /media/dylansavoia/phone/"

# Scripts
alias makemake="~/.config/i3/scripts/makemake"

mnt () {
    sel=$(
            join -t $'\t' <(lsblk -l --output NAME,SIZE | nl) <(lsblk -lpb --output SIZE,TYPE,MOUNTPOINT | nl) |
            awk '/part $/ && $4 > 4096 {printf("%s\t\t%s\n"), $2, $3}' |
            rofi -dmenu |
            awk '{print $1}'
        )
    [[ "$sel" == "" ]] && return

    echo "Where do you want to mount $sel?"
    read mpoint

    [[ "$mpoint" == "" ]] && mpoint="default"

    mpoint="$mpoint"
    mountpoint -q $mpoint && pumount $mpoint

    pmount $sel $mpoint
    vifm "/media/$mpoint"
}

bookmark() {
    path=$(pwd)
    echo "nnoremap $1 :cd $path<CR>" >> ~/.config/vifm/folders
}

sortline() {
    read input
    output=$( echo $input | tr "," "\n" | sort -n | awk '{printf("%s, ",$1)}')
    echo ${output%??}
}

archive() {
    if [[ "$1" == "" ]]; then
        echo "OPTIONS: playlist [download|update] | drive"

    elif [[ "$1" == "playlist" || "$1" == "p" ]]; then
        if [[ "$2" == "download" || "$2" == "d" ]]; then
            youtube-dl -x --audio-format mp3 --audio-quality 0 https://www.youtube.com/playlist?list=PLtO5M4JOGPH4tzQVb61jCjukLQG-OkS9I
            # rclone move pi:/var/www/html/Files/playlist_update .
            # python3 ~/.config/i3/scripts/mp3_download.py &&
            # rm playlist_update

        elif [[ "$2" == "update" || "$2" == "u" ]]; then
            # Update Tags
            echo "Writing Tags..."
            python3 ~/.config/i3/scripts/mp3_tags.py .

            # Normalize
            echo "Do you want to normalize? (Y|n)";
            read answ
            [[ "$answ" == "" || "$answ" == "y" ]] && normalize

            # Copy Tracks to phone
            echo "Do you want to copy tracks on phone? (Y|n)";
            read answ

            if [[ "$answ" == "" || "$answ" == "y" ]]; then
                echo "Copying Tracks to phone..."
                mountpoint -q /media/dylansavoia/phone || jmtpfs /media/dylansavoia/phone
                [[ $? -ne 0 ]] && return
                cp * /media/dylansavoia/phone/SD\ card/Music/
                [[ $? -ne 0 ]] && (echo "Copy Failed"; return)

                # Update current_tracks
                ls /media/dylansavoia/phone/SD\ card/Music > current_tracks.txt
                rclone copy -v current_tracks.txt pcloud:/
                awk -F ' - ' '{gsub(/\(.+\)/, "", $2); print $2 }' current_tracks.txt > /media/dylansavoia/phone/SD\ card/Android/lib.txt
                rm current_tracks.txt
            fi

            # Update Library
            echo "Copying to Library"
            rclone -v copy . pcloud:Library

        fi

    elif [[ "$1" == "drive" ]]; then

        echo "System Files Backup..."

        mkdir -p ~/Documents/dotfiles/.config
        mkdir -p ~/Documents/dotfiles/.local
        mkdir -p ~/Documents/dotfiles/.local/qutebrowser

        # Home dotfiles
        rsync ~/.bashrc ~/Documents/dotfiles/
        rsync ~/.profile ~/Documents/dotfiles/
        rsync ~/.xinitrc ~/Documents/dotfiles/
        rsync ~/.Xresources ~/Documents/dotfiles/

        # .config and .local
        # rsync ~/.config/i3/ ~/Documents/dotfiles/.config/i3/
        rsync -r ~/.config/compton/ ~/Documents/dotfiles/.config/compton
        rsync -r ~/.config/polybar/ ~/Documents/dotfiles/.config/polybar/
        rsync -r --exclude plugged/ ~/.config/nvim/ ~/Documents/dotfiles/.config/nvim/
        rsync -r ~/.config/qutebrowser/ ~/Documents/dotfiles/.config/qutebrowser/
        rsync -r --exclude Trash/ ~/.config/vifm/ ~/Documents/dotfiles/.config/vifm/
        rsync -r ~/.config/rclone/ ~/Documents/dotfiles/.config/rclone/
        rsync -r ~/.config/dunst/ ~/Documents/dotfiles/.config/dunst
        rsync -r ~/.config/zathura/ ~/Documents/dotfiles/.config/zathura
        rsync -r ~/.config/laser/ ~/Documents/dotfiles/.config/laser

        rsync -r ~/.local/share/qutebrowser/greasemonkey/ ~/Documents/dotfiles/.local/qutebrowser/greasemonkey/
        rsync -r ~/.local/scripts/ ~/Documents/dotfiles/.local/scripts

        # rclone copy -v ~/Documents/dotfiles/ drive:Archive/Backups/PC/
    fi
}
