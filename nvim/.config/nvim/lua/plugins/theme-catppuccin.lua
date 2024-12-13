return {
  "catppuccin/nvim",
  name = "theme",
  lazy = false,
  priority = 999,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha", -- Choose your preferred Catppuccin flavor
      color_overrides = {
        all = {
          background = "#ffffff",
        },
      }
    })
  end,
}
