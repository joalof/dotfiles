# Basics {{{
#
# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
#
# Disable CTRL-S and CTRL-Q
[[ $- =~ i ]] && stty -ixoff -ixon

# }}}

# Functions {{{
ex ()
# ex - archive extractor
# usage: ex <file>
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

silent ()
{
    "$@" &> /dev/null &
}

function has_sudo() {
# usage e.g. [[ `has_sudo` == *"true"* ]]
    local prompt
    prompt=$(sudo -nv 2>&1)
    if [ $? -eq 0 ]; then
        echo "true_pass"
    elif echo $prompt | grep -q '^sudo:'; then
        echo "true_nopass"
    else
        echo "false"
    fi
}


function stow_app ()
{
    local OPTIND opt flag 
    del_flag=""
    while getopts ":D" opt; do
        case "${opt}" in
            D) 
                del_flag="-${opt}"
                ;;
            *) 
                echo "Usage: stow_app [-D] package" 
                ;;
        esac
    done
    shift $((OPTIND-1))
    xstow -d $HOME/apps -t $HOME/.local $del_flag $1
}


o() {
    declare -A openers
    
    # Mapping of file extensions to programs
    openers=(
        [pdf]="zathura"
        [txt]="nvim"
        [jpg]="feh"
        [png]="feh"
        [mp4]="mpv"
        [mkv]="mpv"
        [mp3]="mpv"
        [wav]="mpv"
        [html]="firefox"
        [py]="nvim"
        [sh]="nvim"
        [c]="nvim"
        [cpp]="nvim"
        [h]="nvim"
        [hpp]="nvim"
        [java]="nvim"
        [js]="nvim"
        [ts]="nvim"
        [go]="nvim"
        [rs]="nvim"
        [lua]="nvim"
        [php]="nvim"
        [rb]="nvim"
        [swift]="nvim"
        [kt]="nvim"
        [json]="nvim"
        [jsonl]="nvim"
        [toml]="nvim"
        [yaml]="nvim"
        [yml]="nvim"
    )
    
    # Check if a file is provided
    if [[ -z "$1" ]]; then
        echo "Usage: o <file>"
        return 1
    fi
    
    # If the argument is a directory, open it in nvim with oil.nvim
    if [[ -d "$1" ]]; then
        nvim +Oil "$1"
        return 0
    fi
    
    # If the file is a dotfile, open in nvim
    if [[ "$(basename "$1")" =~ ^\. ]]; then
        nvim "$1"
        return 0
    fi
    
    # Check if the file is binary
    if grep -Iq . "$1"; then
        # Extract file extension
        ext="${1##*.}"
        
        # Check if there's a mapped program
        if [[ -n "${openers[$ext]}" ]]; then
            "${openers[$ext]}" "$1" &
        else
            echo "No program associated with .$ext files."
            return 1
        fi
    else
        echo "Error: '$1' appears to be a binary file."
        return 1
    fi
}

loadenv() {
    local env_file="${1:-.env}"
    if [[ ! -f "$env_file" ]]; then
        echo "Error: .env file not found at '$env_file'" >&2
        return 1
    fi
    export $(grep -vE '^(#|$)' "$env_file" | xargs)
    echo "Loaded environment variables from $env_file"
}


# }}}

 # Defaults {{{
export SHELL=/bin/bash
export PLATFORM=$(uname -s)
export EDITOR=nvim
export BROWSER=chrome
export XDG_CONFIG_HOME=$HOME/.config

export PATH=$HOME/.local/bin:$PATH
export LIBRARY_PATH=$HOME/.local/lib
export LD_LIBRARY_PATH=$HOME/.local/lib
export CPLUS_INCLUDE_PATH=$HOME/.local/include
# }}}

#  Apps {{{

# Python {{{
export PYTHONBREAKPOINT=ipdb.set_trace
export TF_CPP_MIN_LOG_LEVEL=3

# }}}

# Rust {{{
export PATH=$PATH:$HOME/apps/rust/cargo/bin
export CARGO_HOME=$HOME/apps/rust/cargo
export RUSTUP_HOME=$HOME/apps/rust/rustup

if [[ -f "$HOME/apps/rust/cargo/env" ]]; then
    . "$HOME/apps/rust/cargo/env"
fi

# }}}

# WSL {{{
is_wsl2=$(uname -r | grep -c microsoft)

if [[ $is_wsl2 -eq 1 ]] ; then
    export WDESK=/mnt/c/Users/lofgr/Desktop
    export WHOME=/mnt/c/Users/lofgr
fi
# }}}

# Mamba {{{
# export MAMBA_EXE="$HOME/.local/bin/micromamba";
# export MAMBA_ROOT_PREFIX="$HOME/apps/micromamba";
# __mamba_setup="$("$MAMBA_EXE" shell hook --shell bash --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__mamba_setup"
# else
#     alias micromamba="$MAMBA_EXE"  # Fallback on help from mamba activate
# fi
# unset __mamba_setup
#
# mamba_last_env_file="$HOME/.cache/mamba_last_env"
# if [[ -f $mamba_last_env_file ]]; then
#     read -r last_env < $mamba_last_env_file
#     micromamba activate $last_env
# fi
#
# # Define mamba command to activate/save env and run micromamba
# mamba () {
#   micromamba "$@"
#   if [[ $1 == "activate" || $1 == "deactivate" ]]; then
#       echo $CONDA_DEFAULT_ENV > ~/.cache/mamba_last_env
#   fi
# }

