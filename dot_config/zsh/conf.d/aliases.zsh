alias vi="nvim"
alias vim="nvim"

# URL decode/encode
alias urldecode='python3 -c "import sys, urllib.parse as ul; print(ul.unquote_plus(sys.argv[1]))"'
alias urlencode='python3 -c "import sys, urllib.parse as ul; print (ul.quote_plus(sys.argv[1]))"'

# Git aliases
alias gst='git status'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gw='git worktree'
