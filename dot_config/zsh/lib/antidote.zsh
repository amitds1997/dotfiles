# Set value for Antidote plugins directory
: ${ANTIDOTE_HOME:=${XDG_CACHE_HOME:-~/.cache}/antidote}
ANTIDOTE_REPO=$ANTIDOTE_HOME/mattmc3/antidote

zstyle ':antidote:home' path $ANTIDOTE_HOME
zstyle ':antidote:repo' path $ANTIDOTE_REPO
zstyle ':antidote:bundle' use-friendly-names 'yes'
zstyle ':antidote:plugin:*' defer-options '-p'
zstyle ':antidote:*' zcompile 'yes'

# Install antidote if not already present
if [[ ! -d $ANTIDOTE_REPO ]]; then
  git clone https://github.com/mattmc3/antidote $ANTIDOTE_REPO
fi

source $ANTIDOTE_REPO/antidote.zsh
antidote load
