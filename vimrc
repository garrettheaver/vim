set nocompatible

"
" LOAD UP ADDITIONAL PLUGINS
"
silent! call pathogen#runtime_append_all_bundles()

set hidden
set number
set ruler

syntax enable
filetype plugin indent on

set wildmode=list:longest
set laststatus=2

set expandtab
set tabstop=2
set shiftwidth=2
set autoindent
set smartindent

set noswapfile

"
" HIGHLIGHT SEARCHES
"
set incsearch

"
" SET THE CODE FOLDING OPTIONS
"
set foldmethod=syntax
set foldlevel=1
set foldminlines=1

highlight Folded guibg=grey20 guifg=grey80
autocmd ColorScheme * highlight Folded guibg=grey20 guifg=grey80

"
" SET WHITESPACE HIGHLIGHT
"
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red

match ExtraWhitespace /\(\t\|\s\+$\)/

"
" DISABLE THE TOOLBAR ON GUI
"
if has('gui_running')
  set guioptions=-t
  colorscheme dante
endif

"
" REMAPS
"
nnoremap <C-W>f <C-W>v<C-W>lgf
nnoremap <C-W>F <C-W>s<C-W>jgf

let mapleader=','
map! <Leader>f <Esc>gg=G
