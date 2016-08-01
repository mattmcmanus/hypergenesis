#!/bin/bash

dotfiles_location="$HOME/.dotfiles/hypergensis"

mkdir -p $dotfiles_location

brew tap > $dotfiles_location/homebrew-taps.txt
brew ls | grep -v brew-cask > $dotfiles_location/homebrew-installs.txt
brew cask list > $dotfiles_location/homebrew-cask-installs.txt
ls -1 /Applications/ > $dotfiles_location/applications-reference.txt

# ls -1 $HOME/.nvm/versions/node/`nvm current`/bin | grep -v node| grep -v npm > $dotfiles_location/npm-global-installs.txt

echo '===================================================================='
echo '       Dont forget to commit and push your dotfiles'
echo '===================================================================='
