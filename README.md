# Hypergenesis

Hypergenesis is a simple bash script to get your Mac up and running as quickly as possible. 

It's designed around the assumption that (1.) most of you configuration settings are handled by some sort of dotfiles repository and (2.) any complicated development setup is done with vagrant in a VM. Don't like those assumptions? Fork it! 

![HYPERGENESIS](http://25.media.tumblr.com/tumblr_lxm124J68n1qizhaoo1_400.gif)

## Run it from a fresh install

1. Install XCode & the command line tools
2. Tweak the script to your needs. *(Most of the configuration is in variables at the top)*
3. Run `sh hypergenesis.sh`

I recommend forking the script and tweaking it. It's simple and only covers so much. If you've got any awesome ideas, send a pull request!

## What does it do?

1. Installs `homebrew`
2. Using homebrew, installs a bunch of useful tools like `git grc coreutils ack findutils gnu-tar`
3. Sets up your .dotfiles
  * You'll definitely want to tweak this. My repo is based off of [holmans dotfiles](https://github.com/holman/dotfiles) 
4. Installs [NVM](https://github.com/creationix/nvm), then installs node 0.10
5. Installs several useful DMG'ed apps
  * chrome
  * virtualbox
  * vagrant
  * dropbox
  * onepassword
  * sublimetext2
  * evernote
  * and more!

## Describe to me hypergenesis's genesis

I'm a big fan of devops. Using code to predictably and repeatedly configure servers is a wonderful thing. So like many nerds, I was excited to see [boxen](https://www.github.com/boxen) show up for development machine management. After throwing myself against the rocks several multiple times, I finally gave up in frustration. Frankly, I’m tired of frameworks. I'm also tired of working against all the opinions of extremely opinionated software. So I set out to make a simple script with as few assumptions and layers as possible.
