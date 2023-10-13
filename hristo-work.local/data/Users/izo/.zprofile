# Set PATH, MANPATH, etc., for Homebrew.
eval "$(/opt/homebrew/bin/brew shellenv)"

# SSH key management
eval "$(ssh-agent -s)"

# Config paths setup

export ZDOTDIR="$HOME/.config/zsh" # Relocate zsh dot files homedir
