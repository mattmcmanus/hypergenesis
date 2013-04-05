# Hyperstart *for osx*

Hyperstart is a simple bash script to get your OSX machine up and running as quickly as possible.

![HYPERSTART](http://25.media.tumblr.com/tumblr_lxm124J68n1qizhaoo1_400.gif)

## How to run

1. Install XCode
2. Run `sh hyperstart.sh`

I recommend downloading the script and tweaking it. It's a simple script making lots of assumptions about how you want your environment

## What does it do?

1. Installs `homebrew`
2. Using homebrew, installs a bunch of useful tools like `git grc coreutils ack findutils gnu-tar`
3. Sets up your .dotfiles
  * You'll definitely want to tweak this. My repo is based off of [holmans dotfiles](https://github.com/holman/dotfiles) 
4. Installs [NVM](https://github.com/creationix/nvm), then install node 0.10
5. Installs several useful DMG'ed apps
  * chrome
  * virtualbox
  * vagrant
  * dropbox
  * onepassword
  * sublimetext2
  * evernote
