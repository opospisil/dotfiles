if vim.g.loaded_opencode_nvim == 1 then
  return
end

vim.g.loaded_opencode_nvim = 1

require('opencode').setup()
