# Set PATH, MANPATH, etc., for Homebrew.
eval "$(/opt/homebrew/bin/brew shellenv)"

# SSH key management
eval "$(ssh-agent -s)"

export ZDOTDIR="$HOME/.config/zsh" # Relocate zsh dot files homedir
