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

# FZF: Define default commands with fallback logic
if command -v fd > /dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --strip-cwd-prefix --hidden --follow --exclude .git'
elif command -v rg > /dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='rg --files --null | xargs -0 dirname | sort -u' # rg isn't great for dirs
fi

# FZF: Preview command (bat > cat)
_fzf_preview_cmd='cat {}'
if command -v bat > /dev/null; then
  _fzf_preview_cmd='bat --style=numbers --color=always --line-range :500 {}'
fi
_fzf_dir_preview_cmd='ls -A --color=always {}'
if command -v eza > /dev/null; then
  _fzf_dir_preview_cmd='eza --tree --level=2 --color=always --icons --group-directories-first {}'
fi

# Set FZF options
export FZF_DEFAULT_OPTS="--cycle --layout=reverse --height=80% --border=rounded
  --prompt='» ' --pointer='▶' --marker='✓'
  --no-scrollbar --info=inline-right
  --color=bg+:-1,gutter:235,border:237,fg+:bold,hl:4,hl+:4:bold,pointer:4,info:244,prompt:4,spinner:4
  --preview '${_fzf_preview_cmd}'
  --preview-window 'right:60%:wrap'
  --bind 'ctrl-/:toggle-preview'"

export FZF_CTRL_T_OPTS="--preview '${_fzf_preview_cmd}'"
export FZF_ALT_C_OPTS="--preview '${_fzf_dir_preview_cmd}'"

# Clean up temporary vars
unset _fzf_preview_cmd _fzf_dir_preview_cmd

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
    # Note: Homebrew completions are automatically added to FPATH by 'brew shellenv'

    # Set up gems
    export GEM_HOME=$HOME/.gem
    export PATH="/opt/homebrew/opt/ruby/bin:$GEM_HOME/bin:$PATH"
fi
