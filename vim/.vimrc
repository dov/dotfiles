" must be first, changes behaviour of other settings
set nocompatible

" use 'comma' prefix for multi-stroke keyboard mappings
let mapleader = ","

" mouse and keyboard selections enter select mode, 
set selectmode=mouse,key

" ctrl-q doesnt work in console vim, so use leader-q 
" to enter block visual mode
nnoremap <leader>q <C-Q>

" right mouse button extends selection instead of context menu
set mousemodel=extend

" shift plus movement keys changes selection
set keymodel=startsel,stopsel

" allow cursor to be positioned one char past end of line
" and apply operations to all of selection including last char
set selection=exclusive

" allow backgrounding buffers without writing them
" and remember marks/undo for backgrounded buffers
set hidden

" Keep more context when scrolling off the end of a buffer
set scrolloff=3

" Make searches case-sensitive only if they contain upper-case characters
set ignorecase
set smartcase
" show search matches as the search pattern is typed
set incsearch
" search-next wraps back to start of file
set wrapscan
" highlight last search matches
set hlsearch
" map key to dismiss search highlightedness
map <bs> :noh<CR>




" set grep to be grep, better have cygwin installed & on the path!
set grepprg=grep\ -n\ --exclude=\"*.pyc\"\ --exclude=tags\ --exclude-dir=domains\ --exclude-dir=.git\ --exclude-dir=.svn\ --exclude-dir=.hg\ --exclude-dir=CACHE
" grep for word under cursor
noremap <Leader>g :silent grep -rw '<C-r><C-w>' .<CR>:copen<CR>
" stop pyflakes from polluting the copen quickfix pane
let g:pyflakes_use_quickfix = 0
" map F3 to search jump thru grep results from copen
map <F3> :cnext<CR>

" F1 is annoying
map <F1> <Esc>
map! <F1> <Esc>

" map cut & paste to what they bloody should be
vnoremap <C-c> "+y
vnoremap <C-x> "+x
map <C-v> "+gP

" ctrl-s to save
map <C-s> :w<CR>
map! <C-s> <Esc>:w<CR>

" move up/down by visible lines on long wrapped lines of text
nnoremap k gk
nnoremap j gj

" map sudo-write-file to w!! in command line
cmap w!! %!sudo tee > /dev/null %

"remap jj to escape in insert mode.
inoremap jj <Esc>

" make Y yank to end of line (consistent with C and D)
noremap Y y$

" make Q do somethign useful - format para
noremap Q gq}

" omit intrusive 'press ENTER' (etc) status line messages
set shortmess=atTWI

" make tab completion for files/buffers act like bash
set wildmenu

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Make backups in a single central place.
" Ending in double backslash makes name of temp files include path, thus
" allowing backups to be made of two files edited with same filename.
set backupdir=~/.vim/backups//
set directory=~/.vim/backups//
set backup

" display cursor co-ords at all times
set ruler
set cursorline

" display number of selected chars, lines, or size of blocks.
set showcmd


" show matching brackets, etc, for 1/10th of a second
set showmatch
set matchtime=1


" enables filetype specific plugins
filetype plugin on
" enables filetype detection
filetype on

if has("autocmd")

    " Enable file type detection.
    " Use the default filetype settings, so that mail gets 'tw' set to 72,
    " 'cindent' is on in C files, etc.
    " Also load indent files, to automatically do language-dependent indenting.
    filetype plugin indent on
    
    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

else
    " if old vim, set vanilla autoindenting on
    set autoindent

endif " has("autocmd")

"json...
au! BufRead,BufNewFile *.json setfiletype json
au! Syntax json source ~/.vim/syntax/json.vim

" window size
if has("gui_running")
  " GUI is running or is about to start.
  " Maximize gvim window.
  set lines=50 columns=180
endif


" sane text files
set fileformat=unix
set encoding=utf-8

" sane editing
set tabstop=4
set shiftwidth=4
set softtabstop=4

" convert all typed tabs to spaces
set expandtab
" always show status line
set laststatus=2


