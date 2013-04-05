#!/bin/bash


#
#             Configuration
# - - - - - - - - - - - - - - - - - - - - - -

dotfiles_repo='git@github.com:mattmcmanus/dotfiles.git'

# Apps to install
apps=(chrome virtualbox vagrant dropbox onepassword sublimetext2 evernote)

# URLs for app downloads
# Make sure all apps listed above have associated urls
vagrant_url='http://files.vagrantup.com/packages/64e360814c3ad960d810456add977fd4c7d47ce6/Vagrant.dmg' #1.1.5
chrome_url='https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg'
dropbox_url='https://www.dropbox.com/download?plat=mac'
onepassword_url='https://d13itkw33a7sus.cloudfront.net/dist/1P/mac/1Password-3.8.20.zip'
virtualbox_url='http://download.virtualbox.org/virtualbox/4.2.10/VirtualBox-4.2.10-84104-OSX.dmg'
sublimetext2_url='http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.1.dmg'
evernote_url='http://www.evernote.com/about/download/get.php?file=EvernoteMac'


#
#     Functions make things easier!
# - - - - - - - - - - - - - - - - - - - - - -

function installApp {
  shopt -s nullglob

  name=$1
  download="~/Downloads/$name.dmg"
  mountpoint="/Volumes/$name"

  curl -L -o $download $${name}_url
  hdiutil attach -mountpoint $mountpoint $download

  # Test if there is a pkg or app file and run the appropriate installer
  cd $mountpoint
  [ -z "`echo *.pkg`" ] && sudo installer -package *.pkg -target /
  [ -z "`echo *.app`" ] && cp -R *.app /Applications/

  hdiutil detach $mountpoint
}


#
#         Commence Installations
# - - - - - - - - - - - - - - - - - - - - - -

#0. Install XCode
# Not sure how to check this just yet

#1. Install homebrew
ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"

# 2. Install some goodies
brew update
brew install git grc coreutils ack findutils gnu-tar tmux

# 3. Setup dotfiles repo
cd $HOME
git clone $dotfiles_repo .dotfiles
cd .dotfiles
script/bootstrap

# 4. Install NVM
curl https://raw.github.com/creationix/nvm/master/install.sh | sh
nvm install 0.10

# 5. Install dmg'ed apps
for app in "${apps[@]}"
do
  installApp $app
done