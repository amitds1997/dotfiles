# Correctly handle GPG related settings
export GPG_TTY=$TTY

# Set correct colors for history substring search
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND="fg=bold"
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND="fg=red,bold"
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_TIMEOUT=1

# Set ripgrep config path
export RIPGREP_CONFIG_PATH="${XDG_CONFIG_HOME}/ripgrep/config"

# Correctly set FZF options
export FZF_DEFAULT_OPTS='--color=bg+:-1 --cycle --border
  --preview-window="border-rounded" --prompt="󰬫 " --marker="+" --pointer="" --separator="┈"
  --scrollbar="▋" --layout="reverse" --info="inline-right"'

# Correctly set up JAVA
if [[ $(uname) == "Darwin" ]]; then
  # export JAVA_HOME=$(/usr/libexec/java_home -v 1.8.0_442) # Not needed since set by SDKMAN
  # export DOCKER_HOST="unix://${HOME}/.colima/default/docker.sock"
fi

if [[ $TERM == "xterm-kitty" ]]; then
  # Use kitty's "Truly Convenient SSH" if in the kitty terminal
  alias ssh="kitten ssh"
fi
