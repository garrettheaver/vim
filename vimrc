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
" DISABLE THE TOOLBAR AND GO FULLSCREEN ON GUI
"
if has('gui_running')
  set guioptions=-t
  colorscheme dante

  if has('gui_win32')
    autocmd GUIEnter * :simalt ~x
  end

  if has('gui_macvim')
    set columns=999
    autocmd GUIEnter * set fullscreen
  endif

endif

"
" REMAPS
"
nnoremap <C-w>f <C-w>v<C-w>lgf
nnoremap <C-w>F <C-w>s<C-w>jgf

let mapleader=','
map! <Leader>f <Esc>:retab<Cr> \| <Esc>:%s/\s*$//g<Cr> \| <Esc>gg=G