" load pathogen
call pathogen#infect()

" =====STATUS LINE OF DEATH!!=====
set statusline=
" filename, relative to cwd
set statusline+=%f
" separator
set statusline+=\ 

" modified flag
set statusline+=%#wildmenu#
set statusline+=%m
set statusline+=%*

"Display a warning if file encoding isnt utf-8
set statusline+=%#question#
set statusline+=%{(&fenc!='utf-8'&&&fenc!='')?'['.&fenc.']':''}
set statusline+=%*

"display a warning if fileformat isnt unix
set statusline+=%#directory#
set statusline+=%{&ff!='unix'?'['.&ff.']':''}
set statusline+=%*

"display a warning if files contains tab chars
set statusline+=%#warningmsg#
set statusline+=%{StatuslineTabWarning()}
set statusline+=%*

"display a warning for any syntastic syntax errors
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

" read-only
set statusline+=%r
set statusline+=%*

" right-align
set statusline+=%=

" filetype
set statusline+=%{strlen(&ft)?&ft:'none'}
" separator
set statusline+=\ 

" current char
set statusline+=%3b,0x%02B
" separator
set statusline+=\ 

" column,
set statusline+=%2c,
" current line / lines in file
set statusline+=%l/%L

" always show status line
set laststatus=2

" return '[tabs]' if tab chars in file, or empty string
function! StatuslineTabWarning()
    if !exists("b:statusline_tab_warning")
        let tabs = search('\t', 'nw') != 0

        if tabs
            let b:statusline_tab_warning = '[tabs]'
        else
            let b:statusline_tab_warning = ''
        endif
    endif
    return b:statusline_tab_warning
endfunction
"recalculate the tab warning flag when idle and after writing
autocmd cursorhold,bufwritepost * unlet! b:statusline_tab_warning


" line numbers
set number

" when joining lines, don't insert two spaces after punctuation
set nojoinspaces

" display long lines as wrapped
set wrap

" wrap at word breaks
set linebreak
" show an ellipsis at the start of wrapped lines
set showbreak=…

" discretely highlight lines which are longer than the specified width
" only long lines are highlighted (making this less intrusive than colorcolumn)
" width defaults to 80. pass 0 to turn off.
function! s:HighlightLongLines(width)
    let targetWidth = a:width != '' ? a:width : 80
    if targetWidth > 0
        exec 'match ColorColumn /\%' . (targetWidth + 1) . 'v/'
    else
        exec 'match'
    endif
endfunction


" toggle the highlighting of long lines
command! -nargs=? HighlightLongLines call s:HighlightLongLines('<args>')
let s:highlight_long_lines = 0
function! ToggleHighlightLongLines()
    if s:highlight_long_lines == 0
        HighlightLongLines
        let s:highlight_long_lines = 1
    else
        HighlightLongLines 0
        let s:highlight_long_lines = 0
    endif
endfunction
noremap <leader>L :call ToggleHighlightLongLines()<cr>


" toggle wrapped appearance of long lines
function! ToggleWrap()
    if &wrap == 0
        set wrap
    else
        set nowrap
    endif
endfunction
noremap <leader>w :call ToggleWrap()<cr>


" toggle relative line numbering
let s:relative_numbering = 0
function! ToggleNumbering()
    if s:relative_numbering == 0
        exec 'set relativenumber'
        let s:relative_numbering = 1
    else
        exec 'set relativenumber!'
        exec 'set number'
        let s:relative_numbering = 0
    endif
endfunction
noremap <leader>r :call ToggleNumbering()<cr>



" allow cursor keys to go right off end of one line, onto start of next
set whichwrap+=<,>,[,]


" enable automatic yanking to and pasting from the selection
set clipboard+=unnamed

" close buffer without closing window
noremap <C-BS> :bp<cr>bd #<cr>


" tags for syntax highlighting
syntax on

" allegedly faster regex engine for syntax stuff
set regexpengine=1 

"make sure highlighting works all the way down long files
autocmd BufEnter * :syntax sync fromstart


