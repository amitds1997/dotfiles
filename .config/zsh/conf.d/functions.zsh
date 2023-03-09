# [D]otfile [M]anager
function dm {
  git --git-dir=${HOME}/.dotfiles/ --work-tree=${HOME} $@
}
