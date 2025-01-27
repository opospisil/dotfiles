local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

local pickers = require('telescope.pickers')
local builtin = require('telescope.builtin')
local finders = require('telescope.finders')
local conf = require('telescope.config').values
local themes = require('telescope.themes')

local buffers_picker = {
  theme = "dropdown",
  previewer = false,
  layout_config = {
    width = 0.5,
    prompt_position = "top",
  },
}

local close_buffers = function(prompt_bufnr)
  local current_picker = action_state.get_current_picker(prompt_bufnr)
  local selections = current_picker:get_multi_selection()

  actions.close(prompt_bufnr) -- Close the picker first

  if vim.tbl_isempty(selections) then
    local selection = action_state.get_selected_entry()
    vim.api.nvim_buf_delete(selection.bufnr, { force = false })
  else
    for _, selection in ipairs(selections) do
      vim.api.nvim_buf_delete(selection.bufnr, { force = false })
    end
  end

  -- Reopen the built-in buffer picker with the desired theme and options
  builtin.buffers(themes.get_dropdown({
    winblend = 10,
    layout_config = {
      width = 0.5, -- 50% of the screen width
    },
    previewer = false,
  }))
end

local config = function()
  local telescope = require("telescope")
  telescope.setup({
    extensions = {
      undo = {
      },
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
      },
      live_grep = {
        theme = "dropdown",
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
  tag = "0.1.3",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "debugloop/telescope-undo.nvim"
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
