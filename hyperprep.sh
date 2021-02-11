#!/bin/bash

dotfiles_location="$HOME/.dotfiles/hypergenesis"

mkdir -p $dotfiles_location

brew tap > $dotfiles_location/homebrew-taps.txt
brew ls --formula| grep -v brew-cask > $dotfiles_location/homebrew-installs.txt
brew ls --cask > $dotfiles_location/homebrew-cask-installs.txt
ls -1 /Applications/ > $dotfiles_location/applications-reference.txt

# ls -1 $HOME/.nvm/versions/node/`nvm current`/bin | grep -v node| grep -v npm > $dotfiles_location/npm-global-installs.txt

echo '===================================================================='
echo '       Dont forget to commit and push your dotfiles'
echo '===================================================================='
