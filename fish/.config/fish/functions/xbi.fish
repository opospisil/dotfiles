function xbi --wraps='sudo xbps-install -Su' --description 'alias xbi=sudo xbps-install -Su'
  sudo xbps-install -Su $argv
        
end
