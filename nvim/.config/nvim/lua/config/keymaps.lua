
-- local default_opts = {
-- 	noremap = true,
-- 	silent = true,
-- }
-- Buffer Navigation
vim.keymap.set("n", "<leader>bn", ":bnext<CR>") -- Next buffer
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>") -- Prev buffer
vim.keymap.set("n", "<leader>bb", "<cmd>e #<CR>") -- Switch to Other Buffer
vim.keymap.set("n", "<leader>`", "<cmd>e #<CR>") -- Switch to Other Buffer

-- Directory Navigation
vim.keymap.set("n", "<leader>m", ":NvimTreeFocus<CR>")
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")

-- Window Management
vim.keymap.set("n", "<leader>sv", ":vsplit<CR>") -- Split Vertically
vim.keymap.set("n", "<leader>sh", ":split<CR>")-- Split Horizontally
vim.keymap.set("n", "<C-S-Up>", ":resize +2<CR>")
vim.keymap.set("n", "<C-S-Down>", ":resize -2<CR>")
vim.keymap.set("n", "<C-S-Left>", ":vertical resize +2<CR>")
vim.keymap.set("n", "<C-S-Right>", ":vertical resize -2<CR>")

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<C-Left>", "<C-w>h")
vim.keymap.set("n", "<C-Down>", "<C-w>j")
vim.keymap.set("n", "<C-Up>", "<C-w>k")
vim.keymap.set("n", "<C-Right>", "<C-w>l")
vim.keymap.set("t", "<Esc>", "<C-\\><C-N>")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- some general lsp stuff
vim.keymap.set("n", "<leader>mc", '<cmd>lua require"telescope".extensions.metals.commands()<CR>')
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set({ "n", "v", "i" }, "<PageUp>", "<nop>")
vim.keymap.set({ "n", "v", "i" }, "<PageDown>", "<nop>")
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- DAP keybinds
vim.keymap.set("n", "<leader>dt", ":DapUiToggle<CR>")
vim.keymap.set("n", "<leader>db", ":DapToggleBreakpoint<CR>")
vim.keymap.set("n", "<leader>dc", ":DapContinue<CR>")
vim.keymap.set("n", "<leader>dr", ":lua require('dapui').open({reset = true})<CR>")
vim.keymap.set("n", "<leader>ht", ":lua require('harpoon.ui').toggle_quick_menu()<CR>")

vim.keymap.set("n", "<leader>fk", "<cmd>Telescope keymaps<CR>", {desc = "Show Keymaps"})
vim.keymap.set("n", "<leader>tt", "<cmd>TodoTelescope<CR>", {desc = "Show todos in telescope"})
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", {desc = "Show Help Tags"})
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", {desc = "Find Files"})
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", {desc = "Find Buffers"})
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", {desc = "Live Grep"})


-- ChatGPT mappings under <leader>c
vim.keymap.set("n", "<leader>ac", "<cmd>ChatGPT<CR>", { desc = "ChatGPT" })
vim.keymap.set("n", "<leader>ae", "<cmd>ChatGPTEditWithInstruction<CR>", { desc = "Edit with instruction" })
vim.keymap.set("n", "<leader>ag", "<cmd>ChatGPTRun grammar_correction<CR>", { desc = "Grammar Correction" })
vim.keymap.set("n", "<leader>at", "<cmd>ChatGPTRun translate<CR>", { desc = "Translate" })
vim.keymap.set("n", "<leader>ak", "<cmd>ChatGPTRun keywords<CR>", { desc = "Keywords" })
vim.keymap.set("n", "<leader>ad", "<cmd>ChatGPTRun docstring<CR>", { desc = "Docstring" })
vim.keymap.set("n", "<leader>aa", "<cmd>ChatGPTRun add_tests<CR>", { desc = "Add Tests" })
vim.keymap.set("n", "<leader>ao", "<cmd>ChatGPTRun optimize_code<CR>", { desc = "Optimize Code" })
vim.keymap.set("n", "<leader>as", "<cmd>ChatGPTRun summarize<CR>", { desc = "Summarize" })
vim.keymap.set("n", "<leader>af", "<cmd>ChatGPTRun fix_bugs<CR>", { desc = "Fix Bugs" })
vim.keymap.set("n", "<leader>ax", "<cmd>ChatGPTRun explain_code<CR>", { desc = "Explain Code" })
vim.keymap.set("n", "<leader>ar", "<cmd>ChatGPTRun roxygen_edit<CR>", { desc = "Roxygen Edit" })
vim.keymap.set("n", "<leader>al", "<cmd>ChatGPTRun code_readability_analysis<CR>", { desc = "Code Readability Analysis" })


vim.keymap.set('n', '<SHIFT-F5>', function() require('dap').continue() end)
vim.keymap.set('n', '<SHIFT-F6>', function() require('dap').step_over() end)
vim.keymap.set('n', '<SHIFT-F7>', function() require('dap').step_into() end)
vim.keymap.set('n', '<SHIFT-F8>', function() require('dap').step_out() end)
vim.keymap.set('n', '<SHIFT-F9>', function() require('dap').run_to_cursor() end)
vim.keymap.set('n', '<Leader>bb', function() require('dap').toggle_breakpoint() end)
vim.keymap.set('n', '<Leader>bB', function() require('dap').clear_breakpoints() end)
vim.keymap.set('n', '<Leader>lp', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end)
vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)
vim.keymap.set({'n', 'v'}, '<Leader>dh', function()
  require('dap.ui.widgets').hover()
end)
vim.keymap.set({'n', 'v'}, '<Leader>dp', function()
  require('dap.ui.widgets').preview()
end)
vim.keymap.set('n', '<Leader>df', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.frames)
end)
vim.keymap.set('n', '<Leader>ds', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.scopes)
end)

vim.keymap.set('n', '<Leader>dui', function() require('dapui').open() end)
vim.keymap.set('n', '<Leader>duc', function() require('dapui').close() end)
