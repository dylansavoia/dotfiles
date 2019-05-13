#!/bin/bash
if [[ "$1" == "switch" ]]; then
    switch=($(pactl list short sinks | awk '/SUSPENDED|IDLE/ {print $2}'))
    pactl set-default-sink $switch

    ins=($(pactl list short sink-inputs | awk '{print $1}'))

    for input in ${ins[@]}; do
        pacmd move-sink-input $input $switch 
    done 

else
    sink=$(pactl list short sinks | awk '/RUNNING/ {print $1}')
    [[ "$sink" == "" ]] && sink=1
    if [[ "$1" == "toggle" ]]; then
        pactl set-sink-mute $sink toggle
    else
        pactl set-sink-volume $sink $1 
    fi
fi
