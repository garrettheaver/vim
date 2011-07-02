" Created by Garrett
" Derived from DarkZ

set background=dark
if version > 580
  hi clear
  if exists("syntax_on")
    syntax reset
  endif
endif
let g:colors_name="gdarkz"

hi Normal guifg=#DFD6C1 guibg=gray16 gui=none

" highlight groups
hi Cursor       guifg=black          guibg=yellow   gui=none
hi ErrorMsg     guifg=#FF4400        guibg=bg       gui=none
hi VertSplit    guifg=gray40         guibg=gray40   gui=none
hi Folded       guifg=gray80         guibg=gray20   gui=none
hi IncSearch    guifg=SkyBlue        guibg=Blue
hi LineNr       guifg=gray40         gui=none
hi ModeMsg      guifg=SkyBlue        gui=none
hi NonText      guifg=gray40         gui=none
hi MoreMsg      guifg=SpringGreen    gui=none
hi Question     guifg=SpringGreen    gui=none
hi StatusLine   guifg=gray10         guibg=gray70   gui=none
hi StatusLineNC guifg=grey           guibg=gray40   gui=none
hi Title        guifg=#FF4400        gui=none       gui=none
hi Visual       guifg=bg             guibg=fg       gui=none
hi WarningMsg   guifg=salmon         gui=none
hi Pmenu        guifg=fg             guibg=#445599  gui=none
hi PmenuSel     guifg=bg             guibg=fg
hi WildMenu     guifg=gray           guibg=gray17   gui=none
hi MatchParen   guifg=cyan           guibg=#6C6C6C  gui=none

" syntax highlighting groups
hi Comment      guifg=gray50         gui=italic
hi Constant     guifg=#FF77FF        gui=none
hi Identifier   guifg=#6FDEF8        gui=none
hi Function     guifg=#82EF2A        gui=none
hi Statement    guifg=#FCFC63        gui=none
hi PreProc      guifg=#82EF2A        gui=none
hi Type         guifg=#33AFF3        gui=none
hi Special      guifg=orange         gui=none
hi Ignore       guifg=red            gui=none
hi Todo         guifg=red            guibg=yellow2     gui=none
