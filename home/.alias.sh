#! /bin/sh
# Alias shared between bash and zsh
# $ tail .bashrc # or .zshrc
# [ -f path/to/.alias.sh ] && source path/to/.alias.sh
# e.g.
# [ -f ${ZDOTDIR:-$HOME}/.alias.sh ] && source ${ZDOTDIR:-$HOME}/.alias.sh

# user local binaries
export PATH=$PATH:$HOME/.local/bin:$HOME/.bin

# Alias ls
if command -v lsd &>/dev/null; then
    alias ls="lsd --group-directories-first"
elif [[ -f /opt/homebrew/opt/coreutils/bin/gls ]]; then
    # requires coreutils
    # $ brew install coreutils
    # For M* mac
    alias ls="/opt/homebrew/opt/coreutils/bin/gls --group-directories-first --color"
elif [[ -f /usr/local/opt/coreutils/bin/gls ]]; then
    # requires coreutils
    # $ brew install coreutils
    # For Intel mac
    alias ls="/usr/local/opt/coreutils/bin/gls --group-directories-first --color"
elif ls --group-directories-first . >/dev/null 2>&1; then
    # GNU_LS
    alias ls="ls --group-directories-first --color"
elif ls -G -d . >/dev/null 2>&1; then
    # BSD_LS
    alias ls="ls -G"
# else
#     # SOLARIS_LS
fi

alias l="LC_COLLATE=C ls -lhF"
alias ll="LC_COLLATE=C ls -AlhF"
alias la="LC_COLLATE=C ls -AlhF"
alias lla="LC_COLLATE=C ls -alhF"


# REF: https://github.com/rothgar/mastering-zsh/blob/master/docs/helpers/aliases.md
alias e0="exit 0"
alias cl="clear"
alias :q="exit 0"
alias :qa="exit 0"
alias :wq="exit 0"
alias :w="echo saved!"
alias :wa="echo saved!"
alias :wq="echo saved!"
alias ..='cd ..'
alias ....='cd ../..'

# Search through your command history and print the top 10 commands
alias history-stat='history 0 | awk ''{print $2}'' | sort | uniq -c | sort -n -r | head'
# Use `which` to find aliases and functions including binaries
which='(alias; declare -f) | /usr/bin/which --tty-only --read-alias --read-functions --show-tilde --show-dot'

# Datetime format
if [[ $OSTYPE == 'darwin'* ]]; then
    function ddcp() {
        date +%y%m%d%H%M%S | pbcopy
    }
fi

# Chrome
if [[ $OSTYPE == 'darwin'* ]]; then
    alias chrome="open -na \"Google Chrome\" --args --new-window"
fi

# golang
if command -v go &> /dev/null; then
    export PATH=$PATH:$(go env GOPATH)/bin
fi

function goenv() {
    # default path for go sdk
    GOSDK="$HOME/sdk"
    GOPATH="$HOME/go"
    GO="$HOME/.local/bin/go"

    if [ $1 ]; then
        if ! [[ $1 =~ '^([0-9]+\.){0,2}(\*|[0-9]+)$' ]]; then
            echo "Illegal version:" "\"$1\""
            return 1
        fi
        [[ -L $GO ]] && rm $GO
        ln -s $GOPATH/bin/go$1 $GO
    else
        sdk_list=$(ls $GOSDK)
        echo "$sdk_list[*]"
        echo
        echo "usage: goenv [version]"
        echo "    version: semantic go version, e.g. 1.20"
    fi
}

# use poetry instead
# byebye pyenv

# kubectl
if command -v kubectl &>/dev/null; then
    alias k=kubectl
    bold=$(tput bold)
    normal=$(tput sgr0)
    red='\033[0;31m'
    green="\033[0;32m"  # green
    yellow="\033[0;33m" # yellow
    blue="\033[0;34m"   # blue
    noc='\033[0m'
    if command -v kubectx &>/dev/null; then
        alias kx=kubectx
        alias kn=kubens
        function kc() {
            echo
            echo "${bold}current context:${normal}"
            echo "    ${red}$(kubectx -c)${noc} | ${red}$(kubens -c)${noc}"
            echo
        }
    else
        # short alias to set/show context/namespace (only works for bash and bash-compatible shells, current context to be set before using kn to set namespace)
        function kx() { [ "$1" ] && kubectl config use-context $1 || kubectl config get-contexts; }
        function kxc() { kubectl config current-context }
        function kn() { [ "$1" ] && kubectl config set-context --current --namespace $1 || kubectl get ns; }
        function knc() { kubectl config view --minify | grep namespace | cut -d" " -f6 }
        function kc() {
            echo
            echo "${bold}current context:${normal}"
            echo "    ${red}$(kxc)${noc} | ${red}$(knc)${noc}"
            echo
        }
    fi
