
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
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", {desc = "Live Grep"})
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", {desc = "Find Buffers"})
vim.keymap.set("n", "<leader>fc", "<cmd>Telescope colorscheme<CR>", { noremap = true, silent = true })
