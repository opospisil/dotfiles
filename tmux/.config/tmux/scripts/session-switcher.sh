#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
list_cmd="$SCRIPT_DIR/session-list.sh"

# Check if there are any sessions
if [[ -z "$("$list_cmd")" ]]; then
    echo "No tmux sessions found"
    exit 0
fi

# Use skim to select a session. Ctrl+x kills the highlighted session and
# reloads the list in place (stays open) instead of aborting.
result=$("$list_cmd" | sk \
    --ansi \
    --margin 10% \
    --prompt="Switch to session (Ctrl+x to kill): " \
    --bind "ctrl-x:execute-silent(tmux kill-session -t ={1})+reload($list_cmd)" \
    --header="Enter: switch | Ctrl+x: kill session")

# Extract session name
selected=$(echo "$result" | awk '{print $1}' | sed 's/:$//')

# If a session was selected, switch to it
if [[ -n "$selected" ]]; then
    if [[ -n "$TMUX" ]]; then
        # We're inside tmux, use switch-client
        tmux switch-client -t "=$selected"
    else
        # We're outside tmux, attach to the session
        tmux attach-session -t "=$selected"
    fi
fi
