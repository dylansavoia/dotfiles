#!/bin/bash

shopt -s dotglob
cd dotfiles
cp --parents -av --backup=numbered * ~
