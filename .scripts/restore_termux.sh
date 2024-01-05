#!/bin/bash

shopt -s dotglob
cd "./restore/termux"
cp --parents -aL * ~
echo "Copied configuration"
