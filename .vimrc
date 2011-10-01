" must be first, changes behaviour of other settings
set nocompatible

" mouse and keyboard selections enter select mode, ctrl-q enters visual mode
set selectmode=mouse,key

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


" use 'comma' prefix for multi-stroke keyboard mappings
let mapleader = ","


" set grep to be grep, better have cygwin installed & on the path!
set grepprg=grep\ -n\ --exclude=*.pyc\ --exclude=tags\ --exclude-dir=domains\ --exclude-dir=.git\ --exclude-dir=.svn\ --exclude-dir=.hg
" grep for word under cursor
noremap <Leader>g :silent grep -rw '<C-r><C-w>' .<CR>:copen<CR>
" stop pyflakes from polluting the copen quickfix pane
let g:pyflakes_use_quickfix = 0
" map F3 to search jump thru grep results from copen
map <F3> :cnext<CR>


" F1 is annoying
noremap <F1> <Esc>

" map cut & paste to what they bloody should be
vnoremap <C-c> "+y
vnoremap <C-x> "+x
map <C-v> "+gP

" ctrl-s to save
map <C-s> :w<CR>
map! <C-s> <Esc>:w<CR>

" map sudo-write-file to w!! in command line
cmap w!! %!sudo tee > /dev/null %

"remap jj to escape in insert mode.
inoremap jj <Esc>

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
  set lines=40 columns=100
else
  " This is console Vim.
  if exists("+lines")
    set lines=40
  endif
  if exists("+columns")
    set columns=100
  endif
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

" don't wrap long lines, but display them as wrapped.
"set textwidth=0
"set wrap
" wrap at exactly char 80, not at space chars, etc.
"set nolinebreak
" no line wrapping
set nowrap

" allow cursor keys to go right off end of one line, onto start of next
set whichwrap+=<,>,[,]


" enable automatic yanking to and pasting from the selection
set clipboard+=unnamed

" tags for syntax highlighting
syntax on

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
map <f11> :!pysmell .<cr>

"autocompletion
inoremap <c-space> <c-n>
inoremap <c-s-space> <c-p>

" files to hide in directory listings
let g:netrw_list_hide='\.py[oc]$,\.svn/$,\.git/$,\.hg/$'

" I don't like folded regions
set nofoldenable


" fuzzyfind plugin
let s:extension = '\.bak|\.dll|\.exe|\.o|\.pyc|\.pyo|\.swp|\.swo'
let s:dirname = 'build|deploy|dist|\.bzr|\.git|\.hg|\.svn|.+\.egg-info'

let s:slash = '[/\\]'
let s:startname = '(^|'.s:slash.')'
let s:endname = '($|'.s:slash.')'

let g:fuf_file_exclude = '\v'.'('.s:startname.'('.s:dirname.')'.s:endname.')|(('.s:extension.')$)'
let g:fuf_dir_exclude = '\v'.s:startname.'('.s:dirname.')'.s:endname
let g:fuf_enumeratingLimit = 60

nnoremap <Leader>f :FufFile **/<cr>
nnoremap <Leader>b :FufBuffer<cr>
nnoremap <Leader>t :FufTag<cr>


" Change the color scheme from a list of color scheme names.
" Adapted Version 2010-09-12 from http://vim.wikia.com/wiki/VimTip341
" simplified by harry
" Press key:
"   Shift-F8          random scheme

if v:version < 700 || exists('loaded_setcolors') || &cp
  finish
endif

let loaded_setcolors = 1
" Get all colours from .vim/colors
let paths = split(globpath(&runtimepath, 'colors/*.vim'), "\n")
let s:mycolors = map(paths, 'fnamemodify(v:val, ":t:r")')

" Set next/previous/random (how = 1/-1/0) color from our list of colors.
" The 'random' index is actually set from the current time in seconds.
" Global (no 's:') so can easily call from command line.
function! NextColor()
  if len(s:mycolors) == 0
    call s:SetColors('all')
  endif
  if exists('g:colors_name')
    let current = index(s:mycolors, g:colors_name)
  else
    let current = -1
  endif
  let missing = []
  for i in range(len(s:mycolors))
    let current = localtime() % len(s:mycolors)
    let how = 1  " in case random color does not exist
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
  echo g:colors_name
endfunction

nnoremap <S-F8> :call NextColor()<CR>
call NextColor()

