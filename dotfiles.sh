#!/bin/bash

shopt -s dotglob
cd ~/dotfiles
cp --parents -rv --backup=numbered dotfiles/* ~
