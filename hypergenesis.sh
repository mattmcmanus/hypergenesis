#!/bin/bash

set -e

#
#             Configuration
# - - - - - - - - - - - - - - - - - - - - - -

brewInstalls=(git grc coreutils ack findutils gnu-tar tmux htop-osx ctags nginx gnu-sed mobile-shell nmap)

dotfiles_repo='git@github.com:mattmcmanus/dotfiles.git'
dotfiles_location="$HOME/.dotfiles"

nodeVersion='0.10'
rubyVersion='1.9.3'

# Node apps to npm install -g
nodeGlobalModules=(jsontool node-dev express jade bunyan grunt-cli)

# Apps to install
#  - Make sure the name you use here is at least partially what the installed .app folder will be
#    This will make sure it doesn't try and reinstall it
osxApps=(chrome virtualbox vagrant password dropbox sublime evernote firefox iterm sequel rdio)

# URLs for app downloads
# Make sure all apps listed above have associated urls
vagrant_url='http://files.vagrantup.com/packages/7e400d00a3c5a0fdf2809c8b5001a035415a607b/Vagrant-1.2.2.dmg'
chrome_url='https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg'
firefox_url='https://download.mozilla.org/?product=firefox-21.0&os=osx&lang=en-US'
dropbox_url='https://www.dropbox.com/download?plat=mac'
password_url='https://d13itkw33a7sus.cloudfront.net/dist/1P/mac/1Password-3.8.20.zip'
virtualbox_url='http://download.virtualbox.org/virtualbox/4.2.12/VirtualBox-4.2.12-84980-OSX.dmg'
sublime_url='http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.1.dmg'
evernote_url='http://www.evernote.com/about/download/get.php?file=EvernoteMac'
iterm_url='https://iterm2.googlecode.com/files/iTerm2-1_0_0_20130319.zip'
sequel_url='http://sequel-pro.googlecode.com/files/sequel-pro-1.0.1.dmg'
rdio_url='http://www.rdio.com/media/static/desktop/mac/Rdio.dmg'
heroku_url='https://toolbelt.heroku.com/download/osx'


# An array of various vagrant repos to checkout
vagrantCheckoutDir="$HOME/dev"
vagrantRepos=('git@github.com:punkave/punkave-vagrant-lamp.git')


#
#     Functions make things easier!
# - - - - - - - - - - - - - - - - - - - - - -

log() {
  echo ""
  echo " ==> $1"
  echo ""
}

# Install an application
# 
# This function is pretty limited. Currently it can handle these scenarios
# - a dmg with an .app folder
# - a dmg with a .pkg file
# - a zip with an .app folder
# 
# It could be decoupled some to more dynamically handle more situations (zip -> pkg)

