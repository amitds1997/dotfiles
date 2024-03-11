export EDITOR=nvim
export VISUAL=nvim

# Needed to run git commit correctly with GPG
export GPG_TTY=$TTY

# Set correct colors for history substring search
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND="bold"
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND="fg=red,bold"

# Set ripgrep config path
export RIPGREP_CONFIG_PATH="${XDG_CONFIG_HOME}/ripgrep/config"

# Correctly set up JAVA
if [[ $(uname) == "Darwin" ]]; then
  export JAVA_HOME=$(/usr/libexec/java_home -v 1.8.0_332)
  path=(
    /opt/homebrew/{,s}bin(N)
    $path
  )
fi
