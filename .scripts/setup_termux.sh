#!/bin/bash

echo "Setup Termux:"
pkg install git openssh neovim vifm

echo "Enable storage"
termux-setup-storage

source .scripts/restore_termux.sh
echo "Config copied"
