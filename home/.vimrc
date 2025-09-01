" minimal vim config
set nocompatible              " be iMproved, required
filetype off                  " required

"call plug#begin('~/.vim/plugged')
"
"" Make sure you use single quotes
"Plug 'tpope/vim-sensible'
"
"Plug 'jiangmiao/auto-pairs'
"Plug 'tpope/vim-surround'
"Plug 'mg979/vim-visual-multi', {'branch': 'master'}
"
"Plug 'tpope/vim-commentary'
"Plug 'machakann/vim-highlightedyank'
"
"" theme
"" Plug 'nordtheme/vim'
"
"" Initialize plugin system
"call plug#end()

" Common setups across editors

" language ja_JP

" Set global options
set autoindent
set autoread
set dir=/tmp
set expandtab
set hidden
set hlsearch
set ignorecase
set incsearch
set infercase
" set laststatus=2
set mouse=a
set smartcase
set swapfile
set title
" set spell
" set spelllang=en

" Indentation
set smartindent
set shiftwidth=4
set tabstop=4
set softtabstop=4
set breakindent

" NonText
" set list
" set listchars+=space:⋅
" set listchars+=eol:↴
" set listchars+=tab:»·

set colorcolumn=80
set termguicolors
set bg=dark " Assuming bg is dark

set equalalways

set wildignore+=*/node_modules/*,*/vendor/*
" set shortmess+=I " disable :intro

" Window-local options
" set cursorcolumn
set cursorline
set number
set relativenumber
set wrap

" Window split
set splitright
set splitbelow

" Session options
" set sessionoptions=blank,buffers,curdir,folds,help,tabpages,winsize,terminal

" Ctags
set tags=./tags;,tags;

" Keymaps
let mapleader = ','

" DON'Ts
" nnoremap d "_d           " Do Not Cut
" vnoremap d "_d           " Do Not Cut
" nnoremap <C-h> <Left>    " Left
" nnoremap <C-j> <Down>    " Down
" nnoremap <C-k> <Up>      " Up
" nnoremap <C-l> <Right>   " Right
" tnoremap <Esc> <C-\><C-n> " [Term] Normal mode

" Basic keymaps
nnoremap + <C-a>
nnoremap - <C-x>
nnoremap <C-[> <Esc>
inoremap <C-[> <Esc>
nnoremap <C-e> 3<C-e>
vnoremap <C-e> 3<C-e>
nnoremap <C-w>+ 5<C-w>+
nnoremap <C-w>- 5<C-w>-
nnoremap <C-w>< 5<C-w><
nnoremap <C-w>> 5<C-w>>
nnoremap <C-y> 3<C-y>
vnoremap <C-y> 3<C-y>
nnoremap c "_c
vnoremap c "_c
nnoremap ge :tabp<CR>
nnoremap gt :tabnext<CR>
nnoremap te <C-w>s<C-w>T
nnoremap tn :tabnew<CR>
nnoremap tq :tabclose<CR>
nnoremap tt :tabnew +term<CR>
nnoremap <Space> za
nnoremap <Esc> :nohl<CR>
vnoremap <BS> <C-g>u<BS>
nnoremap Y y$

" Insert mode bindings
" Readline
inoremap <C-a> <Home>
cnoremap <C-a> <Home>
inoremap <C-b> <Left>
cnoremap <C-b> <Left>
inoremap <C-d> <C-o>x
cnoremap <C-d> <C-o>x
inoremap <C-e> <End>
cnoremap <C-e> <End>
inoremap <C-f> <Right>
cnoremap <C-f> <Right>
inoremap <C-k> <C-o>D
inoremap <C-n> <Down>
inoremap <C-p> <Up>
" Others
inoremap <Tab> <C-t>
inoremap <S-Tab> <C-d>

" Window navigation
nnoremap <Down> <C-w>j
nnoremap <C-j> <C-w>j
nnoremap <Left> <C-w>h
nnoremap <C-h> <C-w>h
nnoremap <Right> <C-w>l
nnoremap <C-l> <C-w>l
nnoremap <Up> <C-w>k
nnoremap <C-k> <C-w>k
nnoremap <C-w>o <C-w>\|<C-w>_
nnoremap <C-w>z <C-w>\|<C-w>_
nnoremap <C-w>\ <C-w>v
nnoremap <C-w>- <C-w>s

" Quickfix mappings
nnoremap ]q :cnext<CR>
nnoremap [Q :cfirst<CR>
nnoremap [q :cNext<CR>
nnoremap ]Q :clast<CR>

" Tab number mappings
nnoremap <leader>1 1gt
nnoremap <leader>2 2gt
nnoremap <leader>3 3gt
nnoremap <leader>4 4gt
nnoremap <leader>5 5gt
nnoremap <leader>6 6gt
nnoremap <leader>7 7gt
nnoremap <leader>8 8gt
nnoremap <leader>9 9gt

" Window number mappings
nnoremap <C-w>1 1<C-w>w
nnoremap <C-w>2 2<C-w>w
nnoremap <C-w>3 3<C-w>w
nnoremap <C-w>4 4<C-w>w
nnoremap <C-w>5 5<C-w>w
nnoremap <C-w>6 6<C-w>w
nnoremap <C-w>7 7<C-w>w
nnoremap <C-w>8 8<C-w>w
nnoremap <C-w>9 9<C-w>w

" tree
let g:netrw_liststyle = 3

" Appearance
set background=dark
colorscheme industry

syntax on

" clipboard
set clipboard+=unnamedplus
nnoremap y "*y
nnoremap c "_c
