#!/bin/bash

set -ev

sudo apt-get install vim
sudo apt-get install zsh
curl -L http://install.ohmyz.sh | sh
./bin/copy-from-repo.sh
git config --global user.name "Joshua Ball"
git config --global user.email joshbball@gmail.com
