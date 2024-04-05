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
Plug 'nordtheme/vim'

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
set scrolloff=8
set splitbelow
set splitright
set termguicolors
set title
set wrap

set foldmethod=indent
set foldlevel=99

set directory=/tmp

" Keymaps
let mapleader = ","

nnoremap <C-e> 5<C-e>
nnoremap <C-y> 5<C-y>
vnoremap <C-e> 5<C-e>
vnoremap <C-y> 5<C-y>

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

nnoremap <C-\> :e .<CR>

" tree
let g:netrw_liststyle = 3

" Appearance
set background=dark
colorscheme nord

syntax on

" clipboard
set clipboard+=unnamedplus
