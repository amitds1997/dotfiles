# Correctly handle GPG related settings
export GPG_TTY=$TTY

# Make zsh-auto-suggestion suggest based on both history and completion
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Set correct colors for history substring search
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND="fg=bold"
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND="fg=red,bold"
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_TIMEOUT=1

# Set ripgrep config path
export RIPGREP_CONFIG_PATH="${XDG_CONFIG_HOME}/ripgrep/config"

# Correctly set FZF options
# TODO: Move to fzf config
# References: https://github.com/uzxmx/dotfiles/blob/fbb70045349afa46941667760c35581c473e65e7/zsh/configs.zsh#L132
export FZF_DEFAULT_OPTS='--color=bg+:-1 --cycle --border
  --preview-window="border-rounded" --prompt="󰬫 " --marker="+" --pointer="" --separator="┈"
   --layout="reverse" --info="inline-right"'

if [[ $TERM == "xterm-kitty" ]]; then
  # Use kitty's "Truly Convenient SSH" if in the kitty terminal
  alias ssh="kitten ssh"
fi

if [[ $(uname) == "Darwin" ]]; then
    # Homebrew related setup
    # export HOMEBREW_NO_ENV_HINTS=true
    export HOMEBREW_NO_ANALYTICS=1
    export HOMEBREW_AUTO_UPDATE_SECS=86400

    export COLIMA_HOME=$XDG_CONFIG_HOME/colima
    # Add any ZSH completions added by homebrew
    if [[ -d "$HOMEBREW_PREFIX/share/zsh/site-functions" ]]; then
      fpath+=("$HOMEBREW_PREFIX/share/zsh/site-functions")
    fi
fi
