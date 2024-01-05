#!/bin/bash

if [ -z "$1" ]; then
    xdotool type --delay 20 "dylansavoia	" `pass show dylansavoia.sytes.net/dylansavoia` ""
else
    xdotool type --delay 20 `pass show dylansavoia.sytes.net/dylansavoia` ""
fi
