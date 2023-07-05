" vim-plug {{{
set nocompatible
call plug#begin('~/.vim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Plug 'nathanaelkane/vim-indent-guides'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'machakann/vim-sandwich'
Plug 'wellle/targets.vim'
Plug 'justinmk/vim-sneak'
Plug 'michaeljsmith/vim-indent-object'
Plug 'lervag/vimtex'
Plug 'janko/vim-test'
Plug 'ryvnf/readline.vim'
Plug 'sheerun/vim-polyglot'
Plug 'romainl/vim-cool'
Plug 'romainl/vim-qf'
Plug 'machakann/vim-highlightedyank'
Plug 'ghifarit53/tokyonight-vim'

" colorschemes
Plug 'altercation/vim-colors-solarized'

if empty($SSH_CLIENT)
    Plug 'junegunn/goyo.vim'
    Plug 'kkoomen/vim-doge', { 'do': { -> doge#install() } }
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
    " Plug 'jesseleite/vim-agriculture'
    Plug 'JoshMcguigan/estream', { 'do': 'bash install.sh v0.2.0' }
    Plug 'skywind3000/asyncrun.vim'
    Plug 'KabbAmine/zeavim.vim'
    Plug 'erietz/vim-terminator', { 'branch' : 'main' }
    " Plug 'honza/vim-snippets'
    " Plug 'ludovicchabant/vim-gutentags'
    " Plug 'Valloric/YouCompleteMe', { 'do': 'python3 install.py --clang-completer' }
    " Plug 'dense-analysis/ale'
    " Plug 'axvr/zepl.vim'
    " Plug 'SirVer/ultisnips'
endif

call plug#end()
" }}}

" Color schemes {{{

" solarized
" set background=light
" colorscheme solarized

if (has("termguicolors"))
  set termguicolors
endif

" vim hardcodes background color erase even if the terminfo file does
" not contain bce. This causes incorrect background rendering when
" using a color theme with a background color.
let &t_ut=''

let g:tokyonight_style = 'storm' " available: night, storm
let g:tokyonight_enable_italic = 1
colorscheme tokyonight
let g:airline_theme = "tokyonight"

" }}}

" Sensible configs {{{
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

"}}}

" Preferred configs {{{

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
" set lazyredraw
set showmatch " Highlight matching {[()]}
set display+=lastline
set clipboard=unnamedplus
set undofile
set undodir=~/.vim/undodir

" cursor
set cursorline " Highlight current line
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

" }}}

" Functions {{{

function! s:find_git_root()
    return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction

" >>>>> Terminal {{{
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

" >>>>> Quickfix {{{
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
"}}}
"}}}

" {{{ Commands 
command! BufKeepOnly silent! execute "%bd|e#|bd#"
"}}}

" General mappings {{{

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

" common minor edits from normal mode
nnoremap <c-j> o<Esc>
nnoremap <c-k> O<Esc>
nnoremap <c-h> hx<Esc>
nnoremap <c-l> i<space><Esc>l

" quitting
nnoremap <c-c> :q<CR>
inoremap <c-c> <Esc>:q<CR>
nnoremap Q :qa!<CR>

" quickfix
nmap <silent> <leader>qq :call ToggleQuickFix()<CR>
nmap <silent> <leader>qr :call RefreshQuickFix()<CR>

" turns S into a splitline , symmetrical to J
nnoremap S :keeppatterns substitute/\s*\%#\s*/\r/e <bar> normal! ==k$<CR>

" buffers
nmap <silent> <leader>bk :BufKeepOnly<CR>
nmap <silent> <leader>bo :only<CR>

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

"}}}

 " Plugin specific {{{

" >>>>> fzf & agriculture {{{
if has_key(g:plugs, "fzf")
" if has_key(g:plugs, "fzf") && has_key(g:plugs, "vim-agriculture")
    command! ProjectFiles execute 'Files' s:find_git_root()
    " nmap <leader>/ <Plug>RgRawSearch
    " vmap <leader>/ <Plug>RgRawVisualSelection
    " nmap <leader>* <Plug>RgRawWordUnderCursor
    nmap <leader>ff :ProjectFiles<CR>
    nmap <leader>fh :Files ~<CR>
    nmap <leader>fg :Rg<CR>
    " nmap <leader>fg <Plug>RgRawSearch ""<CR>
endif
"}}}

" >>>>> highlightedyank {{{
if has_key(g:plugs, "vim-highlightedyank")
    let g:highlightedyank_highlight_duration = 350
endif
"}}}

" >>>>> vim-sandwich {{{
if has_key(g:plugs, "vim-sandwich")
    runtime macros/sandwich/keymap/surround.vim
endif
"}}}

" >>>>> vim-sneak {{{
if has_key(g:plugs, "vim-sneak")
    nmap f <Plug>Sneak_f
    nmap F <Plug>Sneak_F
    nmap t <Plug>Sneak_t
    nmap T <Plug>Sneak_T
endif
"}}}

" >>>>> YouCompleteMe {{{
if has_key(g:plugs, "YouCompleteMe")
    let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
    let g:ycm_collect_identifiers_from_tags_files = 1
    let g:ycm_seed_identifiers_with_syntax = 1
    let g:ycm_complete_in_comments = 1
    let g:ycm_collect_identifiers_from_comments_and_strings = 1
    let g:ycm_autoclose_preview_window_after_completion=1
    let g:ycm_key_list_select_completion = ['<Down>', '<Tab>']
endif
"}}}

" >>>>> coc-nvim {{{
if has_key(g:plugs, "coc.nvim")
    set nowritebackup
    set updatetime=1500
    set shortmess+=c

    set tagfunc=CocTagFunc

    let g:coc_global_extensions = ['coc-pyright', 'coc-json', 'coc-vimtex']

    " fix rootdir problems for pyright
    autocmd FileType python let b:coc_root_patterns = ['.git', '.env', 'venv', '.venv', 'setup.cfg', 'setup.py', 'pyproject.toml', 'pyrightconfig.json']

    if has("nvim-0.5.0") || has("patch-8.1.1564")
	" Recently vim can merge signcolumn and number column into one
      set signcolumn=number
    else
	set signcolumn=yes
    endif

    inoremap <silent><expr> <TAB>
	\ coc#pum#visible() ? coc#pum#next(1):
	\ CheckBackspace() ? "\<Tab>" :
	\ coc#refresh()

    function! CheckBackspace() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~# '\s'
    endfunction

    " Mappings
    nmap <silent> gr <Plug>(coc-references)
    nmap <silent> gd <Plug>(coc-definition)
    " nmap <silent> gi <Plug>(coc-implementation)
    " nmap <silent> gy <Plug>(coc-type-definition)

    " Text objects
    xmap if <Plug>(coc-funcobj-i)
    omap if <Plug>(coc-funcobj-i)
    xmap af <Plug>(coc-funcobj-a)
    omap af <Plug>(coc-funcobj-a)
    xmap ic <Plug>(coc-classobj-i)
    omap ic <Plug>(coc-classobj-i)
    xmap ac <Plug>(coc-classobj-a)
    omap ac <Plug>(coc-classobj-a)

    " Highlight the symbol and its references when holding the cursor.
    " autocmd CursorHold * silent call CocActionAsync('highlight')

    " Show documentation/docstrings with K
    " nnoremap <silent> K :call <SID>show_documentation()<CR>

    function! s:show_documentation()
	if (index(['vim','help'], &filetype) >= 0)
	    execute 'h '.expand('<cword>')
	elseif (coc#rpc#ready())
	    call CocActionAsync('doHover')
	else
	    execute '!' . &keywordprg . " " . expand('<cword>')
	endif
    endfunction

    " How to make this work without showing errormsgs?
    " Show docstrings on cursorhold
    function! ShowDocIfNoDiagnostic(timer_id)
        if (coc#float#has_float() == 0 && CocHasProvider('hover') == 1)
            silent call CocActionAsync('doHover')
        endif
    endfunction

    function! s:show_hover_doc()
        call timer_start(500, 'ShowDocIfNoDiagnostic')
    endfunction

    autocmd CursorHoldI * :call <SID>show_hover_doc()
    autocmd CursorHold * :call <SID>show_hover_doc()

endif
"}}}

" >>>>> vim-doge {{{
if has_key(g:plugs, "vim-doge")
    let g:doge_doc_standard_python = 'numpy'
    let g:doge_enable_mappings = 0

    " Manually set the mappings as I cannot set them via the global variables
    " for some unknown reason
    nmap <silent> <leader>dg <Plug>(doge-generate)
    nmap <silent> <leader>dg <Plug>(doge-generate)
    nmap <silent> <leader>dn <Plug>(doge-comment-jump-forward)
    imap <silent> <leader>dn <Plug>(doge-comment-jump-forward)
    smap <silent> <leader>dn <Plug>(doge-comment-jump-forward)
    nmap <silent> <leader>dp <Plug>(doge-comment-jump-backward)
    imap <silent> <leader>dp <Plug>(doge-comment-jump-backward)
    smap <silent> <leader>dp <Plug>(doge-comment-jump-backward)
endif
"}}}

" >>>>> ALE {{{
if has_key(g:plugs, "ale")
    let g:airline#extensions#ale#enabled = 1
    " let g:ale_lint_on_text_changed = 1
    let g:ale_lint_on_text_changed = 'never'
    let g:ale_lint_on_insert_leave = 0
    let g:ale_fixers = {
		\'python': ['isort', 'black'],
		\'*': ['trim_whitespace', 'remove_trailing_lines'],
		\}
    let g:ale_linters = {
		\'python': ['pylint'],
		\'yaml': ['yamllint'],
		\'tex': ['chktex', 'proselint'],
		\}
endif
"}}}

" >>>>> vim-tmux-navigator {{{
if has_key(g:plugs, "vim-tmux-navigator")
    let g:tmux_navigator_no_mappings = 1
    nnoremap <silent> <c-s>o <c-w>o
    nnoremap <silent> <c-s>h :TmuxNavigateLeft<cr>
    nnoremap <silent> <c-s>j :TmuxNavigateDown<cr>
    nnoremap <silent> <c-s>k :TmuxNavigateUp<cr>
    nnoremap <silent> <c-s>l :TmuxNavigateRight<cr>

    tnoremap <silent> <c-s>o <c-w>o
    tnoremap <silent> <c-s>h <c-w>:TmuxNavigateLeft<cr>
    tnoremap <silent> <c-s>j <c-w>:TmuxNavigateDown<cr>
    tnoremap <silent> <c-s>k <c-w>:TmuxNavigateUp<cr>
    tnoremap <silent> <c-s>l <c-w>:TmuxNavigateRight<cr>
endif
"}}}

" >>>>> vim-airline {{{
if has_key(g:plugs, "vim-airline")
    let g:airline_powerline_fonts=1
    set laststatus=2
    set noshowmode
endif
"}}}

" >>>>> vim-gutentags {{{
if has_key(g:plugs, "vim-gutentags")
    let g:gutentags_ctags_extra_args = ['--fields=+aimS']
endif
"}}}

" >>>>> vim-indent-guides {{{
if has_key(g:plugs, "vim-indent-guides")
    let g:indent_guides_enable_on_vim_startup = 1
    let g:indent_guides_guide_size=1
    let g:indent_guides_start_level=2
    if exists("g:colors_name") && g:colors_name == 'solarized'
        let g:indent_gudes_auto_colors = 0
	autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd ctermbg=lightgrey
	autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=lightgrey
    endif
    " for solarized dark
    " autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd ctermbg=black
    " autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=black
endif
"}}}

" >>>>> estream {{{
if has_key(g:plugs, "estream")
    let $PYTHONUNBUFFERED=1
    " Set global error format to match estream output
    set errorformat=%f\|%l\|%c,%f\|%l\|,%f\|\|
    " Use global error format with asyncrun
    let g:asyncrun_local = 0
    " Pipe any async command through estream to format it as expected
    command! -nargs=1 Async execute "AsyncRun <args> |& $VIM_HOME/plugged/estream/bin/estream"
endif
"}}}

" >>>>> ultisnips {{{
" if has_key(g:plugs, "ultisnips")
    " Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
    " let g:UltiSnipsExpandTrigger = "<Nul>"
    " let g:UltiSnipsJumpForwardTrigger="<Nul>"
    " let g:UltiSnipsJumpBackwardTrigger="<Nul>"
    " If you want :UltiSnipsEdit to split your window.
    " let g:UltiSnipsEditSplit="vertical"
    " inoremap <silent> <leader>ss <C-R>=UltiSnips#ExpandSnippet()<cr>
    " snoremap <silent> <leader>ss <Esc>:call UltiSnips#ExpandSnippet()<cr>
    " inoremap <silent> <leader>sn <C-R>=UltiSnips#JumpForwards()<cr>
    " snoremap <silent> <leader>sn <Esc>:call UltiSnips#JumpForwards()<cr>
    " inoremap <silent> <leader>sp <C-R>=UltiSnips#JumpBackwards()<cr>
    " snoremap <silent> <leader>sp <Esc>:call UltiSnips#JumpBackwards()<cr>
" endif
"}}}

" >>>>> vim-test {{{
if has_key(g:plugs, "vim-test")
    nmap <silent> <leader>tn :TestNearest <bar> call OpenQuickFix()<CR>
    nmap <silent> <leader>tf :TestFile <bar> call OpenQuickFix()<CR>
    nmap <silent> <leader>ts :TestSuite <bar> call OpenQuickFix()<CR>
    nmap <silent> <leader>tl :TestLast <bar> call OpenQuickFix()<CR>
    nmap <silent> <leader>tv :TestVisit <bar> call OpenQuickFix()<CR>

    " add custom strategy for estream if we have it
    if has_key(g:plugs, "estream")
	function! EstreamStrategy(cmd)
	    execute 'Async '.a:cmd
	endfunction
	let g:test#custom_strategies = {'estream': function('EstreamStrategy')}
	let g:test#strategy = 'estream'
    else
	let g:test#strategy = "vimterminal"

    endif
endif
"}}}

" >>>>> vimtex {{{
if has_key(g:plugs, "vimtex")
    let g:vimtex_enabled = 1
    let g:vimtex_mappings_enabled = 1
    " let vimtex  replace some targets.vim text objects such as $
    let g:vimtex_text_obj_variant = "vimtex"
    " let g:vimtex_view_method = "zathura"
    let g:vimtex_compiler_latexmk = {
                \ 'continuous': 0,
                \}
    if has_key(g:plugs, "YouCompleteMe")
        if !exists('g:ycm_semantic_triggers')
            let g:ycm_semantic_triggers = {}
        endif
        au VimEnter * let g:ycm_semantic_triggers.tex=g:vimtex#re#youcompleteme
    endif
endif
"}}}

" >>>>> zeavim {{{
if has_key(g:plugs, "zeavim.vim")
    nmap <leader>zz <Plug>Zeavim
    vmap <leader>zv <Plug>ZVVisSelection
    nmap <leader>gz <Plug>ZVOperator
    nmap <leader>zs <Plug>ZVKeyDocset
    let g:zv_file_types = {
            \   'python': 'python3,numpy,scipy,matplotlib,pandas',
            \ }
endif
" }}}

" >>>>> zepl.vim {{{
" if has_key(g:plugs, "zepl.vim")
"     let g:zepl_default_maps = 1
"     nnoremap <leader>ri :vert Repl<CR> <c-w>h
    " nmap <silent> _ <Plug>ReplSendRegion
    " vmap <silent> _ <Plug>ReplSendVisual
    " augroup zepl
	" autocmd!
	" autocmd FileType javascript let b:repl_config = { 'cmd': 'node' }
	" autocmd FileType julia      let b:repl_config = { 'cmd': 'julia' }
    " augroup END
    " runtime zepl/contrib/python.vim  " Enable the Python contrib module.
    " autocmd! FileType python let b:repl_config = {
    "             \   'cmd': 'ipython',
    "             \   'formatter': function('zepl#contrib#python#formatter')
    "             \ }
" endif
" }}}

" >>>>> vim-terminator {{{
if has_key(g:plugs, "vim-terminator")
    let g:terminator_clear_default_mappings = "foo bar"
    let g:terminator_repl_delimiter_regex = '%%'
    let g:terminator_runfile_map = {
        \ "javascript": "node",
        \ "python": "python -u",
	\ "julia": "julia",
        \ "c": "gcc $dir$fileName -o $dir$fileNameWithoutExt && $dir$fileNameWithoutExt",
        \ "fortran": "cd $dir && gfortran $fileName -o $fileNameWithoutExt && $dir$fileNameWithoutExt"
        \ }
    let g:terminator_repl_command = {
	\'python' : 'ipython --no-autoindent',
	\'javascript': 'node',
        \'julia': 'julia',
        \}

    let g:terminator_split_fraction = 0.3
    " let g:terminator_auto_shrink_output = 1
    nnoremap <silent> <leader>rot :TerminatorOpenTerminal<CR>
    nnoremap <silent> <leader>roi :TerminatorStartREPL<CR>
    nnoremap <silent> <leader>ri :w \| TerminatorRunFileInTerminal<CR>
    nnoremap <silent> <leader>rr :w \| TerminatorRunFileInOutputBuffer<CR>
    nnoremap <silent> <leader>rx :TerminatorStopRun<CR>
    nnoremap <silent> <leader>rc :w \| call terminator#send_delimiter_to_terminal()<CR>
    " vnoremap <silent> <leader>rs :w \| <C-U> call terminator#send_to_terminal(terminator#get_visual_selection())<CR>
    " vnoremap <silent> <leader>rp :w \| <C-U> call terminator#run_part_of_file("output_buffer", terminator#get_visual_selection())<CR>
    " vnoremap <silent> <leader>rv :<C-U> call terminator#run_part_of_file("terminal", terminator#get_visual_selection())<CR>
    
    " Experimental auto close output buffer if it is the only remaining window
    function CloseRemainingOutput()
	if winnr('$') == 1 && bufname() == 'OUTPUT_BUFFER'
	    quit
	endif
    endfunction
    au WinEnter * call CloseRemainingOutput()

endif
" }}}

" >>>>> vim-log-print {{{
" if has_key(g:plugs, "vim-log-print")
"     let g:log_print#default_mappings = 1
    " let g:log_print#languages = #{
    "             \ python: #{pre:'print(f"{', post:' = }")'}
    "         \ }
" endif
" }}}

" >>>>> vim-qf {{{
" if has_key(g:plugs, "vim-terminator")
    " nmap [q <Plug>(qf_qf_previous)
    " nmap ]q  <Plug>(qf_qf_next)
" endif
" }}}
" }}}

" Filetype specific {{{

autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" >>>>> General config autogroup {{{
" Automatically delete trailing DOS-returns and whitespace on file open and
" write, from https://github.com/Valloric/dotfiles/blob/master/vim/vimrc.vim "
" Automatically reload vimrc if it changes.
augroup config
    autocmd!
    " autocmd BufRead,BufWritePre,FileWritePre * silent! %s/[\r \t]\+$//
    au BufWritePost .vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
augroup END
"}}}

" >>>>> Python autogroup {{{
augroup pythonfiles
    autocmd!
    autocmd FileType python :compiler python
    autocmd BufRead,BufNewFile *.pyx set filetype=cython
augroup END
"}}}

" >>>>> Shell autogroup {{{
augroup shellfiles
    autocmd!
    autocmd FileType sh setlocal tabstop=2
    autocmd FileType sh setlocal shiftwidth=2
    autocmd FileType sh setlocal softtabstop=2
augroup END
"}}}

" >>>>> vimL autogroup {{{
augroup vimlfiles
    autocmd!
    autocmd FileType vim setlocal noexpandtab
    autocmd FileType vim setlocal shiftwidth=4
    autocmd FileType vim setlocal softtabstop=4
augroup END
"}}}

" >>>>> TeX autogroup {{{
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
"}}}

" }}}
" vim: set fdm=marker fmr={{{,}}} fdl=0 :
