# Minimal zsh config
# $ tail .zshrc
# [ -f ${ZDOTDIR:-$HOME}/.fzf.zsh ] && source ${ZDOTDIR:-$HOME}/.fzf.zsh

export LOADED_ZSH_FZF=1

export KEYTIMEOUT=200  # 1 second (in centiseconds)

# Check if fzf is available
if ! command -v fzf &> /dev/null; then
    return
fi

# fzf
# Open in tmux popup if on tmux, otherwise use --height mode
export FZF_CTRL_T_COMMAND='fd \
    --hidden \
    --exclude=.git \
    --exclude=.cache \
    --exclude=node_modules \
    --exclude=vendor \
    --exclude=__pycache__ \
    --exclude=\*.egg-info \
    --exclude=\*.egg \
    --exclude=\*.pyc \
    --exclude=\*.pyo \
    --exclude=\*.swp \
    --exclude=\*.swo'
export FZF_CTRL_T_OPTS="
    --height 50%
    --layout reverse
    --border top
    --preview '${ZDOTDIR:-$HOME/.config/zsh}/preview.sh {}'
    --preview-window=right:50%
    --bind 'ctrl-o:execute($EDITOR {})+abort'
    --bind 'ctrl-/:toggle-preview'
    --bind 'ctrl-b:preview-half-page-up'
    --bind 'ctrl-f:preview-half-page-down'
    --bind 'ctrl-t:abort'
    --bind 'ctrl-r:abort'
    --bind 'tab:toggle+down'
    --ansi"
export FZF_CTRL_R_OPTS="$FZF_CTRL_T_OPTS
    --preview-window=hidden"
export FZF_CTRL_G_G_OPTS="$FZF_CTRL_T_OPTS
    --preview 'git diff HEAD --color=always {-1} || git diff HEAD --color=always --cached {-1} || echo Failed to preview'
    --bind 'ctrl-o:execute($EDITOR {-1})'
    --bind 'enter:accept'
    --multi"
export FZF_CTRL_G_R_COMMAND='rg \
    --color=always \
    --line-number \
    --no-heading \
    --smart-case \
    --hidden \
    --glob "!.git/" \
    --glob "!node_modules/" \
    --glob "!vendor/" \
    --glob "!submodules/"'
export FZF_CTRL_G_R_OPTS="$FZF_CTRL_T_OPTS
    --disabled
    --delimiter :
    --preview '${ZDOTDIR:-$HOME/.config/zsh}/preview.sh {1} {2}'
    --bind 'ctrl-o:execute(\$EDITOR {1}:{2})+abort'
    --bind 'enter:accept'
    --bind 'change:reload:$FZF_CTRL_G_R_COMMAND {q} || true'
    --multi"

# Initialize fzf
source <(fzf --zsh)

# Git status widget (^G^G)
# REF: https://github.com/junegunn/fzf-git.sh/blob/main/fzf-git.sh

__fzf_git_status() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        local msg="Not in a git repository"
        echo -e -n "\033[31m$msg\033[0m" > /dev/tty
        return 1
    fi

    local selected

    selected=$(git status -su | FZF_DEFAULT_OPTS=$FZF_CTRL_G_G_OPTS fzf)

    if [[ -n $selected ]]; then
        # Process multiple selected files
        local files=""
        while IFS= read -r line; do
            local filename=$(echo "$line" | sed 's/^...//')
            files="$files$filename "
        done <<< "$selected"
        LBUFFER="$LBUFFER$files"
    fi
}

# REF: https://github.com/junegunn/fzf/blob/master/shell/key-bindings.zsh
fzf-git-status-widget() {
    __fzf_git_status
    local ret=$?

    if [[ $ret -ne 0 ]]; then
        zle accept-line  # Start a new line
    else
        zle reset-prompt
    fi
    return $ret
}
zle -N fzf-git-status-widget
bindkey '^G^G' fzf-git-status-widget

# Ripgrep live search widget (^G^R)
__fzf_rg_live() {
    local selected

    selected=$(FZF_DEFAULT_OPTS=$FZF_CTRL_G_R_OPTS fzf)

    if [[ -n $selected ]]; then
        local files=""
        while IFS= read -r line; do
            local filename=$(echo "$line" | cut -d: -f1)
            files="$files$filename "
        done <<< "$selected"
        LBUFFER="$LBUFFER$files"
    fi
}

fzf-rg-live-widget() {
    __fzf_rg_live
    local ret=$?
    zle reset-prompt
    return $ret
}
zle -N fzf-rg-live-widget
bindkey '^G^R' fzf-rg-live-widget

