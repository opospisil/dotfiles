return {
  "rose-pine/neovim",
  name = "rose-pine",
  lazy = false,
  priority = 999,
  config = function()
    require("rose-pine").setup({
      styles = {
        bold = true,
        italic = true,
        transparency = false,
      },
    })
  end
}
