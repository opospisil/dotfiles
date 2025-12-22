function wgres --wraps='wgdown && wgup' --description 'alias wgres wgdown && wgup'
    wgdown && wgup $argv
end
