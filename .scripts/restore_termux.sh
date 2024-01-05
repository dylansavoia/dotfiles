#!/bin/bash

shopt -s dotglob
cd "./restore/termux"
cp --parents -aL * ~
echo "Copied configuration"

sed -i -e '/icons/d' ~/.config/vifm/vifmrc
