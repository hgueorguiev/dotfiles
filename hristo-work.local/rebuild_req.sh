#!/bin/bash

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
./mackeysinstaller.sh
brew install zsh-syntax-highlighting
# brew install zsh-autocomplete - went to config `completion.zsh` added to .zshrc for now
brew install ripgrep
brew install fzf
brew install lsd
brew install bat
brew install yazi
brew install neovim
brew install kitty
brew install git-delta
