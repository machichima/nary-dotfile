#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[ -f ~/.bash_aliases ] && . ~/.bash_aliases

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

export BROWSER='/usr/bin/brave' 
export VISUAL=nvim
export EDITOR=nvim

export XDG_CONFIG_HOME=$HOME/.config

export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv init --path)"

eval $(thefuck --alias fuck)

# Created by `pipx` on 2024-06-29 16:36:26
export PATH="$PATH:/home/nary/.local/bin"

# input method
# cn
export LANG="zh-CN.UTF-8" 
export LC_ALL="en_US.UTF-8"
#  fcitx
export GTK_IM_MODULE="fcitx"
export QT_IM_MODULE="fcitx"
export XMODIFIERS="@im=fcitx"
export INPUT_METHOD="fcitx"
export XIM="fcitx"
export XIM_PROGRAM="fcitx"
export SDL_IM_MODULE="fcitx"
export GLFW_IM_MODULE="ibus"

eval "$(zoxide init bash)"
