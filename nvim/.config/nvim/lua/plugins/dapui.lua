return {
  "rcarriga/nvim-dap-ui",
  ft = "go",
  config = function()
    require("dapui").setup()
  end,
  dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" }
}
