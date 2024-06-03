export EDITOR=nvim
export VISUAL=nvim

# Needed to run git commit correctly with GPG
export GPG_TTY=$TTY

# Set correct colors for history substring search
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND="bold"
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND="fg=red,bold"

# Set ripgrep config path
export RIPGREP_CONFIG_PATH="${XDG_CONFIG_HOME}/ripgrep/config"

# Correctly set FZF options
export FZF_DEFAULT_OPTS='--color=bg+:-1 --cycle --border
  --preview-window="border-rounded" --prompt="󰬫 " --marker="+" --pointer="" --separator="┈"
  --scrollbar="▋" --layout="reverse" --info="inline-right"'

# Correctly set up JAVA
if [[ $(uname) == "Darwin" ]]; then
  export JAVA_HOME=$(/usr/libexec/java_home -v 1.8.0_332)
  path=(
    /opt/homebrew/{,s}bin(N)
    /usr/local/opt/llvm/bin
    $path
  )
  export DOCKER_HOST="unix://${HOME}/.colima/default/docker.sock"

  # Replace cat
  alias cat="bat --theme=\$(defaults read -globalDomain AppleInterfaceStyle &> /dev/null && echo OneHalfDark || echo OneHalfLight)"
fi

if [[ $TERM == "xterm-kitty" ]]; then
  # Use 'Truly Convenient SSH' if working off kitty
  alias ssh="kitten ssh"
fi
