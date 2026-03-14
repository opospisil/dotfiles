function tma --wraps='tmux attach-session' --description 'alias tma=tmux attach-session'
    tmux attach-session $argv
end
