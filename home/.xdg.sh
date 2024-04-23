# XDG configuration
# $ tail .bashrc # or .zshrc
# [ -f /path/to/.xdg.sh ] && source /path/to/.xdg.sh
# e.g.
# [ -f ${ZDOTDIR:-$HOME}/.xdg.sh ] && source ${ZDOTDIR:-$HOME}/.xdg.sh

# REF: https://wiki.archlinux.org/title/XDG_Base_Directory
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

export XDG_DATA_DIRS="/usr/local/share:/usr/share"
export XDG_CONFIG_DIRS="/etc/xdg"

# Moving zsh history to xdg
# zsh config is placed in $ZDOTDIR
# config $ZDOTDIR by editing $HOME/.zshenv
# $ export ZDOTDIR=$HOME/.config/zsh
[[ -f $XDG_STATE_HOME/zsh/history ]] || mkdir -p $XDG_STATE_HOME/zsh
export HISTFILE="$XDG_STATE_HOME"/zsh/history
