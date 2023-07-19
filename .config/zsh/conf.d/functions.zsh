# [D]otfile [M]anager
function dm {
  git --git-dir=${HOME}/.dotfiles/ --work-tree=${HOME} $@
}

# FZF wrapper over git to interactively switch git worktrees
wt() {
  git rev-parse 2> /dev/null
  if [[ $? -eq 0 ]]; then
    worktree=$(git worktree list | grep -v bare | awk '{print $1,$3}' | fzf --prompt "Switch worktree: " --height 40% --reverse | awk '{print $1}') 
    cd $worktree || return
  else
    echo "fatal: not in a git repository"
  fi
}
