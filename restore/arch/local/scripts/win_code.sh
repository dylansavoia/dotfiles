#!/bin/bash

wins=`wmctrl -l`
names=`echo "$wins"| cut -d ' ' -f5- | awk '{print "\t"$0}'`
codes=`echo "$wins"| cut -d ' ' -f1`
wins=`paste <(echo "$names") <(echo "$codes") |
    awk -F $'\t' '{print $1 "\t" $2, "[" $3 "]" }'`
sel=`echo -e "$wins" | rofi -dmenu -format 'd s' -i -p "Run" | cut -d $'\t' -f2`
code=`echo "$sel" | egrep -o '\[.+\]'`
echo "${code:1:-1}"
