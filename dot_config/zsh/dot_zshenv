# .zshenv - Zsh environment file, always loaded
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-${HOME}/.config}
export ZDOTDIR=${ZDOTDIR:-${XDG_CONFIG_HOME}/zsh}

# .zprofile
# For non-login, non-interactive shells

if [[ ( "$SHLVL" -eq 1 && ! -o LOGIN ) && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi
