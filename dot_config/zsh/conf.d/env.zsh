# Correctly handle GPG related settings
export GPG_TTY=$TTY

# Make zsh-auto-suggestion suggest based on both history and completion
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Do not consider - and _ as part of a word
export WORDCHARS=${WORDCHARS//[-_]/}

# Set correct colors for history substring search
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND="fg=bold"
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND="fg=red,bold"
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_TIMEOUT=1

# Set ripgrep config path
export RIPGREP_CONFIG_PATH="${XDG_CONFIG_HOME}/ripgrep/config"

# Set FZF options
export FZF_DEFAULT_OPTS='--color=gutter:-1 --cycle --border
  --preview-window="sharp" --prompt="» " --marker="+" --pointer=""
   --layout="reverse" --border="sharp" --info="inline-right"'

if [[ $TERM == "xterm-kitty" ]]; then
  # Use kitty's "Truly Convenient SSH" if in the kitty terminal
  alias ssh="kitten ssh"
fi

if [[ $(uname) == "Darwin" ]]; then
    # Homebrew related setup
    export HOMEBREW_NO_ENV_HINTS=true
    export HOMEBREW_NO_ANALYTICS=1
    export HOMEBREW_AUTO_UPDATE_SECS=86400

    export COLIMA_HOME=$XDG_CONFIG_HOME/colima
    # Add any ZSH completions added by homebrew
    if [[ -d "$HOMEBREW_PREFIX/share/zsh/site-functions" ]]; then
      fpath+=("$HOMEBREW_PREFIX/share/zsh/site-functions")
    fi

    # Set up gems
    export GEM_HOME=$HOME/.gem
    export PATH="/opt/homebrew/opt/ruby/bin:$GEM_HOME/bin:$PATH"
fi
