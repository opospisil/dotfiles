function cpenv
     set svc (echo $PWD | string split / | tail -n1); cp /vault/code/dte/dtspv2/apps/v3/backend/apps/$svc/.env .; 
end
