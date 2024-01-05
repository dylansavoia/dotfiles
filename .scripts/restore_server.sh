#!/bin/bash

shopt -s dotglob
cd "./restore/server"
cp --parents -aL * ~
echo "Copied config files"

fcrontab crontab
rm ~/crontab
