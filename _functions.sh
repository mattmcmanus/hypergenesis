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

install_application_via_app_store() {
	if ! mas list | grep $1 &> /dev/null; then
		log "Installing $2"
		mas install $1 >/dev/null
	else
		log "$2 already installed. Skipped."
	fi
}

install_npm_packages() {
  [[ -z $(npm ls -gp $1) ]] && (
    log "npm install -g $1" && npm install -g --silent $1
  ) || log "$1 already installed"
}

install_brews() {
  if test ! $(brew list | grep $brew); then
        log "Installing $brew"
		brew install $brew >/dev/null
	else
  	log "$brew already installed. Skipped."
  fi
}
