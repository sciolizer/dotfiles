#!/bin/bash

set -ev

sudo apt-get update
sudo apt-get install vim zsh curl
curl -L http://install.ohmyz.sh | sh
sudo chsh -s /usr/bin/zsh vagrant
./bin/copy-from-repo.sh
git config --global user.name "Joshua Ball"
git config --global user.email joshbball@gmail.com
