#!/usr/bin/env zsh

# General options
typeset -ga zopts_general=(
  COMBINING_CHARS           # Combine 0-len chars with base chars (e.g. accents)
  INTERACTIVE_COMMENTS      # Enable comments in interactive shell
  RC_QUOTES                 # Allow 'Hitchhiker''s Guide' instead of 'Hitchhiker'\''s Guide'
  NO_MAIL_WARNING           # Don't print a warning if a mail file was accessed
  NO_BEEP                   # No beeping from shell please
)

# Job options
typeset -ga zopts_job=(
  LONG_LIST_JOBS            # List jobs in the long format by default.
  AUTO_RESUME               # Attempt to resume existing job before creating a new process.
  NOTIFY                    # Report status of background jobs immediately.
  NO_BG_NICE                # Don't run all background jobs at a lower priority.
  NO_HUP                    # Don't kill jobs on shell exit.
  NO_CHECK_JOBS             # Don't report on jobs when shell exit.
)

# Completion options
typeset -ga zopts_completion=(
  COMPLETE_IN_WORD          # Complete from both ends of a word.
  ALWAYS_TO_END             # Move cursor to the end of a completed word.
  PATH_DIRS                 # Perform path search even on command names with slashes.
  AUTO_MENU                 # Show completion menu on a successive tab press.
  AUTO_LIST                 # Automatically list choices on ambiguous completion.
  AUTO_PARAM_SLASH          # If completed parameter is a directory, add a trailing slash.
  NO_MENU_COMPLETE          # Do not autoselect the first completion entry.
  NO_FLOW_CONTROL           # Disable start/stop characters in shell editor.
)

# Directory options
typeset -ga zopts_directory=(
  AUTO_CD                   # If a command isn't valid, but is a directory, cd to that dir.
  AUTO_PUSHD                # Make cd push the old directory onto the dirstack.
  PUSHD_IGNORE_DUPS         # Don’t push multiple copies of the same directory onto the dirstack.
  PUSHD_SILENT              # Do not print the directory stack after pushd or popd.
  PUSHD_MINUS               # Exchanges meanings of +/- when navigating the dirstack.
  PUSHD_TO_HOME             # Push to home directory when no argument is given.
  CDABLE_VARS               # Change directory to a path stored in a variable.
  MULTIOS                   # Write to multiple descriptors.
  EXTENDED_GLOB             # Use extended globbing syntax.
  NO_CLOBBER                # Do not overwrite files with >. Use >| to bypass.
)

# History options
typeset -ga zopts_history=(
  BANG_HIST                 # Treat the '!' character specially during expansion.
  EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
  NO_SHARE_HISTORY          # Don't share history between all sessions.
  INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
  HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
  HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
  HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
  HIST_FIND_NO_DUPS         # Do not display a previously found event.
  HIST_IGNORE_SPACE         # Do not record an event starting with a space.
  HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
  HIST_VERIFY               # Do not execute immediately upon history expansion.
  HIST_REDUCE_BLANKS        # Remove extra blanks from commands added to the history list.
  NO_HIST_BEEP              # Do not beep when accessing non-existent history.
)

# Prompt options
typeset -ga zopts_prompt=(
  PROMPT_SUBST              # Substitute environment variables in prompt variables.
)

setopt $zopts_general $zopts_job $zopts_completion $zopts_directory $zopts_history $zopts_prompt

# History variables
HISTFILE=${XDG_DATA_HOME:-$HOME/.local/share}/zsh/history
HISTSIZE=10000
SAVEHIST=10000

# Use built-in paste magic
autoload -Uz bracketed-paste-url-magic
zle -N bracketed-paste bracketed-paste-url-magic
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic
