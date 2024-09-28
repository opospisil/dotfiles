-- highlight on yank
local highlight_yank_group = vim.api.nvim_create_augroup("HighlightYankGroup", {})
vim.api.nvim_create_autocmd("TextYankPost", {
  group = highlight_yank_group,
  callback = function()
    vim.highlight.on_yank()
  end,
})

--vim.api.nvim_create_autocmd({ 'FileType' }, {
--  pattern = { "lir" },
--  callback = function()
--    -- use visual mode
--    vim.api.nvim_buf_set_keymap(
--      0,
--      "x",
--      "J",
--      ':<C-u>lua require"lir.mark.actions".toggle_mark("v")<CR>',
--      { noremap = true, silent = true }
--    )
--
--    -- echo cwd
--    vim.api.nvim_echo({ { vim.fn.expand("%:p"), "Normal" } }, false, {})
--  end
--})
