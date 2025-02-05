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
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/izo/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/izo/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/izo/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/izo/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

echo "Setup paths ..." | lolcat

# Initialize PyEnv python version manager
eval "$(pyenv init -)"
echo "Pyenv init ..." | lolcat

# Initialize NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

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
# Configure browse filesystem behaviors
# Basic auto/tab complete (source:LukeSmithxyz)
# autoload -U compinit
# zstyle ':completion:*' menu select
# zmodload zsh/complist
# compinit
# _comp_options+=(globdots)		# Include hidden files.
#
# ## Use vim keys in tab complete menu:
# bindkey -M menuselect '^h' vi-backward-char
# bindkey -M menuselect '^k' vi-up-line-or-history
# bindkey -M menuselect '^l' vi-forward-char
# bindkey -M menuselect '^j' vi-down-line-or-history
# bindkey -v '^?' backward-delete-char

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

# Load aliases
source $HOME/.config/zsh/.aliases
echo "Setup shell command aliases ..." | lolcat

# Load Plugins 
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh # Syntax highlighting
source /Users/hristogueorguiev/.local/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh
echo "Shell plugins loaded ...\n" | lolcat

# gucci rice :(
neofetch
