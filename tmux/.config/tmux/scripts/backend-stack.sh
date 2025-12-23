#!/bin/bash

SESSION="backend"
WINDOW="services"
BACKEND_DIR="$HOME/code/dtsp/backend"
SERVICES=("gateway" "identity" "target" "container" "satellite" "project")

# Check if we're in a tmux session
if [[ -z "$TMUX" ]]; then
    echo "Error: This script must be run from within a tmux session"
    exit 1
fi

# Check if we're in the backend session
current_session=$(tmux display-message -p '#S')
if [[ "$current_session" != "$SESSION" ]]; then
    echo "Error: This script must be run from the 'backend' tmux session"
    echo "Current session: $current_session"
    exit 1
fi

# Check if the stack window already exists
if tmux list-windows -t "$SESSION" | grep -q ": $WINDOW "; then
    echo "Window '$WINDOW' already exists in session '$SESSION'"
    tmux select-window -t "$SESSION:$WINDOW"
    exit 0
fi

# Create new window
tmux new-window -t "$SESSION" -n "$WINDOW" -c "$BACKEND_DIR/apps/${SERVICES[0]}"

# Start air in the first pane
tmux send-keys -t "$SESSION:$WINDOW.0" "air" C-m

# Create splits for remaining services
for i in "${!SERVICES[@]}"; do
    if [[ $i -eq 0 ]]; then
        continue
    fi
    
    service="${SERVICES[$i]}"
    
    # Create horizontal split
    tmux split-window -t "$SESSION:$WINDOW" -h -c "$BACKEND_DIR/apps/$service"
    
    # Rebalance the layout
    tmux select-layout -t "$SESSION:$WINDOW" tiled
    
    # Start air in the new pane
    tmux send-keys -t "$SESSION:$WINDOW.$i" "air" C-m
done

# Select the tiled layout for even distribution
tmux select-layout -t "$SESSION:$WINDOW" tiled

# Select the first pane
tmux select-pane -t "$SESSION:$WINDOW.0"

echo "Backend stack started in window '$WINDOW'"
