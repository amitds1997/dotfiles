# Reset bad plugin options
setopt NO_BEEP
setopt NO_HIST_BEEP

# Set antidote home, if not set
[[ -n "$ANTIDOTE_HOME" ]] || ANTIDOTE_HOME="$(antidote home)"

# Disable magical enter press
zle -A .accept-line accept-line

# Setup zoxide
eval "$(zoxide init zsh)"

# Pyenv setup
command -v pyenv &> /dev/null && eval "$(pyenv init -)"

if [[ $(uname) == "Darwin" ]]; then
    # Brew setup
    export HOMEBREW_NO_ENV_HINTS=true

    # Sdkman setup
    export SDKMAN_DIR="$XDG_DATA_HOME/sdkman"
    [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

    # Conda setup

    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    __conda_setup="$('/usr/local/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "/usr/local/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
            . "/usr/local/Caskroom/miniconda/base/etc/profile.d/conda.sh"
        else
            export PATH="/usr/local/Caskroom/miniconda/base/bin:$PATH"
        fi
    fi
    unset __conda_setup
    # <<< conda initialize <<<

    command -v fnm &> /dev/null && eval "$(fnm env --use-on-cd)"
elif [[ $(uname) == "Linux" ]]; then
    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    __conda_setup="$('/opt/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "/opt/miniconda3/etc/profile.d/conda.sh" ]; then
            . "/opt/miniconda3/etc/profile.d/conda.sh"
        else
            export PATH="/opt/miniconda3/bin:$PATH"
        fi
    fi
    unset __conda_setup
    # <<< conda initialize <<<
fi

