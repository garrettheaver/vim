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
" SYNTAX FOLD XML
"
let g:xml_syntax_folding=1
autocmd FileType xml setlocal foldmethod=syntax

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
    set backspace=2
  end

  if has('gui_macvim')
    set columns=999
    autocmd GUIEnter * set fullscreen
  endif

endif

"
" CUSTOM REFORMAT FUNCTION
"
function! FormatFile()
  :norm myHmz
  :exec 'retab'
  :exec '%s/\s*$//g'
  :exec 'normal gg=G'
  :norm `zzt`y
endfunction

"
" REMAPS
"
let mapleader=','
map <silent> <leader>ff :call FormatFile()<CR>
map <silent> <leader>fqa :%s/\"/\'/g<CR>
map <silent> <leader>fqc :%s/\"/\'/gc<CR>
map <silent> <leader>w :w<CR>
map <silent> <leader>a= :Tabularize /=<CR>
map <silent> <leader>a: :Tabularize /:\zs<CR>
map <silent> <leader>ut :GundoToggle<CR>
map <silent> <leader>ur :GundoRenderGraph<CR>

"
" Configure the FuzzyFileFinder
"
function! FufOpenCurrent()
  let g:fuf_keyOpen='<CR>'
  let g:fuf_keyOpenVsplit=''
  let g:fuf_keyOpenSplit=''
  exe 'FufCoverageFile'
endfunction

function! FufOpenVsplit()
  let g:fuf_keyOpen=''
  let g:fuf_keyOpenVsplit='<CR>'
  let g:fuf_keyOpenSplit=''
  exe 'FufCoverageFile'
endfunction

function! FufOpenHsplit()
  let g:fuf_keyOpen=''
  let g:fuf_keyOpenVsplit=''
  let g:fuf_keyOpenSplit='<CR>'
  exe 'FufCoverageFile'
endfunction

map <silent> <leader>e :call FufOpenCurrent()<CR>
map <silent> <leader>sv :call FufOpenVsplit()<CR>
map <silent> <leader>sh :call FufOpenHsplit()<CR>
map <silent> <leader>fr :FufRenewCache<CR>
