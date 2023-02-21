export EDITOR=nvim
export VISUAL=code

# Needed to run git commit correctly with GPG
export GPG_TTY=$TTY

# Correctly set up JAVA
export JAVA_HOME=$(/usr/libexec/java_home -v 1.8.0_332)

# Set docker host location
export DOCKER_HOST=unix://${HOME}/.colima/docker.sock

path=(
  # core
  $HOME/{,s}bin(N)
  /opt/{homebrew,local}/{,s}bin(N)
  /usr/local/{,s}bin(N)

  # apps
  $HOMEBREW_PREFIX/opt/curl/bin(N)
  $HOMEBREW_PREFIX/opt/go/libexec/bin(N)
  $HOMEBREW_PREFIX/opt/ruby/bin(N)
  $HOMEBREW_PREFIX/lib/ruby/gems/*/bin(N)
  $HOME/.gem/ruby/*/bin(N)
  $HOMEBREW_PREFIX/share/npm/bin(N)

  $path
)
