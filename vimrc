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

"
" DEFINE THE TAB OPTIONS
"
set expandtab
set tabstop=2
set shiftwidth=2
set autoindent
set smartindent
set nowrap

set noswapfile

"
" DEFINE THE SPLIT OPTIONS
"
set splitright
set splitbelow

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
highlight PoxyTabs ctermbg=cyan guibg=cyan
autocmd Syntax * syn match PoxyTabs /\t/ containedin=ALL
autocmd ColorScheme * highlight PoxyTabs ctermbg=cyan guibg=cyan

highlight PoxySpaces ctermbg=red guibg=red
autocmd Syntax * syn match PoxySpaces /\s\+$/ containedin=ALL
autocmd ColorScheme * highlight PoxySpaces ctermbg=red guibg=red

"
" DISABLE THE TOOLBAR AND GO FULLSCREEN ON GUI
"
if has('gui_running')
  set guioptions=-t
  colorscheme darkz

  if has('gui_win32')
    autocmd GUIEnter * :simalt ~x
    set guifont=Consolas:h10:cDEFAULT
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
nmap <Leader>f <Esc>:retab<Cr> \| <Esc>:%s/\s*$//g<Cr> \| <Esc>gg=G
