test -n "$PROF" && zmodload zsh/zprof

export ZSH_DISABLE_COMPFIX=true
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="agnoster"

ENABLE_CORRECTION="true"

plugins=(
  git
  virtualenv
  zsh_codex
  zsh-syntax-highlighting
  zsh-autosuggestions
  z
  conda-zsh-completion
)
DISABLE_AUTO_UPDATE=true
source $ZSH/oh-my-zsh.sh

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#808080"

setopt no_histverify
zstyle ':completion:*' completer _expand _complete _files \
		_correct _approximate

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
autoload -Uz run-help
alias help=run-help
CORRECT_IGNORE_FILE='.*'

zle -N create_completion
bindkey '^X' create_completion

if [ -f '$HOME/google-cloud-sdk/path.zsh.inc' ]; then . '$HOME/google-cloud-sdk/path.zsh.inc'; fi

if [ -f '$HOME/google-cloud-sdk/completion.zsh.inc' ]; then . '$HOME/google-cloud-sdk/completion.zsh.inc'; fi

export TERM=xterm-256color

test -n "$PROF" && zprof || true

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/kstachowicz/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/kstachowicz/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/home/kstachowicz/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/home/kstachowicz/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup

if [ -f "/home/kstachowicz/miniforge3/etc/profile.d/mamba.sh" ]; then
    . "/home/kstachowicz/miniforge3/etc/profile.d/mamba.sh"
fi
# <<< conda initialize <<<

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/zsh_completion" ] && \. "$NVM_DIR/zsh_completion"  # This loads nvm zsh_completion
