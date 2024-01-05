#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias wol_fractal='wol 04:d4:c4:52:e9:8c'

export EDITOR=nvim
PS1='[\u@\h \W]\$ '
umask 0006

