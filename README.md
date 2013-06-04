# Hypergenesis

Hypergenesis is a simple bash script to get your Mac up and running as quickly as possible. 

It's designed around the assumption that (1.) most of you configuration settings are handled by some sort of dotfiles repository and (2.) any complicated development setup is done with vagrant in a VM. Don't like those assumptions? Fork it! 

![HYPERGENESIS](http://25.media.tumblr.com/tumblr_lxm124J68n1qizhaoo1_400.gif)

## Run it from a fresh install

1. Install XCode & the command line tools. [Need more info?](http://stackoverflow.com/a/9329325/109589)
2. Tweak the script to your needs. *(Most of the configuration is in variables at the top)*
3. Run `sh hypergenesis.sh`

I recommend forking the script and tweaking it. It's simple and only covers so much. If you've got any awesome ideas, send a pull request!

## What does it do?

Don't worry, it will tell you exactly before you run it: 

```
$ sh hypergenesis.sh

       * * * * * * * * * * * * * * INITIATING * * * * * * * * * * * * * *

            __  __
           / / / /_  ______  ___  _______
          / /_/ / / / / __ \/ _ \/ _____/                     _
         / __  / /_/ / /_/ /  __/ / ____/__  ____  ___  _____(_)____
        /_/ /_/\__, / .___/\___/_/ / __/ _ \/ __ \/ _ \/ ___/ / ___/
              /____/_/          / /_/ /  __/ / / /  __(__  ) (__  )
                                \____/\___/_/ /_/\___/____/_/____/

       * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Please ensure that you have installed XCode and its command line tools. See README.md for more details

This script will do the following:

1. Install homebrew
2. brew install git grc coreutils ack findutils gnu-tar tmux htop-osx ctags nginx gnu-sed
3. Setup your dotfiles (git@github.com:mattmcmanus/dotfiles.git) into /Users/matt/.dotfiles
4. Install NVM and node.js 0.10
5. Install RVM and ruby 1.9.3
6. Install chrome virtualbox vagrant password dropbox sublime evernote firefox iterm sequel rdio
7. Setup vagrant development repos (git@github.com:punkave/punkave-vagrant-lamp.git) into /Users/matt/dev

Are you ok with this?
```

## Describe to me hypergenesis's genesis

I'm a big fan of devops. Using code to predictably and repeatedly configure servers is a wonderful thing. So like many nerds, I was excited to see [boxen](https://www.github.com/boxen) show up for development machine management. After throwing myself against the rocks multiple times, I finally gave up in frustration. Frankly, I’m tired of frameworks. I'm also tired of working against all the opinions of extremely opinionated software. So I set out to make a simple script with as few assumptions and layers as possible.