fi

# tmux
if command -v tmux &> /dev/null
then
    alias tmr="tmux rename" # <C-b>$
    alias tl="tmux ls"
    alias ts="tmux new -s"

    function t () {
        # helper with -h or --help
        if [[ $1 == "-h" || $1 == "--help" ]]; then
            echo "Usage: tm [session_name]"
            echo ""
            echo "<session_name>\tName of the new session. If not provided, an existing session will be attached."
            echo "\t\tIf a directory can be found with the name using z, new session will be in that directory."
            echo ""
            echo "This command can be used in a tmux session as well."
            return 0
        fi


        # if $TMUX is set, make new session command detached: tmux new-session -d
        if [[ -n $TMUX ]]; then
            local __ts="tmux new-session -d -s"
            local __sw="tmux switch-client -t"

            if ! [[ -n $@ ]]; then
                echo "already in TMUX"
                return 0
            elif tmux list-sessions -F \#S | grep $1 &> /dev/null; then
                tmux switch-client -t $1
                return $?
            else
                if command -v z &> /dev/null; then
                    (z $1 && eval $__ts $1) &>/dev/null && eval $__sw $1  || eval $__ts $1 && eval $__sw $1
                    return $?
                fi
                eval $__ts $1 && eval $__sw $1
                return $?
            fi
            return 0
        fi

        if ! [[ -n $@ ]]; then
            if tmux list-sessions &> /dev/null; then
                tmux attach
                return $?
            fi
            tmux new-session
            return $?
        elif tmux list-sessions -F \#S | grep $1 &> /dev/null; then
            tmux attach -d -t $1
            return $?
        else
            if command -v z &> /dev/null; then
                (z $1 && tmux new-session -s $1) &>/dev/null || tmux new-session -s $1
                return $?
            fi
            eval $__ts -s $1
            return $?
        fi
    }
fi


# git
command -v git &>/dev/null && alias g="git"

# nvim & vim
# set nvim as default editor
if command -v nvim &>/dev/null; then
    export KUBE_EDITOR="nvim"
    export EDITOR="nvim"
    alias vi=nvim
    alias v=nvim

    # flaky?
    alias vs="nvim +LoadSession"
    alias vd="nvim +'DiffviewOpen --imply-local'"
    alias vdo="nvim +'DiffviewOpen origin/HEAD --imply-local'"
fi

# n
if command -v n &> /dev/null; then
    export N_PREFIX="${XDG_DATA_HOME:-$HOME/.local/share}/n"
    export PATH=$N_PREFIX/bin:$PATH
fi

# fzf
# Open in tmux popup if on tmux, otherwise use --height mode
export FZF_CTRL_T_COMMAND='fd
    --hidden
    --follow
    --exclude=.git
    --exclude=.cache
    --exclude=node_modules
    --exclude=vendor
    --exclude=__pycache__
    --exclude=*.egg-info
    --exclude=*.egg
    --exclude=*.pyc
    --exclude=*.pyo
    --exclude=*.swp
    --exclude=*.swo'
export FZF_CTRL_T_OPTS="
    --height 50%
    --layout reverse
    --border top
    --preview
        'if [[ -f {} ]]; then
            if [[ \$(file --mime {}) =~ binary ]]; then
                echo {} is a binary file
            else
                bat --style=numbers --color=always --line-range :500 {} 2>/dev/null || cat {}
            fi
        elif [[ -d {} ]]; then
            ls -la --color=always {}
        fi'
    --preview-window=right:50%
    --bind 'ctrl-a:select-all+accept'
    --bind 'ctrl-o:execute($EDITOR {})'
    --bind 'ctrl-/:toggle-preview'
    --bind 'ctrl-y:preview-half-page-up'
    --bind 'ctrl-e:preview-half-page-down'
    --ansi"
export FZF_CTRL_R_OPTS="$FZF_CTRL_T_OPTS --preview-window=hidden"
export FZF_CTRL_G_OPTS="$FZF_CTRL_T_OPTS
    --preview '
        git diff HEAD --color=always {-1} 2>/dev/null ||
            git diff HEAD --color=always --cached {-1} 2>/dev/null ||
            bat --style=numbers --color=always --line-range :500 {-1} 2>/dev/null ||
            cat {-1} 2>/dev/null ||
            echo Unable to preview file: {-1}'
    --bind 'ctrl-o:execute($EDITOR {-1})'
    --bind 'enter:execute($EDITOR {-1})'
"

# cargo
[[ -f $HOME/.cargo/env ]] && . "$HOME/.cargo/env"

alias rm="echo 'use trash instead'"
