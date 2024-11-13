#!/bin/bash

# Exit on error, undefined variables, and pipe failures
set -euo pipefail
IFS=$'\n\t'

section() {
  echo ""
  echo "##################################################"
  echo "                   $1"
  echo "##################################################"
  echo ""
}

log() {
  echo ""
  echo " ==> $1"
  echo ""
}

DOTFILES_REPO=${1:-""}
if [[ -z "$DOTFILES_REPO" ]]; then
    echo "Error: Must provide a dotfiles repo as an argument" 1>&2
    echo "Usage: $0 <git-repo-url>" 1>&2
    exit 1
fi


#
#             Configuration
# - - - - - - - - - - - - - - - - - - - - - -

# dotfiles_repo='git@github.com:mattmcmanus/dotfiles.git'
dotfiles_location="$HOME/.dotfiles"


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
if [ -x "$(command -v xcode-select)" ] && [ -d "$(xcode-select -p)" ]; then
    log "Xcode already installed. Skipping."
else
    log "Installing Xcode Command Line Tools..."
    xcode-select --install || {
        echo "Error: Failed to install Xcode Command Line Tools" >&2
        exit 1
    }
fi

section "Setup dotfiles"
if [ ! -d "$dotfiles_location" ]; then
    log "Setting up your dotfiles repo"
    git clone "$DOTFILES_REPO" "$dotfiles_location" || {
        echo "Error: Failed to clone dotfiles repository" >&2
        exit 1
    }
else
    log "Dotfiles already installed. Updating..."
    (cd "$dotfiles_location" && git pull)
fi

section "Install homebrew"
if ! command_exists brew; then
    log "Installing Homebrew..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || {
        echo "Error: Failed to install Homebrew" >&2
        exit 1
    }
    
    # Handle both Intel and Apple Silicon Macs
    if [[ -f /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
    
    echo "eval \"\$(brew shellenv)\"" >> ~/.zprofile
else
    log "Homebrew already installed"
fi

log "Updating Homebrew..."
brew update -q || true  # Don't fail if update fails

section "Brew Bundle"
if [ -f "$dotfiles_location/Brewfile" ]; then
    log "Installing Homebrew packages..."
    brew bundle --file="$dotfiles_location/Brewfile" || {
        echo "Warning: Some Homebrew installations failed" >&2
    }
else
    echo "Warning: Brewfile not found at $dotfiles_location/Brewfile" >&2
fi

# Check if rcup exists before running it
if command_exists rcup; then
    log "Running rcup..."
    rcup
else
    echo "Warning: rcup not found. Please install rcm first." >&2
fi

section "Cleaning up Homebrew files…"
brew cleanup 2> /dev/null

echo '                        ________  _            '
echo '                       |_   __  |(_)           '
echo '                         | |_ \_|__   _ .--.   '
echo '                         |  _|  [  | [ `.-. |  '
echo '                        _| |_    | |  | | | |  '
echo '                       |_____|  [___][___||__] '
echo '                                               '
