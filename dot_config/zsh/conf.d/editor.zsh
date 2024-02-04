# Use vi keybindings
bindkey -e

# Enable partial history match
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# Enable using k and j in command mode to search history
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# Remove highlight
zle_highlight=("paste:none")
