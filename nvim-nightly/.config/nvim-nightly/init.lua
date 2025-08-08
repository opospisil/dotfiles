local opt = vim.opt

-- Tab / Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true
opt.wrap = false

-- Search
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false

-- Appearance
opt.number = true
opt.relativenumber = true
opt.termguicolors = true
opt.colorcolumn = "100"
opt.signcolumn = "yes"
opt.cmdheight = 1
opt.scrolloff = 10
opt.completeopt = "menuone,noinsert,noselect"

-- Behaviour
opt.hidden = true
opt.errorbells = false
opt.swapfile = false
opt.backup = false
opt.undodir = vim.fn.expand("~/.vim/undodir")
opt.undofile = true
opt.backspace = "indent,eol,start"
opt.splitright = true
opt.splitbelow = true
opt.autochdir = false
opt.iskeyword:append("-")
opt.selection = "exclusive"
opt.mouse = "a"
opt.clipboard:append("unnamedplus")
opt.modifiable = true
opt.encoding = "UTF-8"
opt.showmode = false

vim.g.mapleader = " "
vim.opt.winborder = "rounded"
vim.o.termguicolors = true

vim.pack.add({
  { src = "https://github.com/norcalli/nvim-colorizer.lua" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
  { src = "https://github.com/vague2k/vague.nvim" },
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/echasnovski/mini.pick" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/chomosuke/typst-preview.nvim" },
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
  { src = "https://github.com/navarasu/onedark.nvim" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/folke/which-key.nvim" },
  { src = "https://github.com/saghen/blink.cmp" },
})

vim.lsp.enable({
  "lua_ls",
  "gopls",
})


vim.diagnostic.config({
  virtual_lines = { current_line = true }
})

require "mini.pick".setup({
  tool = 'fd'
})
require "oil".setup()
require "mason".setup()
require "gitsigns".setup()
require "colorizer".setup()
require "blink.cmp".setup({
  completion = { documentation = { auto_show = true } },
  keymap = {
    preset = "default",
    ['<Tab>'] = { 'select_and_accept' },
  },
})

require "onedark".setup({
  -- Main options --
  style = 'darker',             -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
  transparent = false,          -- Show/hide background
  term_colors = true,           -- Change terminal color as per the selected theme style
  ending_tildes = false,        -- Show the end-of-buffer tildes. By default they are hidden
  cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu

  -- toggle theme style ---
  toggle_style_key = "<leader>ts",                                                     -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
  toggle_style_list = { 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light' }, -- List of styles to toggle between

  -- Change code style ---
  -- Options are italic, bold, underline, none
  -- You can configure multiple style with comma separated, For e.g., keywords = 'italic,bold'
  code_style = {
    comments = 'italic',
    keywords = 'none',
    functions = 'none',
    strings = 'none',
    variables = 'none'
  },

  -- Lualine options --
  lualine = {
    transparent = false, -- lualine center bar transparency
  },

  -- Custom Highlights --
  colors = {
    bg0 = "#0f0f18",
    --bg0 = "#14141f",
    bg1 = "#1b1b28",
    bg2 = "#222230",
    bg3 = "#292936",
    bg_d = "#0f0f18",
    bg_blue = "#505e99",

  }, -- Override default colors
  highlights = {
  }, -- Override highlight groups

  -- Plugins Config --
  diagnostics = {
    darker = true,     -- darker colors for diagnostic
    undercurl = true,  -- use undercurl instead of underline for diagnostics
    background = true, -- use background color for virtual text
  },
})

require "onedark".load()


require "nvim-treesitter.configs".setup({

  build = ":TSUpdate",
  indent = {
    enable = false,
  },
  autotag = {
    enable = true,
  },
  event = {
    "BufReadPre",
    "BufNewFile",
  },
  ensure_installed = {
    "go",
    "elixir",
    "markdown",
    "json",
    "javascript",
    "typescript",
    "yaml",
    "bash",
    "lua",
    "dockerfile",
    "solidity",
    "gitignore",
    "python",
    "vue",
    "svelte",
    "toml",
    "scala",
    "hocon"
  },
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<C-s>",
      node_incremental = "<C-s>",
      scope_incremental = false,
      node_decremental = "<BS>",
    },
  },
})

vim.keymap.set('n', '<leader>o', ':update<CR> :source<CR>')
vim.keymap.set('n', '<leader>ff', ':Pick files tool="fd"<CR>')
vim.keymap.set('n', '<leader>fg', ':Pick grep_live<CR>')
vim.keymap.set('n', '<leader>fb', ':Pick buffers<CR>')
vim.keymap.set('n', '<leader>fh', ':Pick help<CR>')
vim.keymap.set('n', '<leader>e', ':Oil<CR>')
-- Navigate splits using Ctrl+h/j/k/l
vim.keymap.set('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
vim.keymap.set('n', 'C-j>', '<C-w>j', { noremap = true, silent = true })
vim.keymap.set('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })

vim.keymap.set("t", "<Esc>", "<C-\\><C-N>")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set({ "n", "v" }, "<leader>yA", "ggVG\"+y")
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set("i", "<C-c>", "<Esc>")
vim.keymap.set("i", "jj", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set({ "n", "v", "i" }, "<PageUp>", "<nop>")
vim.keymap.set({ "n", "v", "i" }, "<PageDown>", "<nop>")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gc<Left><Left><Left>]])


vim.cmd("colorscheme onedark")
vim.cmd(":hi statusline guibg=NONE")

-- LSP keymappings
local lsp_keymaps = function(bufnr)
  -- Go to definition
  vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition,
    { buffer = bufnr, noremap = true, silent = true, desc = "Go to definition" })

  -- Find references with Telescope
  vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references,
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
    --local client = vim.lsp.get_client_by_id(ev.data.client_id)
    --if client:supports_method('textDocument/completion') then
    --  vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    --end
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
