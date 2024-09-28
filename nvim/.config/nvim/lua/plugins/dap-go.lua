return {
  "leoluz/nvim-dap-go",
  ft = "go",
  dependencies = { "mfussnegger/nvim-dap" },
  config = function(_, opts)
    require("dap-go").setup(opts)
    require("dap").set_log_level("TRACE")
  end,
}
