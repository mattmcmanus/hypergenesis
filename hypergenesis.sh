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
npm_global_installs="$hypergenesis_file_lists/npm-global-installs.txt"
mac_app_store_apps="$hypergenesis_file_lists/mac-app-store.txt"


#
#     Functions make things easier!
# - - - - - - - - - - - - - - - - - - - - - -
. _functions.sh
#
#         Commence Installations
# - - - - - - - - - - - - - - - - - - - - - -

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
echo "8. Install rbenv and the latest stable ruby"
echo ''

section "Setting up xcode"
if type xcode-select >&- && xpath=$( xcode-select --print-path ) &&
	test -d "${xpath}" && test -x "${xpath}" ; then
	log "Xcode already installed. Skipping."
else
	log "Installing Xcode…"
	xcode-select --install
fi


section "Setup dotfile"
[ ! -d $dotfiles_location ] && (
  log "Setting up your dotfiles repo"
  git clone $dotfiles_repo $dotfiles_location
)

section "Install homebrew"
[[ ! $(which brew) ]] &&
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" &&
  brew doctor

brew update

section "Setup taps and install"
if [ -f $homebrew_taps ]; then
  while read line; do
    [[ $(brew tap-info $line | grep "Not installed") ]] &&
      log "brew tap $line" && brew tap $line
  done < "$homebrew_taps"
fi

if [ -f $homebrew_installs ]; then
  while read line; do
    install_brews($line)
  done < "$homebrew_installs"
fi

if [ -f $homebrew_cask_installs ]; then
  while read line; do
    [[ $(brew cask info $line | grep "Not installed") ]] &&
      log "brew cask install $line" && brew cask install $line
  done < "$homebrew_cask_installs"
fi

# Reload Quicklook
qlmanage -r

# Install node
[ ! -d $HOME/.nvm ] && (
  log "Installing NVM"
  curl https://raw.github.com/creationix/nvm/master/install.sh | sh
  source ~/.bash_profile
  nvm install stable
  nvm alias default stable
)

if [ -f $npm_global_installs ]; then
  while read line; do
    install_npm_packages($line)
  done < "$npm_global_installs"
fi

[ ! -d $HOME/.rbenv ] && (
  rbenv install 2.4.1
)

[[ ! $(which bundler) ]] && (
  gem update --system
  gem install bundler --no-document --pre
  number_of_cores=$(sysctl -n hw.ncpu)
  bundle config --global jobs $((number_of_cores - 1))
 )

section "Installing apps from App Store…"
if [ -x mas ]; then
	log "Please install mas-cli first: brew mas. Skipping."
else
	if [ -e $mac_app_store_apps ]; then
		if mas_setup; then
			# Workaround for associative array in Bash 3
			# https://stackoverflow.com/questions/6047648/bash-4-associative-arrays-error-declare-a-invalid-option
			for app in $(<$mac_app_store_apps); do
				KEY="${app%%::*}"
				VALUE="${app##*::}"
				install_application_via_app_store $KEY $VALUE
			done
		else
			print_warning "Please signin to App Store first. Skipping."
		fi
	fi

fi

rcup

section "Cleaning up Homebrew files…"
brew cleanup 2> /dev/null
brew cask cleanup 2> /dev/null

echo '                        ________  _            '
echo '                       |_   __  |(_)           '
echo '                         | |_ \_|__   _ .--.   '
echo '                         |  _|  [  | [ `.-. |  '
echo '                        _| |_    | |  | | | |  '
echo '                       |_____|  [___][___||__] '
echo '                                               '
