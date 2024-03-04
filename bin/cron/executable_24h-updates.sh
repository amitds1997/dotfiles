#!/usr/bin/env bash

export PATH="/usr/local/bin:$PATH"
HOME="/Users/$(whoami)"
export HOME
HOMEBREW=$(which brew)
"$HOMEBREW" update && "$HOMEBREW" upgrade
"$HOMEBREW" bundle dump --no-upgrade --file=- | grep -v '"homebrew/cask"' >| "${HOME}"/.config/brew/Brewfile  # Not excluding this leads to errors
echo " Wrote current brew package info into the Brewfile"

# vim: ft=bash
