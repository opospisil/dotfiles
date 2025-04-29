return {
  'stevearc/oil.nvim',
  opts = {},
  config = function()
    local oil = require("oil")
    vim.keymap.set("n", "<leader>e", oil.open_float, { desc = "Open parent directory" })
    oil.setup({
      view_options = {
        -- Configuration for the floating window in oil.open_float
        float = {
          -- Padding around the floating window
          padding = 10,
          -- max_width and max_height can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
          max_width = 50,
          max_height = 50,
          border = "rounded",
          win_options = {
            winblend = 0,
          },
          -- optionally override the oil buffers window title with custom function: fun(winid: integer): string
          get_win_title = nil,
          -- preview_split: Split direction: "auto", "left", "right", "above", "below".
          preview_split = "right",
          -- This is the config that will be passed to nvim_open_win.
          -- Change values here to customize the layout
        },
      },
    })
  end,
  -- Optional dependencies
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  lazy = false,
}
