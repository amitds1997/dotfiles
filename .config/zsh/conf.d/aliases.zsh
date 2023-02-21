alias vi="nvim"
alias vim="nvim"
alias dirh="dirs -v"

alias bat="bat --theme OneHalfDark"
alias kitty_ssh="kitty +kitten ssh"
alias gst="git status"

# Exclude common non-necessary directories from being searched
GREP_EXCL=(.bzr CVS .git .hg .svn .idea .tox)
alias grep="${aliases[grep]:-grep} --exclude-dir={\${(j.,.)GREP_EXCL}}"

# Exit aliases
alias zz="exit"
alias quit="exit"

# URL decode/encode
alias urldecode='python3 -c "import sys, urllib.parse as ul; print(ul.unquote_plus(sys.argv[1]))"'
alias urlencode='python3 -c "import sys, urllib.parse as ul; print (ul.quote_plus(sys.argv[1]))"'

# [D]otfile [M]anager
alias dm="git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
