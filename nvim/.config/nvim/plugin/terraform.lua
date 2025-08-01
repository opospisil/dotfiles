local state = {
  floating = {
    buf = -1,
    win = -1,
  }
}

-- Function to create a floating window
local function create_floating_window(opts)
  opts = opts or {}
  local width = opts.width or math.floor(vim.o.columns * 0.5)
  local height = opts.height or math.floor(vim.o.lines * 0.5)
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  -- Create or reuse buffer
  local buf
  if opts.buf and vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true)
  end

  -- Define window configuration
  local win_config = {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    border = "rounded",
    focusable = true,
  }

  -- Create and focus the floating window
  local win = vim.api.nvim_open_win(buf, true, win_config)
  vim.api.nvim_set_current_win(win)
  vim.api.nvim_set_current_buf(buf)

  return { buf = buf, win = win }
end

-- Function to close the floating window
local function close_floating_window()
  if vim.api.nvim_win_is_valid(state.floating.win) then
    vim.api.nvim_win_hide(state.floating.win)
  end
  if vim.api.nvim_buf_is_valid(state.floating.buf) then
    vim.api.nvim_buf_delete(state.floating.buf, { force = true })
  end
  state.floating = { buf = -1, win = -1 }
end

-- Function to run terraform command and display output
local function run_terraform_command(cmd, buf_name)
  -- Close existing window if open
  close_floating_window()

  -- Run terraform command and capture output
  local output = vim.fn.systemlist(cmd)
  local success = vim.v.shell_error == 0

  -- Create new floating window
  state.floating = create_floating_window({ buf = state.floating.buf })
  vim.api.nvim_buf_set_lines(state.floating.buf, 0, -1, true, output)
  vim.api.nvim_set_option_value("filetype", "terraform", { buf = state.floating.buf })
  vim.api.nvim_set_option_value("buftype", "nofile", { buf = state.floating.buf })
  vim.api.nvim_buf_set_name(state.floating.buf, buf_name)

  -- Set keymap for closing with Escape
  vim.keymap.set("n", "<Esc>", ":bw<CR>", { buffer = state.floating.buf, noremap = true, silent = true })

  -- Set buffer options based on success
  if success then
    vim.api.nvim_set_option_value("modifiable", false, { buf = state.floating.buf })
    vim.api.nvim_buf_set_lines(state.floating.buf, 0, -1, true, { "Success! Terraform configuration is valid." })
  else
    vim.api.nvim_set_option_value("modifiable", false, { buf = state.floating.buf })
    vim.api.nvim_set_option_value("filetype", "terraform", { buf = state.floating.buf })
  end
end

-- User commands for manual execution
vim.api.nvim_create_user_command("TerraformValidate", function()
  run_terraform_command("terraform validate -no-color", "Terraform Validate Output")
end, { desc = "Run terraform validate" })

vim.api.nvim_create_user_command("TerraformPlan", function()
  run_terraform_command("terraform plan -no-color", "Terraform Plan Output")
end, { desc = "Run terraform plan" })
