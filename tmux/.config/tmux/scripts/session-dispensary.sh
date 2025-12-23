#!/bin/bash

DIRS=(
    "$HOME/code"
    "/vault/code"
    "$HOME/code/dtsp"
    "$HOME/.config"
)

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(fd . "${DIRS[@]}" --type=dir --follow --max-depth=1 --full-path --base-directory $HOME \
        | sed "s|^$HOME/||" \
        | grep -v "^code/dtsp$" \
        | sk --margin 10% )

    [[ $selected ]] && selected="$HOME/$selected"
fi

[[ ! $selected ]] && exit 0

selected_name=$(basename "${selected%/}" | tr . _)

if ! tmux has-session -t "$selected_name" 2>/dev/null; then
    tmux new-session -ds "$selected_name" -c "$selected"
fi

tmux switch-client -t "$selected_name"
