function xbr --wraps='sudo xbps-remove -S' --wraps='sudo xbps-remove -o' --description 'alias xbr=sudo xbps-remove -o'
  sudo xbps-remove -o $argv
        
end
