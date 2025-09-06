#!/usr/bin/env zsh

# See: https://github.com/jeffreytse/zsh-vi-mode/issues/185
# We want autopair to initialize post vi initializes so that ZLE widgets are set up correctly instead of getting overwritten
export AUTOPAIR_INIT_INHIBIT=1
zvm_after_init_commands=(autopair-init)
