# Hyperstart *for osx*

Hyperstart is a simple bash script to get your OSX machine up and running as quickly as possible.

![HYPERSTART](http://25.media.tumblr.com/tumblr_lxm124J68n1qizhaoo1_400.gif)

## Run it

1. Install XCode
2. Tweak the script to your needs
3. Run `sh hyperstart.sh`

I recommend forking the script and tweaking it. It's a simple script making lots of assumptions about how you want your environment

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

## Describe to me hyperstart's genesis

I'm a big fan of devops. Using code to predictably and repeatedly configure servers is a wonderful thing. So like many nerds, I was excited to see [boxen](https://www.github.com/boxen) show up for development machine management. After throwing myself against the rocks several multiple times, I finally gave up in frustration. Frankly, I’m tired of frameworks and working against all the opinions of opinionated software. So, I have a simple script that sets up what I need, installs my dotfiles which sets up the rest and then installs vagrant which give me a dev environment.
