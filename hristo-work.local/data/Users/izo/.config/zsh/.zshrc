echo "Shell initializing ..." | lolcat
# Enable vi mode
bindkey -v

## jk to esc  
bindkey -M viins 'jk' vi-cmd-mode

echo "Enable VI mode ..." | lolcat
# Shell PATH
export PATH=$HOME/.local/bin:$PATH   # Add usr utils path
export PATH="$HOME/.pyenv/bin:$PATH" # Add PyEnv path
export PATH="$HOME/.modular/bin:$PATH" # Add PyEnv path

echo "Setup paths ..." | lolcat

# Initialize PyEnv python version manager
eval "$(pyenv init -)"
echo "Pyenv init ..." | lolcat

# Initialize NVM
export NVM_DIR="$HOME/.local/share/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
echo "NVM init ..." | lolcat

# Load shell modules and helpers
autoload -U colors && colors

# Configure browse filesystem behaviors
setopt AUTO_PUSHD

# Setup prompt 
setopt prompt_subst
export PROMPT=$'\n'"%F{129}%f%K{129} %m %k%F{129}%K{135}%k%f%K{135}%B %~ %b%k%K{141}%F{135}%f %t %k%F{141}%f"$'\n🚀 '
export RPROMPT='${vcs_info_msg_0_}'
echo "Setup prompt ..." | lolcat

# Configure history
bindkey -v
bindkey '^R' history-incremental-search-backward

export HISTSIZE=100000
export HISTFILESIZE=100000
export HISTFILE="$HOME/.cache/.zhistory"
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
export LESSHISTFILE="$HOME/.cache/.lesshst"
export SHELL_SESSIONS_DISABLE=1
echo "Configure history ..." | lolcat

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
echo "Setup git integration ..." | lolcat

# Setup completion
source $HOME/.config/zsh/completion.zsh
echo "Setup shell completions ..." | lolcat

# Load aliases
source $HOME/.config/zsh/.aliases
echo "Setup shell command aliases ..." | lolcat

# Load Plugins 
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh # Syntax highlighting
echo "Shell plugins loaded ...\n" | lolcat

# gucci rice :(
neofetch
