alias vi="nvim"
alias vim="nvim"

alias bat="bat --theme OneHalfDark"

# Git aliases
alias gst="git status"
alias gd="git diff"
alias gds="git diff --staged"
alias gr="git restore"
alias grs="git restore --staged"

# URL decode/encode
alias urldecode='python3 -c "import sys, urllib.parse as ul; print(ul.unquote_plus(sys.argv[1]))"'
alias urlencode='python3 -c "import sys, urllib.parse as ul; print (ul.quote_plus(sys.argv[1]))"'

