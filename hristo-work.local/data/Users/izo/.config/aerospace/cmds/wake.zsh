#!/bin/zsh
source /Users/izo/.config/aerospace/cmds/includes.zsh
cd /Users/izo/.local/share/Stay-Awake/ 
log "☕️ Awakeee ...." true
pyenv exec uv run src/awake.py
