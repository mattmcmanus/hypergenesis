# Hypergenesis

Hypergenesis is a simple bash script to get your Mac up and running as quickly as possible.

It does several helpful setup steps for a fresh OSX install:

1. Checkout your dotfiles and set them up with `rcm`
2. Install `homebrew` and your usual taps, apps and casks

It's a simple script with strict assumptions (ie: you use `rcm`, `nvm` & `rvm`). I gladly welcome pull requests.

![HYPERGENESIS](http://25.media.tumblr.com/tumblr_lxm124J68n1qizhaoo1_400.gif)

## HYPERPREP: Preparing to run hypergenesis

**On your existing development machine**

**THIS DOCUMENTATION IS OUT OF DATE**

`./hyperprep.sh` will create configuration files in your dotfiles directory listing your currently installed:

* `homebrew tap`s
* `homebrew` installs
* `homebrew cask` installs,
* globally installed `npm` modules
* for your convenience, the list of every app in your `/Applications/` folder.

It assumes your dotfiles are at `~/.dotfiles`. It will create several files in `~/.dotfiles/hypergenesis`

**Make sure to commit and push these changes**

## Run it from a fresh install

1. `git clone git@github.com:mattmcmanus/hypergenesis.git` wherever you want
2. Run `./hypergenesis.sh` from within the checked out `hypergenesis` directory
