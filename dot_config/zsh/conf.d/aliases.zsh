# Aliases
alias dirh='dirs -v'

# Alias all vim commands to Neovim
alias vi="nvim"
alias vim="nvim"

# Git aliases
alias gst="git status"
alias gc="git commit"
alias ga="git add"
alias gp="git push"
alias gd="git diff"
alias gw="git worktree"

alias ldoc="lazydocker"

# eza setup
eza_params=('--git' '--icons' '--classify' '--group-directories-first' '--time-style=+%d-%m-%Y %H:%M' '--group')
alias eza='eza ${eza_params}'

# taskwarrior setup
alias tsui="taskwarrior-tui"

if [[ $(uname) == "Darwin" ]]; then
  # Extra brew aliases
  alias brew_dump="brew bundle dump --force --file=${XDG_CONFIG_HOME}/brew/Brewfile"
  alias brew_info="brew leaves | xargs brew desc --eval-all"

  brew_deps() {
    emulate -L zsh; setopt local_options
    local bluify_deps='
      BEGIN { blue = "\033[34m"; reset = "\033[0m" }
            { leaf = $1; $1 = ""; printf "%s%s%s%s\n", leaf, blue, $0, reset}
    '
    brew leaves | xargs brew deps --installed --for-each | awk "$bluify_deps"
  }
fi
