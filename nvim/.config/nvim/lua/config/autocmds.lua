-- LSP keymappings
local lsp_keymaps = function(bufnr)
  -- Go to definition
  vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition,
    { buffer = bufnr, noremap = true, silent = true, desc = "Go to definition" })

  -- Find references with Telescope
  vim.keymap.set('n', '<leader>gr', '<cmd>Telescope lsp_references<CR>',
    { buffer = bufnr, noremap = true, silent = true, desc = "Find references" })

  -- Find implementations with Telescope
  vim.keymap.set('n', '<leader>gi', '<cmd>Telescope lsp_implementations<CR>',
    { buffer = bufnr, noremap = true, silent = true, desc = "Find implementations" })

  -- Go to declaration
  vim.keymap.set('n', '<leader>gD', vim.lsp.buf.declaration,
    { buffer = bufnr, noremap = true, silent = true, desc = "Go to declaration" })

  -- Show hover documentation
  vim.keymap.set('n', '<leader>gh', vim.lsp.buf.hover,
    { buffer = bufnr, noremap = true, silent = true, desc = "Show hover documentation" })

  -- Peek definition with lspsaga on Alt+Shift+K
  vim.keymap.set('n', '<M-S-k>', '<cmd>Lspsaga peek_definition<CR>',
    { buffer = bufnr, noremap = true, silent = true, desc = "Peek definition" })

  -- Show signature help
  vim.keymap.set('n', '<leader>gs', vim.lsp.buf.signature_help,
    { buffer = bufnr, noremap = true, silent = true, desc = "Show signature help" })

  -- Rename symbol
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename,
    { buffer = bufnr, noremap = true, silent = true, desc = "Rename symbol" })

  -- Code actions
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action,
    { buffer = bufnr, noremap = true, silent = true, desc = "Code actions" })

  -- Show diagnostics for current line
  vim.keymap.set('n', '<leader>ld', vim.diagnostic.open_float,
    { buffer = bufnr, noremap = true, silent = true, desc = "Show line diagnostics" })

  -- Show all diagnostics in Telescope
  vim.keymap.set('n', '<leader>da', '<cmd>Telescope diagnostics<CR>',
    { buffer = bufnr, noremap = true, silent = true, desc = "Show all diagnostics" })
end

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

-- LSP attach with lspsaga and formatting
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
  callback = function(ev)
    -- Initialize lspsaga for this buffer
    require('lspsaga').setup({})

    -- Set up keymappings
    lsp_keymaps(ev.buf)

    -- Auto-format on save
    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = ev.buf,
      callback = function()
        vim.lsp.buf.format({ bufnr = ev.buf })
      end,
    })
  end,
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
