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
" SET SPELL CHECKING
"
autocmd FileType cucumber setlocal spell spelllang=en_gb

"
" RUNNING TESTS
"
autocmd FileType ruby,eruby,haml,cucumber,yaml map <buffer> <leader>T :call SaveAndRunSpecs(expand('%:p'))<CR>
autocmd FileType ruby,eruby,haml,cucumber,yaml map <buffer> <leader>t :call SaveAndRunSpecs(expand('%:p'), line('.'))<CR>

function! SaveAndRunSpecs(...)
  exec 'w'

  let run_single_spec = exists('a:2')
  let is_spec_file = IsSpecFile(a:1)
  let infered_spec_file = is_spec_file ? a:1 : InferSpecFile(a:1)

  if is_spec_file && run_single_spec
    let g:spec_file_to_run = infered_spec_file
    let g:spec_line_to_run = infered_spec_file . ':' . a:2
    exec ExecuteSpecCommand(g:spec_line_to_run)
  elseif exists('g:spec_line_to_run') && run_single_spec
    exec ExecuteSpecCommand(g:spec_line_to_run)
  elseif filereadable(infered_spec_file)
    let g:spec_file_to_run = infered_spec_file
    exec ExecuteSpecCommand(g:spec_file_to_run)
  elseif exists('g:spec_file_to_run')
    exec ExecuteSpecCommand(g:spec_file_to_run)
  else
    echoerr 'Unable to determine spec file'
  endif

endfunction

function! IsSpecFile(path)
  return a:path =~ '\(_spec\.rb\|\.feature\)' ? 1 : 0
endfunction

function! ExecuteSpecCommand(path)
  let binary = a:path =~ '_spec\.rb' ? '!rspec' : '!cucumber'
  let options = has('gui_running') ? ' --no-color ' : ' --color '
  exec binary . options . a:path
endfunction

" INFER A SPEC FILENAME FROM A SOURCE FILENAME
function! InferSpecFile(path)

  if a:path =~ '\/app\/'
    " WE'RE INSIDE RAILS APP DIRECTORY
    let spec = substitute(a:path, '\..\+$', '_spec.rb', '')
    return substitute(spec, '\/app\/', '/spec/', '')
  elseif a:path =~ '\/lib\/'
    " WE'RE IN THE LIB DIRECTORY
    let spec = substitute(a:path, '\..\+$', '_spec.rb', '')

    " RAILS MAY USE spec/lib, GEMS USE spec/ ONLY
    let non_lib_spec = substitute(spec, '\/lib\/', '/spec/', '')
    let inc_lib_spec = substitute(spec, '\/lib\/', '/spec/lib/', '')

    if filereadable(non_lib_path)
      return non_lib_path
    elseif filereadable(inc_lib_path)
      return inc_lib_path
    endif

  endif

endfunction

" INFER A SOURCE FILENAME FROM A SPEC FILENAME
function! InferSourceFile(path)
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
else
  set t_Co=256
  set noesckeys
  runtime! manual/guicolorscheme/plugin/guicolorscheme.vim
  GuiColorScheme gmolokai
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
map <silent> <leader>f :call FormatFile()<CR>
map <silent> <leader>Q :%s/\"/\'/g<CR>
map <silent> <leader>q :%s/\"/\'/gc<CR>
map <silent> <leader>a= :Tabularize /=<CR>
map <silent> <leader>a: :Tabularize /:\zs<CR>
map <silent> <leader>u :GundoToggle<CR>

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
map <silent> <leader>ss :mksession! .session<CR>
map <silent> <leader>rs :source .session<CR><C-w>=<CR>
