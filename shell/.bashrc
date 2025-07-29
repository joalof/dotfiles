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
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac


# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

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

function has_wsl ()
{
    local wsl1=`grep -vc Microsoft /proc/version`
    local wsl2=`uname -r | grep -vc microsoft`
    [[ $wsl1 == 0 || $wsl2 == 0 ]] && res=true || res=false
    echo $res
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
    stow -d $HOME/apps -t $HOME/.local $del_flag $1
}

prepend_env() {
    local var_name="$1"
    local dir="$2"
    
    # Resolve symlink if applicable
    dir=$(realpath -m "$dir")

    local current_value="${!var_name:-}"

    # Remove existing occurrences of $dir
    local cleaned_value=$(echo ":$current_value:" | sed -E "s#:?$dir:?##g" | sed 's/^:*//;s/:*$//')

    # Prepend
    if [[ -z "$cleaned_value" ]]; then
        export "$var_name"="$dir"
    else
        export "$var_name"="$dir:$cleaned_value"
    fi
}

append_env() {
    local var_name="$1"
    local dir="$2"

    # Resolve symlink if applicable
    dir=$(realpath -m "$dir")

    local current_value="${!var_name:-}"

    # Remove existing occurrences of $dir
    local cleaned_value=$(echo ":$current_value:" | sed -E "s#:?$dir:?##g" | sed 's/^:*//;s/:*$//')

    # Append
    if [[ -z "$cleaned_value" ]]; then
        export "$var_name"="$dir"
    else
        export "$var_name"="$cleaned_value:$dir"
    fi
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




# }}}

 # Defaults {{{
export SHELL=/bin/bash
export PLATFORM=$(uname -s)
export EDITOR=nvim
export BROWSER=firefox
export XDG_CONFIG_HOME=$HOME/.config

prepend_env PATH ~/.local/bin
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
export CARGO_HOME=$HOME/apps/rust/cargo
export RUSTUP_HOME=$HOME/apps/rust/rustup

if [[ -f "$HOME/apps/rust/cargo/env" ]]; then
    . "$HOME/apps/rust/cargo/env"
fi

# }}}

# WSL {{{


if [[ `has_wsl` == true ]] ; then
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
    *:/home/autarch/.juliaup/bin:*)
        ;;

    *)
        export PATH=/home/autarch/.juliaup/bin${PATH:+:${PATH}}
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
[ -f ~/.local/bin/ezenv ] && source ~/.local/bin/ezenv

last_venv_file="$HOME/.cache/last_venv"
if [[ -f $last_venv_file ]]; then
    read -r last_venv < $last_venv_file
    ezenv activate $last_venv
fi

# }}}

# Keychain {{{
[ -f ~/.keychain/$(hostname)-sh ] && source ~/.keychain/$(hostname)-sh
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
alias ipy='ipython3'
alias jpy='jupyter-lab'
alias pipdev='pip install --no-deps -e'

# latex make
alias lmk='latexmk'
alias lmkpdf='latexmk -pdf'
alias lmkxet='latexmk -xelatex'
alias lmklua='latexmk -lualatex'

# other
alias feh="feh --zoom=50"

alias cmlup='docker-compose -f /opt/clearml/docker-compose.yml up -d'
alias cmldown='docker-compose -f /opt/clearml/docker-compose.yml down'

# }}}
#
# Zoxide {{{
[[ -f $(command -v zoxide) ]] && eval "$(zoxide init --cmd f bash)"
# }}}
# vim: set fdm=marker fmr={{{,}}} fdl=0 :
# vim: set filetype=bash:
