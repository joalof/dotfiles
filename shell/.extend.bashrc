# Basics {{{
export SHELL=/bin/bash
export PLATFORM=$(uname -s)

# Disable CTRL-S and CTRL-Q
[[ $- =~ i ]] && stty -ixoff -ixon
# }}}

# Enviroment {{{

# append indempotently to PATH
path_append () {
  for d; do
    d=$({ cd -- "$d" && { pwd -P || pwd; } } 2>/dev/null)  # canonicalize symbolic links
    if [ -z "$d" ]; then continue; fi  # skip nonexistent directory
    case ":$PATH:" in
      *":$d:"*) :;;
      *) PATH=$PATH:$d;;
    esac
  done
}

export EDITOR=nvim
export BROWSER=chrome
export PATH=~/.local/bin:$PATH
path_append /usr/local/bin
path_append $HOME/go/bin

export LIBRARY_PATH=$HOME/.local/lib
export LD_LIBRARY_PATH=$HOME/.local/lib
export CPLUS_INCLUDE_PATH=$HOME/.local/include

export GOOGLE_API_KEY="no"
export GOOGLE_DEFAULT_CLIENT_ID="no"
export GOOGLE_DEFAULT_CLIENT_SECRET="no"

# Python {{{
export PYTHONBREAKPOINT=ipdb.set_trace
# }}}

# rust {{{
path_append ~/.cargo/bin
# }}}

# go {{{
# export GOPATH=~/.local/go
# path_append $HOME/.local/go/bin
# }}}

# vcpkg {{{
export CPLUS_INCLUDE_PATH=$CPLUS_INCLUDE_PATH:$HOME/apps/vcpkg/installed/x64-linux/include
export CPLUS_INCLUDE_PATH=$CPLUS_INCLUDE_PATH:$HOME/apps/vcpkg/installed/x64-linux-dynamic/include

export LIBRARY_PATH=$LIBRARY_PATH:$HOME/apps/vcpkg/installed/x64-linux/lib
export LIBRARY_PATH=$LIBRARY_PATH:$HOME/apps/vcpkg/installed/x64-linux-dynamic/lib

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/apps/vcpkg/installed/x64-linux-dynamic/lib
# }}}

# PGI compilers {{{
# export PGI=$HOME/apps/pgi
# export PATH=$PGI/linux86-64/18.4/bin:$PATH
# export MANPATH=$MANPATH:$PGI/linux86-64/18.4/man
# export LM_LICENSE_FILE=$LM_LICENSE_FILE:$HOME/apps/pgi/license.dat
# export LD_LIBRARY_PATH=$HOME/apps/pgi/linux86-64/18.4/lib
# export PATH=$PATH:$PGI/linux86-64/18.4/lib
# }}}

# ASE {{{
# export VASP_COMMAND=~/apps/vasp/bin/vasp_std
# export VASP_PP_PATH=~/apps/vasp/setups
# export ASE_VASP_VDW=$HOME/apps/vasp
# }}}

# }}}

# Aliases {{{
alias ll='ls -alF --color=auto'
alias l='ls -aF --color=auto'
alias ls='ls --color=auto'

# if we have nvim use it over vim
if [ -f $(command -v nvim) ] ; then
    alias vi='nvim'
fi

# quality of life
alias rd='rm -rf'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

# python
alias python='python3 -u'
alias r='python3 -u'
alias ir='ipython3'
alias jr='jupyter-lab'
alias pipdev='pip install --no-deps -e'

# latex make
alias lmk='latexmk'
alias lmkpdf='latexmk -pdf'
alias lmkxet='latexmk -xelatex'
alias lmklua='latexmk -lualatex'


# other
# alias se='setxkbmap -I"$HOME"/.config/xkb -rules evdev-local -layout se'
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

# Run python job with nohup
br ()
{
    nohup python3 "$1" "$2" &> nohup.out &
}

silent ()
{
    "$@" &> /dev/null &
}

