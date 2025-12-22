-- A more flexible makeprg setup
vim.bo.makeprg = 'go $*'
vim.bo.errorformat = ' %f,%E%*\\s(%l,%*\\s%c)%*\\s%m'

-- You can also add some helpful custom commands
vim.api.nvim_buf_create_user_command(0, 'GoBuild', 'make build .', {
  desc = "Build the current Go package"
})

vim.api.nvim_buf_create_user_command(0, 'GoRun', 'make run .', {
  desc = "Run the current Go package"
})

vim.api.nvim_buf_create_user_command(0, 'GoTest', 'make test', {
  desc = "Run tests for the current Go package"
})

-- Define a custom command for running your revive linter
vim.api.nvim_buf_create_user_command(0, 'Lint', 'make -s', {
  desc = "Run revive linter and populate quickfix list"
})

-- Set the makeprg for this buffer to your script
-- The '-s' flag for make silences the "make: '...' is up to date." messages
vim.bo.makeprg = './revive.sh'
