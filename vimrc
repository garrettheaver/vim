"
" BASIC OPTIONS
"
set nocompatible
set hidden
set number
set ruler
set expandtab
set tabstop=2
set shiftwidth=2
set autoindent
set smartindent
set noswapfile
set nowrap
set wildmode=list:longest
set laststatus=2

"
" LEADER SETUP
"
let mapleader=','

"
" LOAD UP ADDITIONAL PLUGINS
"
silent! call pathogen#runtime_append_all_bundles()

"
" AUTO SYNTAX HIGHLIGHT
"
syntax enable
filetype plugin indent on

"
" SPLIT OPTIONS
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
autocmd FileType ruby,eruby,haml,cucumber,yaml map <silent> <buffer> <leader>t :call SaveAndRunSpecs(expand('%:p'))<CR>
autocmd FileType ruby,eruby,haml,cucumber,yaml map <silent> <buffer> <leader>T :call SaveAndRunSpecs(expand('%:p'), line('.'))<CR>

function! SaveAndRunSpecs(...)
  exec 'w'

  let run_single_spec = exists('a:2')
  let is_spec_file = IsSpecFile(a:1)
  let infered_spec_file = is_spec_file ? a:1 : InferSpecFile(a:1)

  if is_spec_file && run_single_spec
    let g:spec_file_to_run = infered_spec_file
    let g:spec_line_to_run = infered_spec_file . ':' . a:2
    call ExecuteSpecCommand(g:spec_line_to_run)
  elseif exists('g:spec_line_to_run') && run_single_spec
    call ExecuteSpecCommand(g:spec_line_to_run)
  elseif filereadable(infered_spec_file)
    let g:spec_file_to_run = infered_spec_file
    call ExecuteSpecCommand(g:spec_file_to_run)
  elseif exists('g:spec_file_to_run')
    call ExecuteSpecCommand(g:spec_file_to_run)
  else
    return
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

"
" INFER A SPEC FILENAME FROM A SOURCE FILENAME
"
function! InferSpecFile(path)

  let spec = substitute(a:path, '\..\+$', '_spec.rb', '')

  if a:path =~ '\/app\/'
    return substitute(spec, '\/app\/', '/spec/', '')
  elseif a:path =~ '\/lib\/'
    let non_lib_spec = substitute(spec, '\/lib\/', '/spec/', '')
    let inc_lib_spec = substitute(spec, '\/lib\/', '/spec/lib/', '')

    if filereadable(non_lib_spec)
      return non_lib_spec
    elseif filereadable(inc_lib_spec)
      return inc_lib_spec
    endif
  endif

endfunction

"
" INFER A SOURCE FILENAME FROM A SPEC FILENAME
"
function! InferSourceFile(path)

  if a:path =~ '\/spec\/'
    let source = substitute(a:path, '_spec\.rb$', '.rb', '')
    let app_path = substitute(source, '\/spec\/', '/app/', '')
    let lib_path = substitute(source, '\/spec\(\/lib\)?\/', '/lib/', '')

    if filereadable(app_path)
      return app_path
    elseif filereadable(lib_path)
      return lib_path
    endif
  endif

endfunction

"
" JUMP TO SPEC FROM SOURCE AND VICE-VERSA
"
autocmd FileType ruby,eruby,haml,cucumber,yaml map <silent> <buffer> <leader>j :call JumpToReciprocal(expand('%:p'))<CR>

function! JumpToReciprocal(path)
  let reciprocal = IsSpecFile(a:path) ? InferSourceFile(a:path) : InferSpecFile(a:path)
  if filereadable(reciprocal)
    call fuf#openFile(reciprocal, 2, 1)
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
" DISABLE TOOLBAR AND GO FULLSCREEN ON GUI
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
map <silent> <leader>f :call FormatFile()<CR>

function! FormatFile()
  norm myHmz
  exec 'retab'
  exec '%s/\s*$//ge'
  norm gg=G
  norm `zzt`y
  redraw!
endfunction

"
" OTHER REMAPS
"
map <silent> <leader>Q :%s/\"/\'/g<CR>
map <silent> <leader>q :%s/\"/\'/gc<CR>
map <silent> <leader>a= :Tabularize /=<CR>
map <silent> <leader>a: :Tabularize /:\zs<CR>
map <silent> <leader>u :GundoToggle<CR>

"
" COMMAND ALIASES
"
command -nargs=* -complete=file -bang MoveTo call Rename(<q-args>, '<bang>')
cabbrev mv <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'MoveTo' : 'mv')<CR>

"
" CONFIGURE FUZZYFINDER
"
map <silent> <leader>e :call FufOpenCurrent()<CR>
map <silent> <leader>v :call FufOpenVsplit()<CR>
map <silent> <leader>h :call FufOpenHsplit()<CR>

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

"
" SESSION SAVE AND RESTORE
"
map <silent> <leader>ss :mksession! .session<CR>
map <silent> <leader>rs :source .session<CR>
