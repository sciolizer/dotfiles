# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
#plugins=(autojump battery bundler command-not-found debian encode64 extract gem git github lol nyan rails3 rake ruby rvm vi-mode)
# bundler extract gem github rvm
plugins=(autojump battery command-not-found debian encode64 git lol nyan rails3 rake ruby vi-mode)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
bindkey '\e[3~' delete-char
bindkey '^R' history-incremental-search-backward
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"
alias g='git'
alias gs='git status'
alias gc='git commit'
alias gca='git commit -a'
alias gd='git diff'
alias gl='git lol'
alias gr='git rebase'
alias gri='git rebase -i'
alias ga='git add'
alias gai='git add -i'
alias gb='git branch'
alias b='bundle'
alias be='bundle exec'
alias ber='bundle exec ruby'
alias beri='bundle exec ruby -Itest'
alias c='cd'
alias cg='cd ~/git/act.fm/'
alias l='ls -l'
alias s='sudo'
alias se='sudo /etc/init.d/memcached'
alias ser='sudo /etc/init.d/memcached restart'
source $HOME/bin/engineyard.sh
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias mednafen='aoss mednafen'
alias mkdir='mkdir -p'
alias reset='$HOME/bin/reset'
alias rgrep='rgrep --color'
alias rvm-restart='rvm_reload_flag=1 source '\''$HOME/.rvm/scripts/rvm'\'''
alias zsnes='aoss zsnes'
alias man="TERMINFO=~/.terminfo/ LESS=C TERM=mostlike PAGER=less man"
export LESSOPEN="|/bin/lesspipe %s"

# make ruby unit tests run faster
export RUBY_HEAP_MIN_SLOTS=800000
export RUBY_HEAP_FREE_MIN=100000
export RUBY_HEAP_SLOTS_INCREMENT=300000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
export RUBY_GC_MALLOC_LIMIT=79000000

# disable auto correction
unsetopt correct_all

export PATH=$HOME/bin:$PATH

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
export EDITOR=vim
