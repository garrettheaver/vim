""" BASIC OPTIONS
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
set backspace=indent,eol,start

""" LEADER SETUP
let mapleader=','

""" SET THE COLORSCHEME AND GO FULLSCREEN
if !has('gui_running')
  set t_Co=256
  set noesckeys
  runtime! bundle/guicolorscheme.vim/plugin/guicolorscheme.vim
  GuiColorScheme gmolokai
endif

""" LOAD UP ADDITIONAL PLUGINS
filetype off
silent! call pathogen#runtime_append_all_bundles()
silent! call pathogen#helptags()
runtime ftplugin/man.vim

""" AUTO SYNTAX HIGHLIGHT
syntax enable
filetype indent on
filetype plugin on
compiler ruby

""" ENABLE PARENTHESIS COLORS
au Syntax ruby,javascript RainbowParenthesesLoadRound
au Syntax ruby,javascript RainbowParenthesesLoadSquare
au Syntax ruby,javascript RainbowParenthesesLoadBraces
au VimEnter * RainbowParenthesesToggle

""" SPLIT OPTIONS
set splitright
set splitbelow

""" HIGHLIGHT SEARCHES
set incsearch

""" SET THE CODE FOLDING OPTIONS
set foldmethod=syntax
set foldlevel=3
set foldminlines=1

autocmd InsertEnter * if !exists('w:last_fdm') | let w:last_fdm=&foldmethod | setlocal foldmethod=manual | endif
autocmd InsertLeave,WinLeave * if exists('w:last_fdm') | let &l:foldmethod=w:last_fdm | unlet w:last_fdm | endif

""" SYNTAX FOLD XML
let g:xml_syntax_folding=1
autocmd FileType xml setlocal foldmethod=syntax

""" FIX HTML INDENT
let g:html_indent_inctags="html,body,head,tbody,p,li"

""" SET SOME FILETYPES BASED ON NAME
autocmd BufNewFile,BufRead Gemfile set filetype=ruby
autocmd BufNewFile,BufRead Guardfile set filetype=ruby

""" SET SPELL CHECKING
autocmd FileType cucumber,markdown setlocal spell spelllang=en_gb

""" RUNNING TESTS
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
  let binary = a:path =~ '_spec\.rb' ? 'rspec' : 'cucumber'
  let options = has('gui_running') ? ' --no-color ' : ' --color '
  exec '!bundle exec ' . binary . options . a:path
endfunction

""" INFER A SPEC FILENAME FROM A SOURCE FILENAME
function! InferSpecFile(path)

  let spec = substitute(a:path, '\.rb', '_spec.rb', '')

  if a:path =~ '\/app\/'
    return substitute(spec, '\/app\/', '/spec/', '')
  elseif a:path =~ '\/lib\/'
    let non_lib_spec = substitute(spec, '\/lib\/', '/spec/', '')
    let inc_lib_spec = substitute(spec, '\/lib\/', '/spec/lib/', '')

    if filereadable(non_lib_spec)
      return non_lib_spec
    elseif filereadable(inc_lib_spec)
      return inc_lib_spec
    else
      echoerr 'Unable to infer path for spec file'
    endif
  endif

endfunction

""" INFER A SOURCE FILENAME FROM A SPEC FILENAME
function! InferSourceFile(path)

  if a:path =~ '\/spec\/'
    let source = substitute(a:path, '_spec\.rb$', '.rb', '')
    let app_path = substitute(source, '\/spec\(\/app\)\?\/', '/app/', '')
    let lib_path = substitute(source, '\/spec\(\/lib\)\?\/', '/lib/', '')

    if filereadable(app_path)
      return app_path
    elseif filereadable(lib_path)
      return lib_path
    else
      echoerr 'Unable to infer path for source file'
    endif
  endif

endfunction

""" JUMP TO SPEC FROM SOURCE AND VICE-VERSA
autocmd FileType ruby,eruby,haml,cucumber,yaml map <silent> <buffer> <leader>j :call JumpToReciprocal(expand('%:p'))<CR>

function! JumpToReciprocal(path)
  let reciprocal = IsSpecFile(a:path) ? InferSourceFile(a:path) : InferSpecFile(a:path)
  if filereadable(reciprocal)
    call fuf#openFile(reciprocal, 3, 1)
  endif
endfunction

""" SET AND UNSET SPEC FOCUS
autocmd FileType ruby map <silent> <buffer> <leader>sf :call ToggleSpecFocus()<CR>

function! ToggleSpecFocus()
  let rexp = ', :focus => true do'
  let line = getline('.')

  if line =~ rexp . '$'
    call setline('.', substitute(line, rexp, ' do', ''))
  else
    call setline('.', substitute(line, ' do$', rexp, ''))
  end
endfunction

""" SET WHITESPACE HIGHLIGHT
highlight PoxyTabs ctermbg=cyan guibg=cyan
autocmd Syntax * syn match PoxyTabs /\t/ containedin=ALL
autocmd ColorScheme * highlight PoxyTabs ctermbg=cyan guibg=cyan
autocmd FileType diff,help,man syntax clear PoxyTabs

highlight PoxySpaces ctermbg=red guibg=red
autocmd Syntax * syn match PoxySpaces /\s\+$/ containedin=ALL
autocmd ColorScheme * highlight PoxySpaces ctermbg=red guibg=red
autocmd FileType diff,help,man syntax clear PoxySpaces

""" CUSTOM LEADER MAPS
map <silent> <leader>l :set list!<CR>
map <silent> <leader>n :set number<CR>
map <silent> <leader>N :set relativenumber<CR>

""" CUSTOM FORMAT FUNCTION
map <silent> <leader>f :call FormatFile()<CR>

function! FormatFile()
  norm myHmz
  exec 'retab'
  exec '%s/\s*$//ge'
  norm gg=G
  norm `zzt`y
  redraw!
endfunction

""" AUTO CREATE DIRECTORIES ON SAVE
autocmd BufWritePre * if expand("<afile>")!~#'^\w\+:/' && !isdirectory(expand("%:h")) | execute "silent! !mkdir -p ".shellescape(expand('%:h'), 1) | redraw! | endif

""" OTHER REMAPS
map <silent> <leader>Q :%s/\"/\'/g<CR>
map <silent> <leader>q :%s/\"/\'/gc<CR>

""" COMMAND ALIASES
command -nargs=* -complete=file -bang MoveTo call Rename(<q-args>, '<bang>')
cabbrev mv <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'MoveTo' : 'mv')<CR>

""" CONFIGURE FUZZYFINDER
let g:fuf_coveragefile_exclude = '\v(\~$|\.o$|\.png$|\.jpg$|\.gif$|\.svg$|\.exe$|\.bak$|\.swp$|\.class$|\/node_modules\/)'

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

if has('gui_running')
  set guioptions=-t
  colorscheme gmolokai

  if has('gui_win32')
    autocmd GUIEnter * :simalt ~x
    set guifont=Consolas:h10
    set backspace=2
  end

  if has('gui_macvim')
    set guifont=Consolas:h12
    autocmd GUIEnter * set fullscreen
    set columns=999
  endif
endif

""" SESSION SAVE AND RESTORE
map <silent> <leader>ss :mksession! .session<CR>
map <silent> <leader>rs :source .session<CR>

""" WHATS THAT SYNTAX GROUP
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
      \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
      \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
