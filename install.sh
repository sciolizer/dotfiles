#!/bin/bash

set -ev

sudo apt-get install zsh
curl -L http://install.ohmyz.sh | sh
./bin/copy-from-repo.sh
