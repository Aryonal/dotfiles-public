" Common options across editors

" language ja_JP

" default options are commented out
" set autoindent
"set autoread
"set hidden
"set hlsearch
"set incsearch
"set swapfile
"set equalalways

" Nvim only?
" set inccommand=split
" set spell
" set spelllang=en

set dir=/tmp " default " $XDG_STATE_HOME/nvim/swap//
set expandtab " off
set ignorecase " off
set infercase " off
set mouse=a " nvi -- normal, visual, insert
set smartcase " off
set title " off

" Indentation
set smartindent " off
set breakindent " off

set colorcolumn=80
set termguicolors " off
set bg=dark " Assuming bg is dark
set wildignore+=*/node_modules/*,*/vendor/*

" Window-local options
" set cursorcolumn
set cursorline
set number
"set relativenumber
set wrap
" default indentation
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab


" Window split
set splitright
set splitbelow

" Ctags
set tags=./tags;,tags;
