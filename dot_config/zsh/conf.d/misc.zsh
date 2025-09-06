# Disable magical enter press
zle -A .accept-line accept-line

if [[ $(uname) == "Darwin" ]]; then
    # sdkman setup
    export SDKMAN_DIR="$XDG_DATA_HOME/sdkman"
    [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
fi

# zoxide setup
eval "$(zoxide init zsh)"

# fzf setup
FZF_ALT_C_COMMAND= FZF_CTRL_T_COMMAND= source <(fzf --zsh)
