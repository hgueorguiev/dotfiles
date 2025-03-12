export ATUIN_NOBIND="true"
eval "$(atuin init zsh)"

bindkey '^r' atuin-search-viins
bindkey -M vicmd '^r' atuin-search-viins

# bind to the up key, which depends on terminal mode
bindkey -M vicmd 'j' atuin-up-search-vicmd
bindkey -M vicmd 'k' atuin-up-search-vicmd
