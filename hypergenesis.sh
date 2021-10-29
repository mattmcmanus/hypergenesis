#!/bin/bash

set -e

#
#             Configuration
# - - - - - - - - - - - - - - - - - - - - - -

dotfiles_repo='git@github.com:mattmcmanus/dotfiles.git'
dotfiles_location="$HOME/.dotfiles"


#
#     Functions make things easier!
# - - - - - - - - - - - - - - - - - - - - - -
. _functions.sh
#
#         Commence Installations
# - - - - - - - - - - - - - - - - - - - - - -

echo ''
echo '       * * * * * * * * * * * * * * INITIATING * * * * * * * * * * * * * * '
echo ''
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

section "Setting up xcode"
if type xcode-select >&- && xpath=$( xcode-select --print-path ) &&
	test -d "${xpath}" && test -x "${xpath}" ; then
	log "Xcode already installed. Skipping."
else
	log "Installing Xcode…"
	xcode-select --install
fi

section "Setup dotfiles"
[ ! -d $dotfiles_location ] && (
  log "Setting up your dotfiles repo"
  git clone $dotfiles_repo $dotfiles_location
)

section "Install homebrew"
[[ ! $(which brew) ]] &&
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" &&
  brew doctor

brew update -q

section "Brew Bundle"
brew bundle --file="~/.dotfiles/Brewfile"

rcup

section "Cleaning up Homebrew files…"
brew cleanup 2> /dev/null

echo '                        ________  _            '
echo '                       |_   __  |(_)           '
echo '                         | |_ \_|__   _ .--.   '
echo '                         |  _|  [  | [ `.-. |  '
echo '                        _| |_    | |  | | | |  '
echo '                       |_____|  [___][___||__] '
echo '                                               '