# ----
# }}}

# Node version manager {{{
export NVM_DIR="$HOME/apps/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# }}}

# FZF {{{
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!**/{.git,node_modules,__pycache__}/*" 2> /dev/null'
export FZF_DEFAULT_OPTS='--bind ctrl-j:accept'
# }}}

# Starship {{{
[[ -f $(command -v starship) ]] && eval "$(starship init bash)"

# if [ -f /etc/bash_completion.d/git-prompt ]; then
#   source /etc/bash_completion.d/git-prompt
# elif [ -f /usr/share/git-core/contrib/completion/git-prompt.sh ]; then
#   source /usr/share/git-core/contrib/completion/git-prompt.sh
# fi
#
# GIT_PS1_SHOWDIRTYSTATE=1
#
# PS1='\n'\
# '\[\e[1;36m\]\w\[\e[0;33m\]$(__git_ps1 " (%s)")\[\e[0m\]'\
# '\[\e[1;35m\]$(if [[ -n "$VIRTUAL_ENV" ]]; then echo " (venv:$(basename "$VIRTUAL_ENV"))"; fi)\[\e[0m\]\n'\
# '\[\e[1;32m\]❯ \[\e[0m\]'


# }}}

# Julia {{{
case ":$PATH:" in
    *"$HOME/.juliaup/bin:"*)
        ;;

    *)
        export PATH=$HOME/.juliaup/bin${PATH:+:${PATH}}
        ;;
esac

# }}}

# Docker {{{
if grep -q "microsoft" /proc/version > /dev/null 2>&1; then
    if service docker status 2>&1 | grep -q "is not running"; then
        wsl.exe --distribution "${WSL_DISTRO_NAME}" --user root \
            --exec /usr/sbin/service docker start > /dev/null 2>&1
    fi
fi
# }}}

# {{{ Pixi
# prepend_env PATH "$HOME/.pixi/bin"
# }}}

# Ezenv {{{
export VIRTUAL_ENV_DISABLE_PROMPT=1
[ -f ~/.local/bin/ezenv ] && source ~/.local/bin/ezenv &> /dev/null

last_venv_file="$HOME/.cache/last_venv"
if [[ -f $last_venv_file ]]; then
    read -r last_venv < $last_venv_file
    ezenv activate $last_venv
fi

# }}}

# Keychain {{{
[ -f ~/.keychain/$(hostname)-sh ] && source ~/.keychain/$(hostname)-sh
# }}}

# Zoxide {{{
[[ -f $(command -v zoxide) ]] && eval "$(zoxide init --cmd f bash)"
# }}}

# Wezterm {{{
[[ -f ~/.config/wezterm/shell_integration.sh && $is_wsl2 -eq 1 ]] && source ~/.config/wezterm/shell_integration.sh
# }}}

# Modal {{{
export MODAL_ENVIRONMENT='joakim-dev'
# }}}
# end apps }}}

# Aliases {{{

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias l='ls -alF'
alias la='ls -A'

if [[ -f $(command -v eza) ]] ; then
    alias ll='eza -alF'
    alias l='eza -alF'
    alias ls='eza'
else
    alias ll='ls -alF --color=auto'
    alias ls='ls --color=auto'
fi

# if we have nvim use it over vim
if [ -f $(command -v nvim) ] ; then
    alias vi='nvim'
    alias vim='/usr/bin/vi'
fi

# quality of life
alias rd='rm -r'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

# python
alias python='python3 -u'
alias py='python3 -u'
alias pyt='pytest --disable-warnings'
alias ipython='ipython3 --no-confirm-exit --no-banner'
alias ipy='ipython3 --no-confirm-exit --no-banner'
alias jpy='jupyter-lab'

# latex make
alias lmk='latexmk'
alias lmkpdf='latexmk -pdf'
alias lmkxet='latexmk -xelatex'
alias lmklua='latexmk -lualatex'

# other
alias feh="feh --zoom=50"
alias gemini-flash='gemini --model gemini-2.5-flash'

alias gsearch='function _search(){ google-chrome "https://www.google.com/search?q=$(printf "%s+" "$@" | sed "s/+$//")"; }; _search'

# }}}
#
# vim: set fdm=marker fmr={{{,}}} fdl=0 :
# vim: set filetype=bash:

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/apps/google-cloud-sdk/path.bash.inc" ]; then . "$HOME/apps/google-cloud-sdk/path.bash.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/apps/google-cloud-sdk/completion.bash.inc" ]; then . "$HOME/apps/google-cloud-sdk/completion.bash.inc"; fi
