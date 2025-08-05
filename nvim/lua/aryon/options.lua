vim.cmd([[
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
set inccommand=split
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
set norelativenumber
set wrap

" Window split
set splitright
set splitbelow

" Session options
" set sessionoptions=blank,buffers,curdir,folds,help,tabpages,winsize,terminal

" Ctags
set tags=./tags;,tags;
]])

--- Override base.vim
local o = vim.o -- options

local style = require("aryon.config").code_style

o.scrolloff = 3 -- keep cursor vertically centralized]])
o.colorcolumn = tostring(style.MAX_LENGTH)
o.undofile = true
-- o.showmode = false -- don't show mode in command line

o.list = true
vim.opt.listchars = { tab = "» ", nbsp = "␣", trail = "·", extends = "›", precedes = "‹" }

-- cursor
-- Set cursor shapes and blinking
-- vim.opt.guicursor = "n-v-c:block-Cursor/lCursor-blinkon1,i-ci:ver25-Cursor/lCursor-blinkon1,r-cr:hor20-Cursor/lCursor-blinkon1"
