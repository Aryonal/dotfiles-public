# Minimal zsh config

XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}

# add zsh-complaints to fpath
# REF: https://github.com/zsh-users/zsh-completions
[ -d $XDG_DATA_HOME/zsh-completions/src ] && fpath=($XDG_DATA_HOME/zsh-completions/src $fpath)

# add zshz
# REF: https://github.com/agkozak/zsh-z?tab=readme-ov-file#installation
[ -f $XDG_DATA_HOME/zsh-z/zsh-z.plugin.zsh ] && source $XDG_DATA_HOME/zsh-z/zsh-z.plugin.zsh

autoload -Uz compinit
[[ -f $XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION ]] || mkdir -p $XDG_CACHE_HOME/zsh && touch $XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION
compinit -d $XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION
zstyle ":completion:*" cache-path $XDG_CACHE_HOME/zsh/zcompcache
zstyle ":completion:*" menu select

# git prompt
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )

# prompt
setopt PROMPT_SUBST
NL=$'\n'
PROMPT='%F{blue}%~%f ${vcs_info_msg_0_}${NL}%(?.%F{green}.%?%F{red})%(!.#.>)%f '

zstyle ":vcs_info:*" enable git
zstyle ":vcs_info:git:*" formats "%F{yellow}(%s:%b)%f"
