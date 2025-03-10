# Disable magical enter press
zle -A .accept-line accept-line

handle_conda_setup ()
{
    conda_base_path=$1
    __conda_setup="$($conda_base_path'/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "$conda_base_path/etc/profile.d/conda.sh" ]; then
            . "$conda_base_path/etc/profile.d/conda.sh"
        else
            export PATH="$conda_base_path/bin:$PATH"
        fi
    fi
    unset __conda_setup
}

handle_mamba_setup ()
{
    export mamba_install_dir=$1
    export MAMBA_EXE=$mamba_install_dir'/bin/micromamba';
    export MAMBA_ROOT_PREFIX=$HOME'/micromamba';
    __mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__mamba_setup"
    else
        alias micromamba="$MAMBA_EXE"  # Fallback on help from mamba activate
    fi
    unset __mamba_setup
}

if [[ $(uname) == "Darwin" ]]; then
    # Homebrew related setup
    export HOMEBREW_NO_ENV_HINTS=true
    path=(
        /opt/homebrew/{,s}bin(N)
        /usr/local/opt/llvm/bin
        /opt/homebrew/opt/postgresql@17/bin
        $path
    )
    typeset -gU path

    # sdkman setup
    export SDKMAN_DIR="$XDG_DATA_HOME/sdkman"
    [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

    handle_mamba_setup "/opt/homebrew/opt/micromamba"
    alias conda=micromamba

    # Handle architecture related docker issues
    # export DOCKER_DEFAULT_PLATFORM=linux/amd64
    export COLIMA_HOME=$XDG_CONFIG_HOME/colima

elif [[ $(uname) == "Linux" ]]; then
    handle_conda_setup "/opt/miniconda3"
fi

# pyenv setup
command -v pyenv &> /dev/null && eval "$(pyenv init -)"

# zoxide setup
eval "$(zoxide init zsh)"

