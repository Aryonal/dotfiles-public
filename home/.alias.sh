# Alias shared between bash and zsh
# $ tail .bashrc # or .zshrc
# [ -f path/to/.alias.sh ] && source path/to/.alias.sh

# XDG configuration
# REF: https://wiki.archlinux.org/title/XDG_Base_Directory
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

export XDG_DATA_DIRS="/usr/local/share:/usr/share"
export XDG_CONFIG_DIRS="/etc/xdg"

# Alias

if command -v lsd &>/dev/null; then
	alias ls="lsd --group-directories-first"
	# use --group-directories-first for GNU ls
elif ls --group-directories-first . >/dev/null 2>&1; then
	# GNU_LS
	alias ls="ls --group-directories-first --color"
	# elif ls -G -d . >/dev/null 2>&1; then
	#     # BSD_LS
	# else
	#     # SOLARIS_LS
fi

alias l="LC_COLLATE=C ls -lhF"
alias ll="LC_COLLATE=C ls -AlhF"
alias la="LC_COLLATE=C ls -AlhF"
alias lla="LC_COLLATE=C ls -alhF"

# Shortcut
alias e0="exit 0"
alias cl="clear"

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
		function kx() { [ "$1" ] && kubectl config use-context $1 || kubectl config current-context; }
		function kn() { [ "$1" ] && kubectl config set-context --current --namespace $1 || kubectl config view --minify | grep namespace | cut -d" " -f6; }
		function kc() {
			echo
			echo "${bold}current context:${normal}"
			echo "    ${red}$(kx)${noc} | ${red}$(kn)${noc}"
			echo
		}
	fi
fi

# tmux
if command -v tmux &> /dev/null
then
    alias tmd="tmux detach" # tmux detach
    # alias tmk="tmux kill-session -t" # tmux kill session by name # use tkss
    # alias tmka="tmux ls -F \#S | xargs -IX tmux kill-session -t X" # tmux kill all session # use tksv
    alias tmr="tmux rename" # tmux rename session

    if command -v z &> /dev/null
    then
        function tm () {
            if ! [[ -n $@ ]]; then
                tmux
                return $?
            elif tmux list-sessions | grep $1 &> /dev/null; then
                tmux attach -d -t $1
                return $?
            else
                (z $1 && tmux new-session -s $1)
                return $?
            fi
        }
    fi
fi


# git
command -v git &>/dev/null && alias g="git"

# nvim & vim
# set nvim as default editor
export KUBE_EDITOR="nvim"
export EDITOR="nvim"

alias vi=nvim
# alias vim=nvim
