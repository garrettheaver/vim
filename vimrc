set nocompatible
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

if has('gui_running')
  set guioptions=-t
  colorscheme dante
endif

highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\(\t\|\s\+$\)/
