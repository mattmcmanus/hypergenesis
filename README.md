# Hypergenesis

Hypergenesis is a simple bash script to get your Mac up and running as quickly as possible.

It does several helpful setup steps for a fresh OSX install:

1. Checkout your dotfiles and set them up with `rcm`
2. Install `homebrew` and your usual taps, apps and casks
3. Install `nvm`, the latest node and your usual global `npm` packages
4. Install `rvm`, the latest Ruby, bundler and foreman

It's a simple script with strict assumptions (ie: you use `rcm`, `nvm` & `rvm`). I gladly welcome pull requests.

![HYPERGENESIS](http://25.media.tumblr.com/tumblr_lxm124J68n1qizhaoo1_400.gif)

## HYPERPREP: Preparing to run hypergenesis

**On your existing development machine**

`./hyperprep.sh` will create configuration files in your dotfiles directory listing your currently installed:

* `homebrew tap`s
* `homebrew` installs
* `homebrew cask` installs,
* globally installed `npm` modules
* for your convenience, the list of every app in your `/Applications/` folder.

It assumes your dotfiles are at `~/.dotfiles`. It will create several files in `~/.dotfiles/hypergenesis`

**Make sure to commit and push these changes**

## Run it from a fresh install

1. Install XCode & the command line tools. [Need more info?](http://stackoverflow.com/a/9329325/109589)
2. `git clone git@github.com:mattmcmanus/hypergenesis.git` wherever you want
3. Run `./hypergenesis.sh` from within the checked out `hypergenesis` directory

## Things of note

The script is idempotent. It will skip already installed packages.

## Describe to me hypergenesis's...genesis

I'm a big fan of devops. Using code to predictably and repeatedly configure servers is a wonderful thing. So like many nerds, I was excited to see [boxen](https://www.github.com/boxen) show up for development machine management. After throwing myself against the rocks multiple times, I finally gave up in frustration. Frankly, I’m tired of frameworks. I'm also tired of working against all the opinions of extremely opinionated software. So I set out to make a simple script with as few assumptions and layers as possible.
