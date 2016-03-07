#!/bin/bash

set -e

#
#             Configuration
# - - - - - - - - - - - - - - - - - - - - - -

dotfiles_repo='git@github.com:mattmcmanus/dotfiles.git'
dotfiles_location="$HOME/.dotfiles"

hypergenesis_file_lists="$dotfiles_location/hypergensis"
homebrew_taps="$hypergenesis_file_lists/homebrew-taps.txt"
homebrew_installs="$hypergenesis_file_lists/homebrew-installs.txt"
homebrew_cask_installs="$hypergenesis_file_lists/homebrew-cask-installs.txt"
npm_gloabl_installs="$hypergenesis_file_lists/npm-gloabl-installs.txt"


#
#     Functions make things easier!
# - - - - - - - - - - - - - - - - - - - - - -
log() {
  echo ""
  echo " ==> $1"
  echo ""
}

#
#         Commence Installations
# - - - - - - - - - - - - - - - - - - - - - -

#if [[ ! $(pkgutil --pkg-info=com.apple.pkg.DeveloperToolsCLI) ]]; then
#  xcode-select --install
#
#  echo "ERROR: XCode command line tools are NOT installed. The install should popup now. Retart your terminal when complete. Exiting..."
#  echo ""
#  echo "If you need help installing, go to http://stackoverflow.com/a/9329325/109589"
#  exit 1
#fi

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
echo '      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * '
echo ''
echo 'This script will do the following:'
echo ''
echo "1. Setup your dotfiles ($dotfiles_repo) into $dotfiles_location"
echo '2. Install homebrew'
echo "3. brew tap everything listed in $homebrew_taps"
echo "4. brew install everything listed in $homebrew_installs"
echo "5. brew cask install $homebrew_cask_installs"
echo "6. Install NVM and the latest stable node.js"
echo "7. npm install -g everything list in $npm_gloabl_installs"
echo "8. Install RVM and the latest stable ruby"
echo ''

read -p "Are you ok with this? " -n 1

if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi
echo ""

# Setup dotfiles
[ ! -d $dotfiles_location ] && (
  log "Setting up your dotfiles repo"
  git clone $dotfiles_repo $dotfiles_location
)

# Install homebrew
[[ ! $(which brew) ]] &&
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" &&
  brew doctor

brew update

if [[ ! -f $homebrew_taps]]; then
  while read line; do
    [[ $(brew tap-info $line | grep "Not installed") ]] &&
      log "brew tap $line" && brew tap $app
  done < "$homebrew_taps"
fi

if [[ ! -f $homebrew_installs]]; then
  while read line; do
    [[ $(brew info $line | grep "Not installed") ]] &&
      log "brew install $line" && brew install $line
  done < "$homebrew_installs"
fi

if [[ ! -f $homebrew_cask_installs]]; then
  while read line; do
    [[ $(brew cask info $line | grep "Not installed") ]] &&
      log "brew cask install $line" && brew cask install $line
  done < "$homebrew_cask_installs"
fi

# Reload Quicklook
qlmanage -r

rcup

# Install node
[ ! -d $HOME/.nvm ] && (
  log "Installing NVM"
  curl https://raw.github.com/creationix/nvm/master/install.sh | sh
  source ~/.bash_profile
  nvm install stable
  nvm alias default stable
)

if [[ ! -f $npm_gloabl_installs]]; then
  while read line; do
    [[ -z $(npm ls -gp $line) ]] && (
      log "npm install -g $line" && npm install -g $line
    )
  done < "$npm_gloabl_installs"
fi

[ ! -d $HOME/.rvm ] && (
  log "Installing RVM"
  \curl -sSL https://get.rvm.io | bash -s stable --ruby
)

[[ ! $(which bundler) ]] && (
  gem update --system
  gem install bundler --no-document --pre
  number_of_cores=$(sysctl -n hw.ncpu)
  bundle config --global jobs $((number_of_cores - 1))
 )

[[ ! $(which foreman) ]] &&
  curl -sLo /tmp/foreman.pkg http://assets.foreman.io/foreman/foreman.pkg && \
  sudo installer -pkg /tmp/foreman.pkg -tgt /


echo '                        ________  _            '
echo '                       |_   __  |(_)           '
echo '                         | |_ \_|__   _ .--.   '
echo '                         |  _|  [  | [ `.-. |  '
echo '                        _| |_    | |  | | | |  '
echo '                       |_____|  [___][___||__] '
echo '                                               '
