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

"
" SET THE CODE FOLDING OPTIONS
"
set foldmethod=syntax
set foldlevel=2
set foldminlines=1

function! ToggleFold()
  if foldlevel('.') == 0
    normal! 1
  else
    if foldclosed('.') < 0
      . foldclose
    else
      . foldopen
    endif
  endif
  echo
endf

noremap z :call ToggleFold()<cr>

highlight Folded guibg=grey20 guifg=grey80
autocmd ColorScheme * highligh Folded guibg=grey20 guifg=grey80

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
