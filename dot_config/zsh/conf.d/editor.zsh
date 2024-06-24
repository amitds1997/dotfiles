# Use vi keybindings
bindkey -v

# Use ↑, Ctrl+P, k (in vim mode) to go up through possible substring matches
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M emacs '^P' history-substring-search-up

# Use ↓, Ctrl+N, j (in vim mode) to go down through possible substring matches
bindkey "$terminfo[kcud1]" history-substring-search-down
bindkey -M vicmd 'j' history-substring-search-down
bindkey -M emacs '^N' history-substring-search-down

# Remove highlight in pasted text
zle_highlight=("paste:none")