" places to look for tags files:
set tags=./tags,tags
" recursively search file's parent dirs for tags file
" set tags+=./tags;/
" recursively search cwd's parent dirs for tags file
set tags+=tags;/

" generate tags for all files in the current dir (recursive on subdirs)
"map <f12> :!start /min ctags -R --exclude=build .<cr>
map <f12> :!ctags -R --exclude=build .<cr>
map <Leader>C :!ctags -R --exclude=build .<cr>
map <f11> :!pysmell .<cr>

" Jedi autocompleter
let g:jedi#goto_assignments_command = "<leader>a"  "default ,g conflicts with grep
let g:jedi#goto_definitions_command = "<leader>t"  "default ,d conflicts with dontify
let g:jedi#use_tabs_not_buffers = 0

" switch on colourful brackets
let g:rainbow_active = 1

" use python3 syntax checker
let g:syntastic_python_python_exec = '/usr/bin/python3'

" use jslint for html (requires my fork of syntastic and jslint 0.1.4)
let g:syntastic_html_checkers=['jslint', 'validator']
let g:syntastic_javascript_checkers=['jslint']
let g:syntastic_html_jslint_args="--sloppy --browser --vars --"
let g:syntastic_javascript_jslint_args="--sloppy --browser --vars --"
" set up jshint as an option too (can remove this if i decide to drop jsl and
" go back to trunk, since its now supported.)
let g:syntastic_html_jshint_args="--extract=always"
" switch off asciidoc checker, cos it takes too long.
let g:syntastic_asciidoc_checkers=['']
" use loclist to display errors
let g:syntastic_always_populate_loc_list = 1
" map F4 to search jump thru errors of lopen
map <F4> :lnext<CR>
" nb, syntastic may not find checkers installed in ~/.local


" files to hide in directory listings
let g:netrw_list_hide='\.py[oc]$,\.svn/$,\.git/$,\.hg/$'
set wildignore+=*.pyc

" I don't like folded regions
set nofoldenable

" aliases for window switching
noremap <C-l> <C-w>l
noremap <C-h> <C-w>h
noremap <C-k> <C-w>k
noremap <C-j> <C-w>j


" CtrlP settings
let g:ctrlp_map = '<c-p>'
let g:ctrlp_custom_ignore = '\.git$\|\.hg$\|\.svn$|.pyc$|virtualenv'
" don't try to be too clever with working paths. 
let g:ctrlp_working_path_mode = ''
noremap <Leader>f :CtrlP<CR>
noremap <Leader>b :CtrlPBuffer<CR>
noremap <Leader>p :CtrlPClearAllCaches<CR>

" Change the color scheme from a list of color scheme names.
" Adapted Version 2010-09-12 from http://vim.wikia.com/wiki/VimTip341
" Press key   shift - F8 random scheme
if v:version < 700 || exists('loaded_setcolors') || &cp
  finish
endif

let loaded_setcolors = 1
" Get all colours from .vim/colors
let paths = split(globpath(&runtimepath, 'colors/*.vim'), "\n")
let s:mycolors = map(paths, 'fnamemodify(v:val, ":t:r")')

" Set random color from our list of colors.
" The 'random' index is actually set from the current time in seconds.
" Global (no 's:') so can easily call from command line.
function! NextColor(echo_color)
  if exists('g:colors_name')
    let current = index(s:mycolors, g:colors_name)
  else
    let current = -1
  endif
  let missing = []
  for i in range(len(s:mycolors))
    let current = localtime() % len(s:mycolors)
    try
      execute 'colorscheme '.s:mycolors[current]
      break
    catch /E185:/
      call add(missing, s:mycolors[current])
    endtry
  endfor
  redraw
  if len(missing) > 0
    echo 'Error: colorscheme not found:' join(missing)
  endif
  if (a:echo_color)
    echo s:mycolors[current]
  endif
endfunction

nnoremap <S-F8> :call NextColor(1)<CR>
nnoremap <Leader>c :call NextColor(1)<CR>
call NextColor(0)

