-- highlight on yank
local highlight_yank_group = vim.api.nvim_create_augroup("HighlightYankGroup", {})
vim.api.nvim_create_autocmd("TextYankPost", {
  group = highlight_yank_group,
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = { "*.go" },
  callback = function()
    vim.opt.tabstop = 4
    vim.opt.shiftwidth = 4
    vim.opt.expandtab = false -- Go prefers tabs
  end
})


--vim.api.nvim_create_autocmd("BufWritePost", {
--  pattern = "*.go",
--  callback = function()
--    -- Save current cursor position
--    local pos = vim.api.nvim_win_get_cursor(0)
--    -- Get full path of the current file
--    local filepath = vim.fn.shellescape(vim.fn.expand('%:p'))
--    -- Run gofmt in shell
--    vim.fn.system("gofmt -w " .. filepath)
--    -- Reload the buffer
--    vim.cmd("edit!")
--    -- Restore cursor position
--    vim.api.nvim_win_set_cursor(0, pos)
--  end,
--})
