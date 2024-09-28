export PATH=$HOME/.local/bin:$HOME/bin:/usr/local/go/bin:/usr/local/bin:/usr/bin:/home/o/.local/share/coursier/bin:/home/o/.local/share/gem/ruby/3.0.0/bin:$PATH

export ZSH="/home/o/.oh-my-zsh"

ZSH_THEME="philips"

export SPACESHIP_DIR_TRUNC_REPO=false

plugins=(git aws aws-mfa docker docker-compose zsh-completions)
autoload -U compinit && compinit //override comp 
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
fpath+=~/.zfunc
autoload -U compinit
fpath=($HOME/.bloop/zsh $fpath)
compinit


source $ZSH/oh-my-zsh.sh



alias dcd="docker-compose down"
alias clip="xclip -selection clipboard"
alias pst="xclip -selection clipboard -o"


alias edp='xrandr --auto && singlescreen'
alias pqc='pqrs row-count'
