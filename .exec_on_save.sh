#!/bin/bash
[[ $1 != "restore/arch/"* ]] && exit
notify-send "Updating File: $1"

vardir=./restore/variables
theme=`cat .current_theme`
dev='laptop'
[[ $(</sys/class/dmi/id/chassis_type) == 3 ]] && dev='desktop'

clrcmd=`head -n 16 "$vardir/$theme/colorscheme" |
     awk -F = '{print "s@{{" $1 "}}@" $2 "@"}' | tr '\n' ';'`
clrscheme=`sed "$clrcmd" "$vardir/$theme/colorscheme"`

sedcmd=`cat $vardir/$dev $vardir/default <(echo "$clrscheme") |
     sort -u -t= -k1,1 |
     awk -F = '{print "s@{{" $1 "}}@" $2 "@"}' | tr '\n' ';'`

sed "$sedcmd" "$1" > "$1.copy"
mv "$1.copy" "$HOME/.${1#*/}" 
