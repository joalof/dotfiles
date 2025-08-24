set nocompatible
if (has("termguicolors"))
  set termguicolors
endif

" vim hardcodes background color erase even if the terminfo file does
" not contain bce. This causes incorrect background rendering when
" using a color theme with a background color.
let &t_ut=''


" Sensible configs
set autoread " Reload file to see changes made outside vim
set hidden
set scrolloff=3 " How many from bottom left before scrolling
set backspace=indent,eol,start " Fix backspace
set noswapfile
set nobackup
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<

if has('path_extra')
    setglobal tags-=./tags tags-=./tags; tags^=./tags;
endif

if &encoding ==# 'latin1' && has('gui_running')
    set encoding=utf-8
endif

if &synmaxcol == 3000
    " Lowering this improves performance in files with long lines.
    set synmaxcol=500
endif

if v:version > 703 || v:version == 703 && has("patch541")
    set formatoptions+=j " Delete comment character when joining commented lines
endif

if &history < 1000
    set history=1000
endif

if &tabpagemax < 50
    set tabpagemax=50
endif

let g:tex_flavor = "latex"

if has("persistent_undo")
    set undodir=$HOME."/.vim/.undodir"
    set undofile
endif


" Preferred configs 

" autoindent & load filetype-specific indent files
" note: smartindent should not be used
set autoindent
filetype indent on

set tabstop=8
set softtabstop=4
set shiftwidth=4
set expandtab

set nomousehide
set splitbelow
set splitright
set number " Show line numbers
set showmatch " Highlight matching {[()]}
set display+=lastline
set clipboard=unnamedplus
set undofile
set undodir=~/.vim/undodir

" cursor
" set cursorline 
let &t_SI = "\e[6 q"
let &t_SR = "\e[4 q"
let &t_EI = "\e[2 q"

" wildmenu
set wildmenu " Visual autocomplete for command menu
set wildmode=list:longest,full " Display a full list on first tab
set wildignore=*.o,*.obj,*~
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif,*.eps
set wildignore+=*/__pycache__/,*/.aux,*/.cls,*/.bbl,*/.blg,*/.fls,*/.fdb*/,*/.toc,*/.glo,*/.ist,*/.fdb_latexmk

" searching
set incsearch " Search as characters are entered
set hlsearch
set ignorecase " Non-case-sensitive searching...
set smartcase  " ...except for when search has uppercase letters

" autosave
set autowriteall
autocmd CursorHold * update

" netrw - file exploration
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25


" Functions {{{

function! s:find_git_root()
    return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction

" From github.com/JoshMcguigan
function! HideTerminal()
    " Hides the terminal if it is open
    " Hiding is preferred to closing the terminal so that
    " the terminal session persists
    if bufwinnr('bin/bash') > 0
        execute bufwinnr('bin/bash') . "hide"
    endif
endfunction

function! ToggleTerminal()
    if bufwinnr('bin/bash') > 0
        call HideTerminal()
    else
        if bufnr('bin/bash') > 0
            " if an existing terminal buffer exists, but was hidden,
            " it should be re-used
            execute "vert botright sbuffer " . bufnr('bin/bash')
        else
            " Set kill, so when Vim wants to exit or otherwise
            " kill the terminal window, it knows how. This resolves
            " E497 when trying to quit Vim while the terminal window
            " is still open.
            vert botright term ++kill=term
        endif
    endif
endfunction
"}}}

" From github.com/JoshMcguigan
function! ToggleQuickFix()
    if len(filter(getwininfo(), 'v:val.quickfix && !v:val.loclist')) > 0
        cclose
    else
        call OpenQuickFix()
    endif
endfunction

function! RefreshQuickFix()
    " Call open quickfix if it is already open
    " This is used to re-parse errorformat, which helps because
    " streaming results would otherwise be partially parsed.
    if len(filter(getwininfo(), 'v:val.quickfix && !v:val.loclist')) > 0
        call OpenQuickFix()
    endif
endfunction

function! OpenQuickFix()
    " Opens the quick fix window vertically split
    " while maintaining cursor position.
    " Store the original window number
    let l:winnr = winnr()

    " execute "vert botright copen"
    execute "copen"
    " Set quickfix width
    " execute &columns * 1/2 . "wincmd |"

    " If focus changed, jump to the last window
    if l:winnr !=# winnr()
        wincmd p
    endif
endfunction

command! BufKeepOnly silent! execute "%bd|e#|bd#"

" move vertically by visual line
nnoremap j gj
nnoremap k gk

" swap some similar commands for convenience
nnoremap ' `
nnoremap ` '
nnoremap 0 ^
nnoremap ^ 0
nnoremap Y y$

inoremap jk <esc>
let mapleader=","

" quickly edit vimrc
nmap <silent> <leader>fv :e ~/.vimrc<CR>

" quickfix
nmap <silent> <leader>qq :call ToggleQuickFix()<CR>
nmap <silent> <leader>qr :call RefreshQuickFix()<CR>

" turns S into a splitline , symmetrical to J
nnoremap S :keeppatterns substitute/\s*\%#\s*/\r/e <bar> normal! ==k$<CR>

" number pseudo-text object (integer and float)
" https://gist.github.com/romainl/c0a8b57a36aec71a986f1120e1931f20
function! VisualNumber()
	call search('\d\([^0-9\.]\|$\)', 'cW')
	normal v
	call search('\(^\|[^0-9\.]\d\)', 'becW')
endfunction
xnoremap id :<C-u>call VisualNumber()<CR>
onoremap id :<C-u>normal vid<CR>

" Apply macro over visual range using @
function! ExecuteMacroOverVisualRange()
    echo "@".getcmdline()
    execute ":'<,'>normal @".nr2char(getchar())
endfunction

xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>


autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" >>>>> General config autogroup 
" Automatically delete trailing DOS-returns and whitespace on file open and
" write, from https://github.com/Valloric/dotfiles/blob/master/vim/vimrc.vim "
" Automatically reload vimrc if it changes.
augroup config
    autocmd!
    " autocmd BufRead,BufWritePre,FileWritePre * silent! %s/[\r \t]\+$//
    au BufWritePost .vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
augroup END

augroup pythonfiles
    autocmd!
    " autocmd FileType python :compiler python
    autocmd BufRead,BufNewFile *.pyx set filetype=cython
augroup END

augroup shellfiles
    autocmd!
    autocmd FileType sh setlocal tabstop=2
    autocmd FileType sh setlocal shiftwidth=2
    autocmd FileType sh setlocal softtabstop=2
augroup END

" >>>>> vimL autogroup 
augroup vimlfiles
    autocmd!
    autocmd FileType vim setlocal noexpandtab
    autocmd FileType vim setlocal shiftwidth=4
    autocmd FileType vim setlocal softtabstop=4
augroup END

" >>>>> TeX autogroup 
augroup texfiles
    autocmd!
    autocmd FileType tex setlocal linebreak
    autocmd FileType tex setlocal breakindent
    " autocmd FileType tex setlocal foldmethod=indent
    autocmd FileType tex setlocal foldignore=
    autocmd FileType tex setlocal expandtab
    autocmd FileType tex setlocal shiftwidth=4
    autocmd FileType tex setlocal tabstop=4
    autocmd FileType tex setlocal softtabstop=4
augroup END
