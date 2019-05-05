#!/bin/bash

shopt -s dotglob
cd ~/dotfiles
cp -rv --backup=numbered * ~
