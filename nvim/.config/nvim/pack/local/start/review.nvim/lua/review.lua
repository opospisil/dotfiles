local M = {}

local state = {
  by_file = {},
  items = {},
  loaded = false,
  ns = vim.api.nvim_create_namespace('review'),
  root = nil,
  setup = false,
}

local function cwd()
  return vim.fn.getcwd()
end

local function review_file()
  return cwd() .. '/review.md'
end

local function normalize_path(path)
  return vim.fs.normalize(vim.fn.fnamemodify(path, ':p'))
end

local function relative_path(file_path)
  return vim.fn.fnamemodify(file_path, ':.')
end

local function current_file_path()
  local file_path = vim.api.nvim_buf_get_name(0)
  if file_path == '' then
    vim.notify('Review requires a file-backed buffer', vim.log.levels.ERROR)
    return nil
  end

  return normalize_path(file_path)
end

local function normalize_note(note)
  return vim.trim((note or ''):gsub('%s+', ' '))
end

local function parse_line(line)
  local path, lnum, text = line:match('^(.-):(%d+):%s*(.*)$')
  if not path or text == '' then
    return nil
  end

  return {
    filename = normalize_path(path),
    lnum = tonumber(lnum),
    text = text,
  }
end

local function clear_virtual_text()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr) then
      vim.api.nvim_buf_clear_namespace(bufnr, state.ns, 0, -1)
    end
  end
end

local function clear_state()
  state.by_file = {}
  state.items = {}
  state.loaded = false
  state.root = nil
  clear_virtual_text()
end

local function review_qflist_context(root)
  return {
    review = true,
    root = root,
  }
end

local function current_qflist_info()
  return vim.fn.getqflist({ context = 1, title = 1 })
end

local function is_review_qflist_active()
  local info = current_qflist_info()
  return type(info.context) == 'table' and info.context.review == true
end

local function clear_review_qflist_if_active()
  if not is_review_qflist_active() then
    return
  end

  vim.fn.setqflist({}, 'r', {
    context = review_qflist_context(cwd()),
    items = {},
    title = 'Review',
  })
  vim.cmd('cclose')
end

local function apply_virtual_text(bufnr)
  if not vim.api.nvim_buf_is_loaded(bufnr) then
    return
  end

  vim.api.nvim_buf_clear_namespace(bufnr, state.ns, 0, -1)

  if not state.loaded or state.root ~= cwd() then
    return
  end

  local buffer_name = vim.api.nvim_buf_get_name(bufnr)
  if buffer_name == '' then
    return
  end

  local file_path = normalize_path(buffer_name)
  local entries = state.by_file[file_path]
  if not entries then
    return
  end

  local line_map = {}
  for _, entry in ipairs(entries) do
    line_map[entry.lnum] = line_map[entry.lnum] or {}
    table.insert(line_map[entry.lnum], entry.text)
  end

  local line_numbers = vim.tbl_keys(line_map)
  table.sort(line_numbers)
  local last_line = vim.api.nvim_buf_line_count(bufnr)

  for _, lnum in ipairs(line_numbers) do
    if lnum >= 1 and lnum <= last_line then
      vim.api.nvim_buf_set_extmark(bufnr, state.ns, lnum - 1, 0, {
        hl_mode = 'combine',
        virt_text = { { 'Review: ' .. table.concat(line_map[lnum], ' | '), 'ReviewVirtualText' } },
        virt_text_pos = 'eol',
      })
    end
  end
end

local function apply_virtual_text_to_loaded_buffers()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    apply_virtual_text(bufnr)
  end
end

function M.load_reviews(opts)
  opts = opts or {}

  clear_state()

  local file = review_file()
  if vim.fn.filereadable(file) == 0 then
    clear_review_qflist_if_active()
    vim.notify('No review.md found in ' .. cwd(), vim.log.levels.WARN)
    return
  end

  local items = {}
  local by_file = {}
  local invalid_lines = 0

  for _, line in ipairs(vim.fn.readfile(file)) do
    if line:match('^%s*$') == nil then
      local item = parse_line(line)
      if item then
        table.insert(items, item)
        by_file[item.filename] = by_file[item.filename] or {}
        table.insert(by_file[item.filename], {
          lnum = item.lnum,
          text = item.text,
        })
      else
        invalid_lines = invalid_lines + 1
      end
    end
  end

  state.by_file = by_file
  state.items = items
  state.loaded = true
  state.root = cwd()

  vim.fn.setqflist({}, ' ', {
    context = review_qflist_context(state.root),
    items = items,
    title = 'Review',
  })

  apply_virtual_text_to_loaded_buffers()

  if opts.open ~= false then
    vim.cmd('botright copen')
  end

  if opts.notify ~= false then
    local message = string.format('Loaded %d review entr%s', #items, #items == 1 and 'y' or 'ies')
    if invalid_lines > 0 then
      message = message .. string.format(' (%d skipped)', invalid_lines)
    end
    vim.notify(message)
  end
end

function M.append_review(note)
  local file_path = current_file_path()
  if not file_path then
    return
  end

  note = normalize_note(note)
  if note == '' then
    vim.notify('Review note cannot be empty', vim.log.levels.ERROR)
    return
  end

  local line_number = vim.api.nvim_win_get_cursor(0)[1]
  local entry = string.format('%s:%d: %s', relative_path(file_path), line_number, note)

  if vim.fn.writefile({ entry }, review_file(), 'a') ~= 0 then
    vim.notify('Failed to append review note to ' .. review_file(), vim.log.levels.ERROR)
    return
  end

  if state.loaded and state.root == cwd() then
    M.load_reviews({ notify = false, open = false })
  end

  vim.notify('Appended review note to ' .. review_file())
end

function M.reset_reviews(opts)
  opts = opts or {}

  if not opts.force then
    local choice = vim.fn.confirm('Reset review.md?', '&Yes\n&No', 2)
    if choice ~= 1 then
      return
    end
  end

  local file = review_file()
  if vim.fn.writefile({}, file) ~= 0 then
    vim.notify('Failed to reset ' .. file, vim.log.levels.ERROR)
    return
  end

  clear_state()
  clear_review_qflist_if_active()
  vim.notify('Reset ' .. file)
end

function M.setup()
  if state.setup then
    return
  end

  state.setup = true

  vim.api.nvim_set_hl(0, 'ReviewVirtualText', {
    default = true,
    link = 'Comment',
  })

  local group = vim.api.nvim_create_augroup('ReviewNvim', { clear = true })

  vim.api.nvim_create_autocmd('BufEnter', {
    group = group,
    callback = function(args)
      apply_virtual_text(args.buf)
    end,
  })

  vim.api.nvim_create_autocmd('DirChanged', {
    group = group,
    callback = function()
      clear_state()
      clear_review_qflist_if_active()
    end,
  })

  vim.api.nvim_create_user_command('Review', function(opts)
    if opts.args ~= '' then
      M.append_review(opts.args)
      return
    end

    vim.ui.input({ prompt = 'Review note: ' }, function(input)
      if input == nil then
        return
      end

      M.append_review(input)
    end)
  end, {
    desc = 'Append a review note to review.md',
    nargs = '*',
  })

  vim.api.nvim_create_user_command('ReviewLoad', function()
    M.load_reviews()
  end, {
    desc = 'Load review.md into quickfix and virtual text',
    nargs = 0,
  })

  vim.api.nvim_create_user_command('ReviewReset', function(opts)
    M.reset_reviews({ force = opts.bang })
  end, {
    bang = true,
    desc = 'Reset review.md for the current working directory',
    nargs = 0,
  })
end

return M
