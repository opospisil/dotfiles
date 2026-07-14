#!/bin/bash

# Emit the tmux session list, one per line, formatted for the switcher.
# The currently-attached session is highlighted. Shared by session-switcher.sh
# as both the initial input and the ctrl-x reload command.
tmux list-sessions -F $'#{session_name}\t#{session_windows} windows (#{?session_attached,attached,not attached})\t#{session_attached}' 2>/dev/null | \
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
    }'