function o () {
  xdg-open "$@">/dev/null 2>&1
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

# }}}

# WSL {{{
if [[ `has_wsl` == true ]] ; then
    export WDESK=/mnt/c/Users/lofgr/Desktop
    export WHOME=/mnt/c/Users/lofgr
fi
# }}}

# Mamba {{{
export MAMBA_EXE='/home/joalof/.local/bin/micromamba';
export MAMBA_ROOT_PREFIX='/home/joalof/apps/micromamba';
__mamba_setup="$("$MAMBA_EXE" shell hook --shell bash --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias micromamba="$MAMBA_EXE"  # Fallback on help from mamba activate
fi
unset __mamba_setup

# . "/home/joalof/apps/mambaforge/etc/profile.d/mamba.sh"
mamba_last_env=~/.cache/mamba_last_env
if [[ -f $mamba_last_env ]]; then
    read -r env_name < $mamba_last_env
    micromamba activate $env_name
fi

# eval "original_$(declare -f mamba)" 2> /dev/null
# if [ $? -ne 0 ]; then
#     original_mamba () {
#       command mamba "$@"
#     }
# fi
# Redefine conda command, part b: Add new functionality related to items (i) and (ii).
mamba () {
  # Run the regular conda
  micromamba "$@"
  if [[ $1 == "activate" || $1 == "deactivate" ]]; then
      echo $CONDA_DEFAULT_ENV > ~/.cache/mamba_last_env
  fi
}

# -----
# Activate conda envs in tmux splits/new windows
# (see https://stackoverflow.com/questions/58482113/keeping-the-old-conda-env-activated-upon-splitting-panes-in-tmux)
# Redefine conda command, part a: Keep copy of original conda command/function

# eval "original_$(declare -f conda)" 2> /dev/null
# if [ $? -ne 0 ]; then
#     original_conda () {
#       command conda "$@"
#     }
# fi
# # Redefine conda command, part b: Add new functionality related to items (i) and (ii).
# conda () {
#   # Run the regular conda
#   original_conda "$@"
#   local CONDA_RTN_CODE=$?
#
#   # Keep a copy of CONDA_DEFAULT_ENV to restore the environment if, e.g.,
#   # 'source ~/.bashrc' is run
#   CONDA_DEFAULT_ENV_COPY=$CONDA_DEFAULT_ENV
#
#   # Stop and return original_conda's return code if it fails
#   [ $CONDA_RTN_CODE -ne 0 ] && return $CONDA_RTN_CODE
#
#   # Do tmux-related stuff, but only if tmux is running and "$@" contains substring "activate"
#   if [[ -n "$TMUX" ]] && [[ "$@" =~ .*"activate".* ]]; then
#     # Create/update the *tmux* session env var "TMUX_SESSION_CONDA_ENVS"
#     local TMUX_SESSION_CONDA_ENVS=$(tmux showenv TMUX_SESSION_CONDA_ENVS 2>/dev/null)
#     if [[ $? -eq 0 ]]; then
#       # Get list of conda envs for all panes except the current one
#       local OLD_VALUES=$(echo $TMUX_SESSION_CONDA_ENVS | sed "s/TMUX_SESSION_CONDA_ENVS=//")
#       local CONDA_ENV_OTHER_PANES=$(echo $OLD_VALUES | sed "s/$TMUX_PANE:\w*[[:space:]]*//g")
#     fi
#     # Include current pane's conda env info
#     tmux setenv TMUX_SESSION_CONDA_ENVS "$TMUX_PANE:$CONDA_DEFAULT_ENV $CONDA_ENV_OTHER_PANES"
#   fi
# }
#
# if [[ -n "$TMUX_PARENT_PANE_ID" ]]; then
#     # Remember: "TMUX_SESSION_CONDA_ENVS", as per our redefined "conda" command, carries
#     # info about changes in the the conda environments in all the session's panes.
#     # TMUX_PARENT_PANE_ID makes it thus possible to query, from any child
#     # pane, its parent's conda environment at the time the child was created.
#     # This is exactly what will be done now.
#     TMUX_SESSION_CONDA_ENVS=$(tmux showenv TMUX_SESSION_CONDA_ENVS 2>/dev/null)
#     if [ $? -eq 0 ]; then
#         PATT="(?<=${TMUX_PARENT_PANE_ID}:).*?(?=([[:space:]]|$))"
#         PARENT_CONDA_ENV=$(echo $TMUX_SESSION_CONDA_ENVS | grep -oP "$PATT" | head -1)
#         echo "Activate conda env '$PARENT_CONDA_ENV' of parent tmux pane '$TMUX_PARENT_PANE_ID'"
#         conda activate $PARENT_CONDA_ENV
#     fi
#     # Clean up the pane's env (TMUX_SESSION_CONDA_ENVS remains in the tmux session env)
#     unset TMUX_SESSION_CONDA_ENVS PATT PARENT_CONDA_ENV
#     # Erase memory of parent tmux pane's ID so that the 'else' block below
#     # is run if we re-source bashrc
#     unset TMUX_PARENT_PANE_ID
# else
#     # Triger update of TMUX_SESSION_CONDA_ENVS and CONDA_DEFAULT_ENV_COPY
#     # when the pane has no parent (very first pane or a pane where bashrc was
#     # re-sourced after creation).
#     [[ -n "$CONDA_DEFAULT_ENV_COPY" ]] && echo "Activate previous conda env '$CONDA_DEFAULT_ENV_COPY'"
#     conda activate $CONDA_DEFAULT_ENV_COPY
# fi

# ----
# }}}

# other apps {{{
# smart cd
eval "$(zoxide init --cmd j bash)"
# for https://github.com/gsamokovarov/jump
# eval "$(jump shell)"
# alias jb='cd -'

# fzf and ripgrep
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!**/{.git,node_modules,__pycache__}/*" 2> /dev/null'
export FZF_DEFAULT_OPTS='--bind ctrl-j:accept'

# activate dircolors
# test -r "~/.dircolors" && eval $(dircolors ~/.dircolors)

# starship
eval "$(starship init bash)"
# }}}

# vim: set fdm=marker fmr={{{,}}} fdl=0 :
# vim: set filetype=bash:
