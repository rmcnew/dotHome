" Scott's VIM settings

set nocompatible     " do not emulate vi (this is set first because it has side effects)
set term=xterm
set encoding=utf-8
set fileencoding=utf-8

syntax on
colorscheme elflord
if has('gui_running')
    set guifont=Hack\ 13
endif
set autoindent            " always set autoindenting on
set backspace=2           " allow backspacing over everything in insert mode
set cindent shiftwidth=4  " Same thing with cindent
set diffopt=filler,iwhite " keep files synced and ignore whitespace
set tabstop=4       " four spaces per tab
set shiftwidth=4
set softtabstop=4
set expandtab       " convert tabs to spaces
set foldlevel=0           " show contents of all folds
set foldmethod=diff " fold according to differences
set showmatch       " show matching parens and braces
set incsearch       " do incremental searching
set hlsearch        " search highlighting
set linebreak             " This displays long lines as wrapped at word boundries
set ruler           " tell cursor's  position on the status line
set laststatus=2    " show the status line
set statusline=
set statusline+=%2*%-3.3n%0*\                " buffer number
set statusline+=%f\                          " file name
set statusline+=%h%1*%m%r%w%0*               " flags
set statusline+=\[%{strlen(&ft)?&ft:'none'}, " filetype
set statusline+=%{&encoding},                " encoding
set statusline+=%{&fileformat}]              " file format
set history=500     " number of lines in command-line history
set undolevels=1000 " number of undo levels
set noerrorbells    " no beeps or bells
set nobackup        " do not keep a backup file
set shell=/bin/zsh  " define the preferred shell
set nostartofline   " keep the cursor on the current column of each line
set title           " put the title as VIM - filename
set splitbelow      " put new windows below the current window
set splitright      " put new windows to the right of the current window
set showbreak=\     " put \ on the front of a wrapped line
set notextmode      " do not append carriage returns
set wildmenu      " the wild card menu
set wildmode=list:longest  " do path expansion in colon mode
set guioptions-=m         " Remove menu from the gui
set guioptions-=T         " Remove toolbar
set hidden                " hide buffers instead of closing
set cscopequickfix=s-,c-,d-,i-,t-,e-,g-,f-   " useful for cscope in quickfix
set listchars=tab:>-,trail:-                 " prefix tabs with a > and trails with -
set tags+=./.tags,.tags,../.tags,../../.tags " set ctags
set whichwrap+=<,>,[,],h,l,~                 " arrow keys can wrap in normal and insert modes

" make vimdiff legible
highlight DiffAdd term=reverse cterm=bold ctermbg=green ctermfg=white
highlight DiffChange term=reverse cterm=bold ctermbg=cyan ctermfg=black
highlight DiffText term=reverse cterm=bold ctermbg=gray ctermfg=black
highlight DiffDelete term=reverse cterm=bold ctermbg=red ctermfg=black 

if has("autocmd")

  " Enabled file type detection and file-type specific plugins.
  filetype plugin indent on " detect file type and set options

  " Python code.
  augroup python
    autocmd BufReadPre,FileReadPre      *.py set tabstop=4
    autocmd BufReadPre,FileReadPre      *.py set expandtab
  augroup END

  " Ruby code.
  augroup ruby
    autocmd BufReadPre,FileReadPre      *.rb set tabstop=4
    autocmd BufReadPre,FileReadPre      *.rb set expandtab
  augroup END

  " PHP code.
  augroup php
    autocmd BufReadPre,FileReadPre      *.php set tabstop=4
    autocmd BufReadPre,FileReadPre      *.php set expandtab
  augroup END

  " Java code.
  augroup java
    autocmd BufReadPre,FileReadPre      *.java set tabstop=4
    autocmd BufReadPre,FileReadPre      *.java set expandtab
  augroup END

  " ANT build.xml files.
  augroup xml
    autocmd BufReadPre,FileReadPre      build.xml set tabstop=4
  augroup END

endif

autocmd FileType make set noexpandtab shiftwidth=8
autocmd FileType c,cpp,slang set cindent
autocmd FileType perl,css set smartindent

noremap <space> <pagedown>
noremap <bs> <pageup>
inoremap <Nul> <C-x><C-o>  "Omnicompletion using Ctrl-Space (console)

" Vim 7 tabs :)
set tabpagemax=50
map th :tabprev<CR>
map tl :tabnext<CR>
map tn :tabnew<CR>
map td :tabclose<CR>
map tm0 :tabm 0<CR> " move tab to position n
map tm1 :tabm 1<CR>
map tm2 :tabm 2<CR>
map tm3 :tabm 3<CR>
map tm4 :tabm 4<CR>
map tm5 :tabm 5<CR>
map tm6 :tabm 6<CR>
map tm7 :tabm 7<CR>
map tm8 :tabm 8<CR>
map tm9 :tabm 9<CR>
map tm10 :tabm 10<CR>
map tm11 :tabm 11<CR>
map tm12 :tabm 12<CR>
map tm13 :tabm 13<CR>
map tm14 :tabm 14<CR>
map tm15 :tabm 15<CR>
map te :tabf

" LargeFile.vim settings
" don't run syntax and other expensive things on files larger than NUM megs
let g:LargeFile = 100

"normal mode maps
"Adding mail as a spell checked type, only if in 7.0 >
if (v:version >= 700)
au FileType mail set spell
endif

