if status is-interactive
    # Commands to run in interactive sessions can go here
end

starship init fish | source
direnv hook fish | source

# opencode
fish_add_path /home/o/.opencode/bin
