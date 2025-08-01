local buffers_picker = {
  theme = "dropdown",
  previewer = false,
  layout_config = {
    width = 0.5,
    prompt_position = "top",
  },
  sort_mru = true,
}

local config = function()
  local telescope = require("telescope")
  telescope.setup({
    extensions = {
      undo = {},
    },
    defaults = {
      file_ignore_patterns = {
        ".metals/",
        ".bloop/",
        ".git/",
        ".cache/",
        "^/vendor/",
        "/vendor/",
        "vendor/",
        "%/vendor/",
        "%.o",
        "%.out",
        "%.class",
        "%.pdf",
        "%.mkv",
        "%.mp4",
        "%.zip",
      },
      mappings = {
        i = {
          ["<C-j>"] = "move_selection_next",
          ["<C-k>"] = "move_selection_previous",
          --["<C-q>"] = close_buffers,
        },
      },
    },
    pickers = {
      find_files = {
        --theme = "dropdown",
        previewer = true,
        hidden = true,
        layout_config = {
          width = 0.9,
          height = 0.9,
          prompt_position = "bottom",
        },
        find_command = { "rg", "--files", "--sort", "path" },
      },
      live_grep = {
        layout_config = {
          width = 0.9,
          height = 0.9,
          prompt_position = "bottom",
        },
        previewer = true,
      },
      buffers = buffers_picker,
      colorscheme = {
        previewer = true,
        theme = "dropdown",
      },
    },
  })
end

return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "debugloop/telescope-undo.nvim",
  },
  config = config,
  keys = {
    -- vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files, {}),
    --	vim.keymap.set("n", "<leader>fg", require("telescope.builtin").live_grep, {}),
    --	vim.keymap.set("n", "<leader>fb", require("telescope.builtin").buffers, {}),
    --	vim.keymap.set("n", "<leader>fh", require("telescope.builtin").help_tags, {}),
    --	vim.keymap.set("n", "<leader>fk", require("telescope.builtin").keymaps, {}),
  },
}
