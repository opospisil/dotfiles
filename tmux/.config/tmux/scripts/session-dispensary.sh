#!/bin/bash

DIRS=(
    "$HOME/code/3rd-party"
    "$HOME/code/personal"
    "$HOME/code/openbean/diameter"
    "$HOME/code/openbean/dtit"
    "/vault/code"
    "/vault/code/dtsp"
)

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(fd . "${DIRS[@]}" --type=dir --follow --max-depth=1 --full-path | sk --margin 10% )
fi

[[ ! $selected ]] && exit 0
selected=${selected%/}

working_dir=$selected
if [[ $selected == /vault/code/dte/* && -d "$selected/apps/v3/backend" ]]; then
    working_dir="$selected/apps/v3/backend"
fi

worktree_root=$(git -C "$selected" rev-parse --show-toplevel 2>/dev/null)
if [[ $worktree_root ]]; then
    selected_name=$(basename "$worktree_root")
else
    selected_name=$(basename "$selected")
fi
selected_name=${selected_name//[^[:alnum:]_-]/_}

if ! tmux has-session -t "=$selected_name" 2>/dev/null; then
    tmux new-session -ds "$selected_name" -c "$working_dir"
fi

tmux switch-client -t "=$selected_name"
