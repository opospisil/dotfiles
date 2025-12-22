function wgdown --wraps='sudo wg-quick down ~/wg0-client-e14.conf' --description 'alias wgdown sudo wg-quick down ~/wg0-client-e14.conf'
    sudo wg-quick down ~/wg0-client-e14.conf $argv
end