installApp() {
  name=$1
  url=$2
  
  # Is the app is already installed?
  [ ! -n "`find /Applications -maxdepth 1 -iname *$name*`" ] && 
  (
    shopt -s nullglob
  
    cd ~/Downloads/

    fileType=${url##*.}
    
    # We need to account for zips as well as dmgs
    [ $fileType == 'zip' ] && dest="$name.zip" || dest="$name.dmg"
    mountpoint="/Volumes/$name"

    log "Downloading $name from $url to $dest"
    
    [ ! -e $dest ] && 
    curl -L -o $dest "$url" --progress-bar
    
    if [ "$fileType" == 'zip' ]; then
      unzip $dest -q -d /Applications/

    else
      hdiutil attach -quiet -mountpoint $mountpoint $dest
      # Test if there is a pkg or app file and run the appropriate installer
      cd $mountpoint
      [ -e "`echo *.pkg`" ] && sudo installer -package *.pkg -target /
      [ -e "`echo *.app`" ] && cp -R *.app /Applications/
      cd ~
      sleep 3 # Give disk activity a chance to stop so hdiutil detach will not fail with a "busy device"
      hdiutil detach $mountpoint -force -quiet
    fi
    rm $HOME/Downloads/$dest

  ) || echo " - $name already installed"
}


#
#         Commence Installations
# - - - - - - - - - - - - - - - - - - - - - -

[[ ! $(pkgutil --pkg-info=com.apple.pkg.DeveloperToolsCLI) ]] &&
(
  echo "ERROR: XCode command line tools are NOT installed. Exiting..."
  echo ""
  echo "If you need help installing, go to http://stackoverflow.com/a/9329325/109589"
  exit 1 
)

echo ''
echo '       * * * * * * * * * * * * * * INITIATING * * * * * * * * * * * * * * '
echo''
echo '	    __  __                                                  '
echo '	   / / / /_  ______  ___  _______                           '
echo '	  / /_/ / / / / __ \/ _ \/ _____/                     _     '
echo '	 / __  / /_/ / /_/ /  __/ / ____/__  ____  ___  _____(_)____'
echo '	/_/ /_/\__, / .___/\___/_/ / __/ _ \/ __ \/ _ \/ ___/ / ___/'
echo '	      /____/_/          / /_/ /  __/ / / /  __(__  ) (__  ) '
echo '	                        \____/\___/_/ /_/\___/____/_/____/  '                                                      
echo ''
echo '       * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * '
echo ''
echo 'Please ensure that you have installed XCode and its command line tools. See README.md for more details'
echo ''
echo 'This script will do the following:'
echo ''
echo '2. Install homebrew'
echo "2. brew install ${brewInstalls[*]}"
echo "3. Setup your dotfiles ($dotfiles_repo) into $dotfiles_location"
echo "4. Install NVM and node.js $nodeVersion"
echo "5. npm install -g ${nodeGlobalModules[*]}"
echo "6. Install RVM and ruby $rubyVersion"
echo "7. Install ${osxApps[*]}"
echo "8. Setup vagrant development repos (${vagrantRepos[*]}) into $vagrantCheckoutDir"
echo ''

read -p "Are you ok with this? " -n 1
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi
echo ""

#0. Install XCode
# Not sure how to check this just yet

# Install homebrew
[ ! $(which brew) ] && 
(
  #log "Installing Homebrew"
  ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
) || log "Homebrew already installed. Updating and installing apps"

brew update

for app in "${brewInstalls[@]}"; do
  [ $(brew info $app | grep "Not installed") ] &&
  (
    log "brew install $app"
    brew install $app
   ) || echo " - $app already installed"
done


# Setup dotfiles
[ ! -d $dotfiles_location ] && 
(
  log "Setting up your dotfiles repo"
  git clone $dotfiles_repo $dotfiles_location
  cd $dotfiles_location
  script/bootstrap
  source ~/.bash_profile
) || log "dotfiles already installed. Skipping..."


# Install node
[ ! -d $HOME/.nvm ] && 
(
  log "Installing NVM"
  curl https://raw.github.com/creationix/nvm/master/install.sh | sh
  source ~/.bash_profile
  nvm install $nodeVersion
  nvm alias default 0.10
) || log "NVM already installed. Installing apps..."

for module in "${nodeGlobalModules[@]}"; do
  [[ -z $(npm ls -gp $module) ]] &&
  (
    log "npm install -g $module"
    npm install -g $module
  ) || echo " - $module already installed"
done


[ ! -d $HOME/.rvm ] && 
(
  log "Installing RVM"
  curl -L https://get.rvm.io | bash -s stable --ruby=$rubyVersion
) || log "RVM already installed. Skipping..."


log "Installing OS X Apps"

for app in "${osxApps[@]}"; do
  installApp $app $(eval "echo \$${app}_url") # Ew
done


# 6. Cloning vagrant repos
log "Cloning vagrant repos"
mkdir -p $vagrantCheckoutDir

for repo in "${vagrantRepos[@]}"; do
  cd $vagrantCheckoutDir

  basename=$(basename "$fullfile")
  name="${filename%.*}"

  [ ! -d $name ] && 
  (
    git clone $repo $name
    [ -e $name/.gitmodules ] &&
    (
      cd $name
      git submodule init
      git submodule update
    )
  )
done

echo '           ________  _            '
echo '          |_   __  |(_)           '
echo '            | |_ \_|__   _ .--.   '
echo '            |  _|  [  | [ `.-. |  '
echo '           _| |_    | |  | | | |  '
echo '          |_____|  [___][___||__] '
echo '                                  '
