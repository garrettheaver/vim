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

"
" SYNTAX FOLD XML
"
let g:xml_syntax_folding=1
autocmd FileType xml setlocal foldmethod=syntax

"
" RUNNING TESTS
"
autocmd FileType ruby map <Leader>t :call RunTests()<CR>

function! RunTests()
  exec 'w'

  let path = expand('%')
  if path =~ '_spec\.rb$'
    exec '!rspec --no-color %'
  endif
endfunction

"
" SET WHITESPACE HIGHLIGHT
"
highlight PoxyTabs ctermbg=cyan guibg=cyan
autocmd Syntax * syn match PoxyTabs /\t/ containedin=ALL
autocmd ColorScheme * highlight PoxyTabs ctermbg=cyan guibg=cyan
autocmd FileType diff,help syntax clear PoxyTabs

highlight PoxySpaces ctermbg=red guibg=red
autocmd Syntax * syn match PoxySpaces /\s\+$/ containedin=ALL
autocmd ColorScheme * highlight PoxySpaces ctermbg=red guibg=red
autocmd FileType diff,help syntax clear PoxySpaces

"
" DISABLE THE TOOLBAR AND GO FULLSCREEN ON GUI
"
if has('gui_running')

  set guioptions=-t
  colorscheme gmolokai

  if has('gui_win32')
    autocmd GUIEnter * :simalt ~x
    set guifont=Consolas:h10
    set backspace=2
  end

  if has('gui_macvim')
    set columns=999
    set guifont=Consolas:h12
    autocmd GUIEnter * set fullscreen
  endif

endif

"
" CUSTOM FORMAT FUNCTION
"
function! FormatFile()
  norm myHmz
  exec 'retab'
  exec '%s/\s*$//ge'
  norm gg=G
  norm `zzt`y
  redraw!
endfunction

"
" REMAPS
"
let mapleader=','
map <silent> <leader>ff :call FormatFile()<CR>
map <silent> <leader>fqa :%s/\"/\'/g<CR>
map <silent> <leader>fqc :%s/\"/\'/gc<CR>
map <silent> <leader>a= :Tabularize /=<CR>
map <silent> <leader>a: :Tabularize /:\zs<CR>
map <silent> <leader>ut :GundoToggle<CR>

"
" Configure the FuzzyFileFinder
"
function! FufOpenCurrent()
  let g:fuf_keyOpen='<CR>'
  let g:fuf_keyOpenVsplit=''
  let g:fuf_keyOpenSplit=''
  exec 'FufRenewCache'
  exec 'FufCoverageFile'
endfunction

function! FufOpenVsplit()
  let g:fuf_keyOpen=''
  let g:fuf_keyOpenVsplit='<CR>'
  let g:fuf_keyOpenSplit=''
  exec 'FufRenewCache'
  exec 'FufCoverageFile'
endfunction

function! FufOpenHsplit()
  let g:fuf_keyOpen=''
  let g:fuf_keyOpenVsplit=''
  let g:fuf_keyOpenSplit='<CR>'
  exec 'FufRenewCache'
  exec 'FufCoverageFile'
endfunction

map <silent> <leader>e :call FufOpenCurrent()<CR>
map <silent> <leader>v :call FufOpenVsplit()<CR>
map <silent> <leader>h :call FufOpenHsplit()<CR>

"
" SESSION SAVE AND RESTORE
"
set sessionoptions+=resize
map <silent> <leader>ss :mksession! .vimsession<CR>
map <silent> <leader>rs :source .vimsession<CR><C-w>=<CR>
