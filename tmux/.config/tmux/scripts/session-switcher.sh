#!/bin/bash

while true; do
    # Get list of tmux sessions with more details
    sessions=$(tmux list-sessions -F $'#{session_name}\t#{session_windows} windows (#{?session_attached,attached,not attached})\t#{session_attached}' 2>/dev/null | \
        awk -F '\t' '{
            name[NR] = $1
            info[NR] = $2
            attached[NR] = $3
            if (length($1) > max) {
                max = length($1)
            }
        }
        END {
            for (i = 1; i <= NR; i++) {
                line = sprintf("%-*s  %s", max, name[i], info[i])
                if (attached[i] == 1) {
                    printf "\033[48;5;27m%s\033[0m\n", line
                } else {
                    print line
                }
            }
        }')

    # Check if there are any sessions
    if [[ -z "$sessions" ]]; then
        echo "No tmux sessions found"
        exit 0
    fi

    # Use skim to select a session with preview and keybindings
    result=$(echo "$sessions" | sk \
        --ansi \
        --margin 10% \
        --prompt="Switch to session (Ctrl+x to kill): " \
        --preview="tmux list-windows -t {1} -F '  #{window_index}: #{window_name} (#{window_panes} panes)'" \
        --preview-window=right:50% \
        --bind 'ctrl-x:execute-silent(tmux kill-session -t {1})+abort' \
        --header="Enter: switch | Ctrl+x: kill session")

    # Extract session name
    selected=$(echo "$result" | awk '{print $1}' | sed 's/:$//')

    # If a session was selected, switch to it
    if [[ -n "$selected" ]]; then
        if [[ -n "$TMUX" ]]; then
            # We're inside tmux, use switch-client
            tmux switch-client -t "$selected"
        else
            # We're outside tmux, attach to the session
            tmux attach-session -t "$selected"
        fi
        break
    else
        # User aborted (ESC or Ctrl+x was used), exit
        break
    fi
done
