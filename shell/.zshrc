# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
# zinit light Aloxaf/fzf-tab

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
# zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
# zstyle ':completion:*' menu no
# zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
# zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Keybindings
bindkey -e

# App configurations {{{
# Python
export PYTHONBREAKPOINT="ipdb.set_trace"
export TF_CPP_MIN_LOG_LEVEL=3


# Rust
export CARGO_HOME=$HOME/apps/rust/cargo
export RUSTUP_HOME=$HOME/apps/rust/rustup

if [[ -f "$HOME/apps/rust/cargo/env" ]]; then
    . "$HOME/apps/rust/cargo/env"
fi

# WSL
# if [[ `has_wsl` == true ]] ; then
#     export WDESK=/mnt/c/Users/lofgr/Desktop
#     export WHOME=/mnt/c/Users/lofgr
# fi

# Node version manager
export NVM_DIR="$HOME/apps/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm


# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!**/{.git,node_modules,__pycache__}/*" 2> /dev/null'
export FZF_DEFAULT_OPTS='--bind ctrl-j:accept'

# Zoxide
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init --cmd f zsh)"
fi


[[ -f $(command -v starship) ]] && eval "$(starship init zsh)"


# Julia
case ":$PATH:" in
    *:/home/autarch/.juliaup/bin:*)
        ;;

    *)
        export PATH=/home/autarch/.juliaup/bin${PATH:+:${PATH}}
        ;;
esac

# Docker
if grep -q "microsoft" /proc/version > /dev/null 2>&1; then
    if service docker status 2>&1 | grep -q "is not running"; then
        wsl.exe --distribution "${WSL_DISTRO_NAME}" --user root \
            --exec /usr/sbin/service docker start > /dev/null 2>&1
    fi
fi

# Ezenv
# [ -f ~/.local/bin/ezenv ] && source ~/.local/bin/ezenv
# last_venv_file="$HOME/.cache/last_venv"
# if [[ -f $last_venv_file ]]; then
#     read -r last_venv < $last_venv_file
#     ezenv activate $last_venv
# fi

[ -f ~/.keychain/$(hostname)-sh ] && source ~/.keychain/$(hostname)-sh

# }}}

# Aliases {{{
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


# python
alias python='python3 -u'
alias py='python3 -u'
alias pyt='pytest --disable-warnings'
alias ipy='ipython3'
alias jpy='jupyter-lab'
alias pipdev='pip install --no-deps -e'
#
# latex make
alias lmk='latexmk'
alias lmkpdf='latexmk -pdf'
alias lmkxet='latexmk -xelatex'
alias lmklua='latexmk -lualatex'

# other
alias feh="feh --zoom=50"
# }}}
# vim: set fdm=marker fmr={{{,}}} fdl=0 :
