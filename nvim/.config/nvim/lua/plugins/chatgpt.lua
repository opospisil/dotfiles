return {
  "jackMort/ChatGPT.nvim",
  event = "VeryLazy",
  config = function()
    require("chatgpt").setup({
      openai_params = {
        model = "gpt-4-turbo"
      },
      openai_edit_params = {
        model = "gpt-4-turbo"
      },
        ignore_default_actions_path = true,
      actions_paths = { "~/.config/nvim/gpt_actions.json" },
      api_key_cmd = "bw get notes nvim_gpt_key"
    })
  end,
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "folke/trouble.nvim", -- optional
    "nvim-telescope/telescope.nvim"
  }
}
