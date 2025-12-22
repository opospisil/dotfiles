function wgup --wraps='sudo wg-quick up ~/wg0-client-e14.conf' --description 'alias wgup sudo wg-quick up ~/wg0-client-e14.conf'
    sudo wg-quick up ~/wg0-client-e14.conf $argv
end
