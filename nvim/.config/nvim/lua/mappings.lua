require "nvchad.mappings"

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
--
map("n", "<leader>sv", ":vsplit<CR>") -- Split Vertically
map("n", "<leader>sh", ":split<CR>")  -- Split Horizontally
map("n", "<C-S-Up>", ":resize +2<CR>")
map("n", "<C-S-Down>", ":resize -2<CR>")
map("n", "<C-S-Left>", ":vertical resize +2<CR>")
map("n", "<C-S-Right>", ":vertical resize -2<CR>")

map("n", "<C-Left>", "<C-w>h")
map("n", "<C-Down>", "<C-w>j")
map("n", "<C-Up>", "<C-w>k")
map("n", "<C-Right>", "<C-w>l")
map("t", "<Esc>", "<C-\\><C-N>")

map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- some general lsp stuff
map("n", "<leader>mc", '<cmd>lua require"telescope".extensions.metals.commands()<CR>')
map("n", "<leader>f", vim.lsp.buf.format)

map("n", "J", "mzJ`z")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- greatest remap ever
map("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
map({ "n", "v" }, "<leader>y", [["+y]])
map({ "n", "v" }, "<leader>yA", "ggVG\"+y")
map("n", "<leader>Y", [["+Y]])

map({ "n", "v" }, "<leader>d", [["_d]])

-- This is going to get me cancelled
map("i", "<C-c>", "<Esc>")

map("n", "Q", "<nop>")

map({ "n", "v", "i" }, "<PageUp>", "<nop>")
map({ "n", "v", "i" }, "<PageDown>", "<nop>")
--map("n", "<C-k>", "<cmd>cnext<CR>zz")
--map("n", "<C-j>", "<cmd>cprev<CR>zz")
map("n", "<leader>k", "<cmd>lnext<CR>zz")
map("n", "<leader>j", "<cmd>lprev<CR>zz")

map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])



-- DAP keybinds
map("n", "<leader>dt", ":DapUiToggle<CR>")
map("n", "<leader>db", ":DapToggleBreakpoint<CR>")
map("n", "<leader>dc", ":DapContinue<CR>")
map("n", "<leader>dr", ":lua require('dapui').open({reset = true})<CR>")
map("n", "<leader>ht", ":lua require('harpoon.ui').toggle_quick_menu()<CR>")

map("n", "<leader>fk", "<cmd>Telescope keymaps<CR>", { desc = "Show Keymaps" })
map("n", "<leader>tt", "<cmd>TodoTelescope<CR>", { desc = "Show todos in telescope" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Show Help Tags" })
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find Files" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Find Buffers" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live Grep" })


-- ChatGPT mappings under <leader>c
map("n", "<leader>ac", "<cmd>ChatGPT<CR>", { desc = "ChatGPT" })
map("n", "<leader>ae", "<cmd>ChatGPTEditWithInstruction<CR>", { desc = "Edit with instruction" })
map("n", "<leader>ag", "<cmd>ChatGPTRun grammar_correction<CR>", { desc = "Grammar Correction" })
map("n", "<leader>at", "<cmd>ChatGPTRun translate<CR>", { desc = "Translate" })
map("n", "<leader>ak", "<cmd>ChatGPTRun keywords<CR>", { desc = "Keywords" })
map("n", "<leader>ad", "<cmd>ChatGPTRun docstring<CR>", { desc = "Docstring" })
map("n", "<leader>aa", "<cmd>ChatGPTRun add_tests<CR>", { desc = "Add Tests" })
map("n", "<leader>ao", "<cmd>ChatGPTRun optimize_code<CR>", { desc = "Optimize Code" })
map("n", "<leader>as", "<cmd>ChatGPTRun summarize<CR>", { desc = "Summarize" })
map("n", "<leader>af", "<cmd>ChatGPTRun fix_bugs<CR>", { desc = "Fix Bugs" })
map("n", "<leader>ax", "<cmd>ChatGPTRun explain_code<CR>", { desc = "Explain Code" })
map("n", "<leader>ar", "<cmd>ChatGPTRun roxygen_edit<CR>", { desc = "Roxygen Edit" })
map("n", "<leader>al", "<cmd>ChatGPTRun code_readability_analysis<CR>", { desc = "Code Readability Analysis" })


map('n', '<SHIFT-F5>', function() require('dap').continue() end)
map('n', '<SHIFT-F6>', function() require('dap').step_over() end)
map('n', '<SHIFT-F7>', function() require('dap').step_into() end)
map('n', '<SHIFT-F8>', function() require('dap').step_out() end)
map('n', '<SHIFT-F9>', function() require('dap').run_to_cursor() end)
map('n', '<Leader>bb', function() require('dap').toggle_breakpoint() end)
map('n', '<Leader>bB', function() require('dap').clear_breakpoints() end)
map('n', '<Leader>lp',
  function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
map('n', '<Leader>dr', function() require('dap').repl.open() end)
map('n', '<Leader>dl', function() require('dap').run_last() end)
map({ 'n', 'v' }, '<Leader>dh', function()
  require('dap.ui.widgets').hover()
end)
map({ 'n', 'v' }, '<Leader>dp', function()
  require('dap.ui.widgets').preview()
end)
map('n', '<Leader>df', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.frames)
end)
map('n', '<Leader>ds', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.scopes)
end)

map('n', '<Leader>dui', function() require('dapui').open() end)
map('n', '<Leader>duc', function() require('dapui').close() end)
