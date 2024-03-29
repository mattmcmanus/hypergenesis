# Hypergenesis

Hypergenesis is a simple bash script to get your Mac up and running as quickly as possible.

It does several helpful setup steps for a fresh OSX install:

1. Checkout your dotfiles and set them up with `rcm`
2. Install `homebrew` and your usual taps, apps and casks

It's a simple script with strict assumptions (ie: you use `rcm`, `nvm` & `rvm`). I gladly welcome pull requests.

![HYPERGENESIS](http://25.media.tumblr.com/tumblr_lxm124J68n1qizhaoo1_400.gif)

## HYPERPREP: Preparing to run hypergenesis

**On your existing development machine**

```
brew bundle dump --describe --global
mkrc ~/.Brewfile
```

Now make sure to commit this file to your dotfiles repo

**Make sure to commit and push these changes**

## Run it from a fresh install

```
sudo curl -fsSL https://raw.githubusercontent.com/mattmcmanus/hypergenesis/master/hypergenesis.sh | bash /dev/stdin <your dotfile repo>

# For example

sudo curl -fsSL https://raw.githubusercontent.com/mattmcmanus/hypergenesis/master/hypergenesis.sh | bash /dev/stdin https://github.com/mattmcmanus/dotfiles.git
```
