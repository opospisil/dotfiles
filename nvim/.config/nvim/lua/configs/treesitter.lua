local options = {
  ensure_installed = {
    "bash",
    "lua",
    "luadoc",
    "markdown",
    "printf",
    "toml",
    "vim",
    "vimdoc",
    "yaml",
    "go",
    "gomod",
    "gosum",
    "gotmpl",
    "gowork",
    "json",
    "html",
  },

  highlight = {
    enable = true,
    use_languagetree = true,
  },
  auto_install = true,
  indent = { enable = true },
}

require("nvim-treesitter.configs").setup(options)
