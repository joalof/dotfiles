# Basics {{{
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

# }}}

 # Defaults {{{
export SHELL=/bin/bash
export PLATFORM=$(uname -s)
export EDITOR=nvim
export BROWSER=firefox
export XDG_CONFIG_HOME=$HOME/.config

export PATH=~/.local/bin:$PATH
export LIBRARY_PATH=$HOME/.local/lib
export LD_LIBRARY_PATH=$HOME/.local/lib
export CPLUS_INCLUDE_PATH=$HOME/.local/include
# }}}

#  Apps {{{

# Chromium {{{
export GOOGLE_API_KEY="no"
export GOOGLE_DEFAULT_CLIENT_ID="no"
export GOOGLE_DEFAULT_CLIENT_SECRET="no"
# }}}
#
# Python {{{
export PYTHONBREAKPOINT=ipdb.set_trace
# }}}

# Rust {{{
export CARGO_HOME=$HOME/apps/rust/cargo
export RUSTUP_HOME=$HOME/apps/rust/rustup

if [[ -f "$HOME/apps/rust/cargo/env" ]]; then
    . "$HOME/apps/rust/cargo/env"
fi

# }}}

# Vcpkg {{{
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
# export vasp_command=~/apps/vasp/bin/vasp_std
# export VASP_PP_PATH=~/apps/vasp/setups
# export ASE_VASP_VDW=$HOME/apps/vasp
# }}}

# WSL {{{


if [[ `has_wsl` == true ]] ; then
    export WDESK=/mnt/c/Users/lofgr/Desktop
    export WHOME=/mnt/c/Users/lofgr
fi
# }}}

# Mamba {{{
export MAMBA_EXE="$HOME/.local/bin/micromamba";
export MAMBA_ROOT_PREFIX="$HOME/apps/micromamba";
__mamba_setup="$("$MAMBA_EXE" shell hook --shell bash --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias micromamba="$MAMBA_EXE"  # Fallback on help from mamba activate
fi
unset __mamba_setup

mamba_last_env=~/.cache/mamba_last_env
if [[ -f $mamba_last_env ]]; then
    read -r env_name < $mamba_last_env
    micromamba activate $env_name
fi

# Define mamba command to activate/save env and run micromamba
mamba () {
  micromamba "$@"
  if [[ $1 == "activate" || $1 == "deactivate" ]]; then
      echo $CONDA_DEFAULT_ENV > ~/.cache/mamba_last_env
  fi
}

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

# Lua version manager {{{
[ -s ~/.luaver/luaver ] && . ~/.luaver/luaver
[ -s ~/.luaver/completions/luaver.bash ] && . ~/.luaver/completions/luaver.bash
# }}}

# Zoxide {{{
eval "$(zoxide init --cmd f bash)"
# }}}

# Starship {{{
[[ -f $HOME/.local/bin/starship ]] && eval "$(starship init bash)"
# }}}
#
# Mojo {{{
[[ -f /bin/modular ]] && MOJO_PATH=$(modular config mojo.path)
export MODULAR_HOME=$HOME/.modular
export PATH=$MOJO_PATH/bin:$PATH
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

# end apps }}}

# Aliases {{{

if [[ -f $(command -v eza) ]] ; then
    alias ll='eza -alF'
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
alias rd='rm -rf'
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
alias vdp="vd -f pandas"
alias act="mamba activate"
alias dea="mamba deactivate"
alias feh="feh --zoom=50"

# }}}
# vim: set fdm=marker fmr={{{,}}} fdl=0 :
# vim: set filetype=bash:
