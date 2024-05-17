" minimal vim config
set nocompatible              " be iMproved, required
filetype off                  " required

call plug#begin('~/.vim/plugged')

" Make sure you use single quotes
Plug 'tpope/vim-sensible'

Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}

" theme
" Plug 'nordtheme/vim'

" Initialize plugin system
call plug#end()

set autoindent
set cursorline
set encoding=utf-8
set hidden
set hlsearch
set ignorecase
set incsearch
set mouse=a
set nu
set splitbelow
set splitright
set termguicolors
set title
set wrap
set equalalways

set foldmethod=indent
set foldlevel=99

set directory=/tmp

" Keymaps
let mapleader = ','
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>
vnoremap <C-e> 3<C-e>
vnoremap <C-y> 3<C-y>

nnoremap <Space> za

nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <Left> <C-w>h
nnoremap <Right> <C-w>l
nnoremap <Down> <C-w>j
nnoremap <Up> <C-w>k

inoremap <C-[> <Esc>
nnoremap <C-[> <Esc>

nnoremap te <C-w>T
nnoremap tn :tabnew .<CR>
nnoremap tq :tabclose<CR>
nnoremap ge :tabprev<CR>

nnoremap <C-\> :e .<CR>

nnoremap sn :nohl<CR>

" inoremap <C-w> <C-o>vbd
inoremap <C-a> <C-o>I
inoremap <C-b> <C-o>b
inoremap <C-d> <C-o>x
inoremap <C-e> <C-o>A
inoremap <C-f> <C-o>e
inoremap <Tab> <C-t>
inoremap <S-Tab> <C-d>

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
