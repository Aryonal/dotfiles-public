# Minimal zsh config
# $ tail .zshrc
# [ -f ${ZDOTDIR:-$HOME}/.zsh.zsh ] && source ${ZDOTDIR:-$HOME}/.zsh.zsh

export LOADED_ZSH_ZSH=1

set -o emacs # use C-X C-V to vi mode

XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}

# Moving zsh history to xdg
# zsh config is placed in $ZDOTDIR
# config $ZDOTDIR by editing $HOME/.zshenv
# $ export ZDOTDIR=$HOME/.config/zsh
[[ -f $XDG_STATE_HOME/zsh/history ]] || mkdir -p $XDG_STATE_HOME/zsh
export HISTFILE="$XDG_STATE_HOME"/zsh/history
export HISTSIZE=10000000
export SAVEHIST=10000000

# options
# REF: https://github.com/rothgar/mastering-zsh
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.
setopt APPEND_HISTORY            # append to history file
setopt HIST_NO_STORE             # Don't store history commands

function default-backward-delete-word () {
    local WORDCHARS="*?_[]~!#$%^(){}<>"
    zle backward-delete-word
}
zle -N default-backward-delete-word
bindkey '^W' default-backward-delete-word

# add zsh-complaints to fpath
# REF: https://github.com/zsh-users/zsh-completions
# git clone --depth=1 https://github.com/zsh-users/zsh-completions $XDG_DATA_HOME/zsh/zsh-completions
[ -d $XDG_DATA_HOME/zsh/zsh-completions/src ] && fpath=($XDG_DATA_HOME/zsh/zsh-completions/src $fpath)

# add zshz
# REF: https://github.com/agkozak/zsh-z?tab=readme-ov-file#installation
# git clone --depth=1 https://github.com/agkozak/zsh-z $XDG_DATA_HOME/zsh/zsh-z
[ -f $XDG_DATA_HOME/zsh/zsh-z/zsh-z.plugin.zsh ] && source $XDG_DATA_HOME/zsh/zsh-z/zsh-z.plugin.zsh
[ -d $XDG_STATE_HOME/zsh ] || mkdir -p $XDG_STATE_HOME/zsh
export ZSHZ_DATA=$XDG_STATE_HOME/zsh/.z

# add p10k
# REF: https://github.com/romkatv/powerlevel10k
# git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $XDG_DATA_HOME/zsh/powerlevel10k
[ -f $XDG_DATA_HOME/zsh/powerlevel10k/powerlevel10k.zsh-theme ] && source $XDG_DATA_HOME/zsh/powerlevel10k/powerlevel10k.zsh-theme

# add auto-suggestions
# REF: https://github.com/zsh-users/zsh-autosuggestions
# git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions $XDG_DATA_HOME/zsh/zsh-autosuggestions
[ -f $XDG_DATA_HOME/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source $XDG_DATA_HOME/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
# bindkey '^F' autosuggest-accept
# bindkey '^E' autosuggest-accept


autoload -Uz compinit
[[ -f $XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION ]] || mkdir -p $XDG_CACHE_HOME/zsh && touch $XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION
compinit -d $XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION
zstyle ":completion:*" cache-path $XDG_CACHE_HOME/zsh/zcompcache
zstyle ":completion:*" menu select

# keep syntax-highlighting after zle -N and compinit
# add syntax-highlighting
# REF: https://github.com/zsh-users/zsh-syntax-highlighting
# git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting $XDG_DATA_HOME/zsh/zsh-syntax-highlighting
[ -f $XDG_DATA_HOME/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source $XDG_DATA_HOME/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


function install-zsh-plugins() {
    if [[ ! -d $XDG_DATA_HOME/zsh/zsh-completions ]]; then
        echo "Installing zsh-completions..."
        git clone --depth=1 https://github.com/zsh-users/zsh-completions $XDG_DATA_HOME/zsh/zsh-completions
    else
        echo "zsh-completions already installed"
    fi

    if [[ ! -d $XDG_DATA_HOME/zsh/zsh-z ]]; then
        echo "\n\nInstalling zsh-z..."
        git clone --depth=1 https://github.com/agkozak/zsh-z $XDG_DATA_HOME/zsh/zsh-z
    else
        echo "zsh-z already installed"
    fi

    if [[ ! -d $XDG_DATA_HOME/zsh/powerlevel10k ]]; then
        echo "\n\nInstalling powerlevel10k..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $XDG_DATA_HOME/zsh/powerlevel10k
    else
        echo "powerlevel10k already installed"
    fi

    if [[ ! -d $XDG_DATA_HOME/zsh/zsh-autosuggestions ]]; then
        echo "\n\nInstalling zsh-autosuggestions..."
        git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions $XDG_DATA_HOME/zsh/zsh-autosuggestions
    else
        echo "zsh-autosuggestions already installed"
    fi

    if [[ ! -d $XDG_DATA_HOME/zsh/zsh-syntax-highlighting ]]; then
        echo "\n\nInstalling zsh-syntax-highlighting..."
        git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting $XDG_DATA_HOME/zsh/zsh-syntax-highlighting
    else
        echo "zsh-syntax-highlighting already installed"
    fi

    echo "\nDone"
}


function upgrade-zsh-plugins() {
    if [[ -d $XDG_DATA_HOME/zsh/zsh-completions ]]; then
        echo "Upgrading zsh-completions..."
        (cd $XDG_DATA_HOME/zsh/zsh-completions && git pull)
    fi

    if [[ -d $XDG_DATA_HOME/zsh/powerlevel10k ]]; then
        echo "\n\nUpgrading powerlevel10k..."
        (cd $XDG_DATA_HOME/zsh/powerlevel10k && git pull)
    fi

    if [[ -d $XDG_DATA_HOME/zsh/zsh-autosuggestions ]]; then
        echo "\n\nUpgrading zsh-autosuggestions..."
        (cd $XDG_DATA_HOME/zsh/zsh-autosuggestions && git pull)
    fi

    if [[ -d $XDG_DATA_HOME/zsh/zsh-syntax-highlighting ]]; then
        echo "\n\nUpgrading zsh-syntax-highlighting..."
        (cd $XDG_DATA_HOME/zsh/zsh-syntax-highlighting && git pull)
    fi

    if [[ -d $XDG_DATA_HOME/zsh/zsh-z ]]; then
        echo "\n\nUpgrading zsh-z..."
        (cd $XDG_DATA_HOME/zsh/zsh-z && git pull)
    fi

    echo "\nDone"
}

# starship prompt
# if command -v starship &> /dev/null; then
#     eval "$(starship init zsh)"
#
#     export STARSHIP_CACHE=$XDG_CACHE_HOME/starship/cache
# fi

# use p10k instead
# git prompt
# function git_branch() {
#     local ref
#     ref=$(git symbolic-ref HEAD 2> /dev/null) || return
#     echo "${ref#refs/heads/}"
# }
#
# function git_dirty() {
#     [[ -n $(git status --porcelain 2> /dev/null) ]] && echo " !"
# }
#
# # prompt
# setopt PROMPT_SUBST
# NL=$'\n'
# PROMPT='%(?.%F{green}.%F{red}%?)%f%F{blue}%~%f %F{yellow}$(git_branch)%f%F{red}$(git_dirty)%f${NL}%(!.#.>)%f '
#
# zstyle ":vcs_info:*" enable git
# zstyle ":vcs_info:git:*" formats "%F{yellow}%b%f"
