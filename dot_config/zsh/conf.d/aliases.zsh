alias zprofrc="ZPROFRC=1 zsh"

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

# We use `eza` instead of `ls`
alias ls="eza --icons"
alias lgit="lazygit"
alias ldoc="lazydocker"

if [[ $(uname) == "Darwin" ]]; then
  alias brew_dump="brew bundle dump --force --file=${XDG_CONFIG_HOME}/brew/Brewfile"
fi
