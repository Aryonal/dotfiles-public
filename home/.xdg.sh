# XDG configuration
# $ tail ~/.zsh
# [ -f ${ZDOTDIR:-$HOME}/.xdg.sh ] && source ${ZDOTDIR:-$HOME}/.xdg.sh
# REF: https://wiki.archlinux.org/title/XDG_Base_Directory
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

export XDG_DATA_DIRS="/usr/local/share:/usr/share"
export XDG_CONFIG_DIRS="/etc/xdg"

# Moving zsh xdg
[[ -f $XDG_STATE_HOME/zsh/history ]] || mkdir -p $XDG_STATE_HOME/zsh
export HISTFILE="$XDG_STATE_HOME"/zsh/history
