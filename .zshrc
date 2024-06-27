test -n "$PROF" && zmodload zsh/zprof

if [ -e $HOME/.oh-my-zsh ]; then
  export ZSH_DISABLE_COMPFIX=true
  export ZSH=$HOME/.oh-my-zsh

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
else
  autoload -Uz promptinit
  promptinit
  prompt walters
fi

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

# List of directories in which conda might be
CONDA_DIRS=(
  /opt/homebrew/Caskroom/mambaforge
  $HOME/miniforge3/etc/profile.d/conda.sh
)

for dir in $CONDA_DIRS; do
  if [ -e $dir ]; then
    export CONDA_DIR=$dir
    break
  fi
done

if [ -e $CONDA_DIR ]; then
  if [ -f "$CONDA_DIR/base/etc/profile.d/conda.sh" ]; then
    . "$CONDA_DIR/base/etc/profile.d/conda.sh"
    . "$CONDA_DIR/base/etc/profile.d/mamba.sh"
  else
    export PATH="$CONDA_DIR/base/bin:$PATH"
  fi
fi

# Lazy NVM initialization
export NVM_DIR="$HOME/.nvm"
if [ -e $NVM_DIR ]; then
  [ -s "$NVM_DIR/zsh_completion" ] && \. "$NVM_DIR/zsh_completion"  # This loads nvm zsh_completion
  # This script should be sourced from .zprofile to take advantage of the $ZSH_EXECUTION_STRING check
  export NVM_SYMLINK_CURRENT=true
  export NODE_VERSION_DIR=$(readlink ~/.nvm/current) # Assumes ~/.nvm/current is linked
  __NODE_GLOBALS=("${(@f)$(find "$NODE_VERSION_DIR"/bin -maxdepth 1 -mindepth 1 -type l -print0 | xargs --null -n1 basename | sort --unique)}")
  __NODE_GLOBALS+=(node nvm)

  found=false
  for value in "${__NODE_GLOBALS[@]}"; do
    # if zsh is trying to execute a command that matches one of the node globals in the current version
    if [[ $ZSH_EXECUTION_STRING == *"$value"* ]]; then
      # Forget about lazy loading and just add the current nvm node version to the PATH
      PATH=~/.nvm/current/bin:$PATH
      found=true
      break
    fi
  done

  # instead of using --no-use flag, load nvm lazily:
  if ! $found; then
    _load_nvm() {
      [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    }

    for cmd in "${__NODE_GLOBALS[@]}"; do
      eval "function ${cmd}(){ unset -f ${__NODE_GLOBALS[*]}; _load_nvm; unset -f _load_nvm; ${cmd} \"\$@\"; }"
    done
  fi
  unset cmd value found __NODE_GLOBALS
fi

# When tmux is called with no arguments, run the choose-tree by default
tmux() {
  if [ "$#" -eq 0 ]; then
    (command tmux attach\; choose-tree) || command tmux
  else
    command tmux "$@"
  fi
}

test -n "$PROF" && zprof || true

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/kstachowicz/google-cloud-sdk/path.zsh.inc' ]; then . '/home/kstachowicz/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/kstachowicz/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/kstachowicz/google-cloud-sdk/completion.zsh.inc'; fi

eval "$(direnv hook zsh)"
eval "$(starship init zsh)"
