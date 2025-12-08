function log() {
  if [[ $NO_MORE_LOGGING != true ]] || [[ $2 == true ]] ; then
    echo $1 | lolcat
  fi
}

log "Shell initializing ..."
# Enable vi mode
bindkey -v

## jk to esc  
bindkey -M viins 'jk' vi-cmd-mode

log "Enable VI mode ..."
# Shell PATH
export PATH=$HOME/.local/bin:$PATH   # Add usr utils path
export PATH="$HOME/.pyenv/bin:$PATH" # Add PyEnv path
export PATH="$HOME/.modular/bin:$PATH" # Add Modular (Mojo) path
export PATH="/opt/homebrew/opt/llvm/bin:$PATH" # Add LLVM path

log "Setup paths ..."

# Initialize PyEnv python version manager
eval "$(pyenv init -)"
log "Pyenv init ..."

# Initialize NVM
export NVM_DIR="$HOME/.local/share/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
log "NVM init ..."

# Load shell modules and helpers
autoload -U colors && colors

# Configure browse filesystem behaviors
setopt AUTO_PUSHD

# Setup prompt 
setopt prompt_subst
export PROMPT=$'\n'"%F{129}%f%K{129} %m %k%F{129}%K{135}%k%f%K{135}%B %~ %b%k%K{141}%F{135}%f %t %k%F{141}%f"$'\n🚀 '
export RPROMPT='${vcs_info_msg_0_}'
log "Setup prompt ..."

# Configure history
bindkey -v
# bindkey '^R' history-incremental-search-backward # Disable, use Atuin instead

export HISTSIZE=100000
export HISTFILESIZE=100000
export HISTFILE="$HOME/.cache/.zhistory"
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
export LESSHISTFILE="$HOME/.cache/.lesshst"
export SHELL_SESSIONS_DISABLE=1
log "Configure history ..."

# Git status shell integration
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' unstagedstr '%F{red}%f'
zstyle ':vcs_info:*' stagedstr '%F{green}%f' 
zstyle ':vcs_info:*' cleanstr '%F{blue}%f'
zstyle ':vcs_info:git*' formats "%F{203}%f%F{209}%b%f %F{215}%f %F{221}[%f %m%u%c %F{221}]%f%F{203}%f"
zstyle ':vcs_info:*' check-for-changes true

zstyle ':vcs_info:*+set-message:*' hooks home-path
function +vi-home-path() {
  if ! ((gitstaged || gitunstaged)) ; then
    zstyle -s ":vcs_info:${vcs}:${usercontext}:${rrn}" cleanstr tmp
    hook_com[staged]=$tmp
  fi
  # Break in case of debug
  #for key val in "${(@kv)hook_com}"; do
  #  echo "$key -> $val"
  #done
}

precmd() {
    vcs_info
}

source $HOME/.config/zsh/atuin.zsh
log "Atuin init ..."

source $HOME/.config/zsh/git.zsh
log "Setup git integration ..."

# Initialize Rust cargo
source /Users/izo/.local/share/cargo/env
log "Cargo(Rust) init ..."

# Setup completion
fpath=(/Users/izo/.docker/completions $fpath)
source $HOME/.config/zsh/completion.zsh
log "Setup shell completions ..."

# Load aliases
source $HOME/.config/zsh/.aliases
log "Setup shell command aliases ..."

# Load Plugins 
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh # Syntax highlighting
source $HOME/.config/zsh/google-cloud-sdk.zsh
log "Shell plugins loaded ...\n"

if [[ $NO_MORE_LOGGING != true ]] ; then
  # gucci rice :(
  neofetch
fi

export NO_MORE_LOGGING=true
