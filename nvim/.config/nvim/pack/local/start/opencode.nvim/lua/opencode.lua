local M = {}

local defaults = {
  server_url = vim.env.OPENCODE_SERVER_URL or 'http://127.0.0.1:4096',
  authorization = vim.env.OPENCODE_SERVER_AUTHORIZATION,
  password = vim.env.OPENCODE_SERVER_PASSWORD,
  default_mode = 'build',
  curl_bin = 'curl',
  state_file = vim.fn.stdpath('state') .. '/opencode/sessions.json',
}

local state = {
  config = vim.deepcopy(defaults),
  loaded = false,
  data = {},
  setup = false,
}

local function notify(message, level)
  vim.notify(message, level or vim.log.levels.INFO, { title = 'opencode.nvim' })
end

local function normalize_path(path)
  return vim.fs.normalize(vim.fn.fnamemodify(path, ':p'))
end

local function current_directory()
  return normalize_path(vim.fn.getcwd())
end

local function current_project_root()
  local path = vim.api.nvim_buf_get_name(0)
  if path == '' then
    path = current_directory()
  else
    path = normalize_path(path)
  end

  local root = vim.fs.root(path, { '.git' })
  return normalize_path(root or current_directory())
end

local function relative_to_root(path, root)
  path = normalize_path(path)
  root = normalize_path(root)
  if path == root then
    return '.'
  end

  local prefix = root .. '/'
  if vim.startswith(path, prefix) then
    return path:sub(#prefix + 1)
  end

  return vim.fn.fnamemodify(path, ':.')
end

local function short_session_title(session)
  if not session then
    return ''
  end

  local title = vim.trim(session.title or '')
  if title ~= '' then
    return title
  end

  return session.id or ''
end

local function shorten(text, max_length)
  if #text <= max_length then
    return text
  end

  return text:sub(1, max_length - 3) .. '...'
end

local function load_state()
  if state.loaded then
    return
  end

  state.loaded = true
  state.data = {}

  if vim.fn.filereadable(state.config.state_file) == 0 then
    return
  end

  local lines = vim.fn.readfile(state.config.state_file)
  if vim.tbl_isempty(lines) then
    return
  end

  local ok, decoded = pcall(vim.json.decode, table.concat(lines, '\n'))
  if not ok or type(decoded) ~= 'table' then
    notify('Failed to parse persisted opencode session state', vim.log.levels.WARN)
    return
  end

  state.data = decoded
end

local function save_state()
  load_state()
  vim.fn.mkdir(vim.fn.fnamemodify(state.config.state_file, ':h'), 'p')

  local ok, encoded = pcall(vim.json.encode, state.data)
  if not ok then
    notify('Failed to encode opencode session state', vim.log.levels.ERROR)
    return
  end

  if vim.fn.writefile({ encoded }, state.config.state_file) ~= 0 then
    notify('Failed to persist opencode session state', vim.log.levels.ERROR)
  end
end

local function redraw_statusline()
  vim.cmd('redrawstatus')
end

local function active_entry()
  load_state()
  return state.data[current_project_root()]
end

local function ensure_entry()
  load_state()

  local root = current_project_root()
  state.data[root] = state.data[root] or {
    mode = state.config.default_mode,
  }

  return state.data[root]
end

local function active_session()
  local entry = active_entry()
  return entry and entry.session or nil
end

local function active_mode()
  local entry = active_entry()
  if entry and (entry.mode == 'plan' or entry.mode == 'build') then
    return entry.mode
  end

  return state.config.default_mode
end

local function set_mode(mode)
  local entry = ensure_entry()
  entry.mode = mode
  save_state()
  redraw_statusline()
end

local function set_active_session(session)
  local entry = ensure_entry()
  entry.session = {
    id = session.id,
    title = session.title,
    directory = normalize_path(session.directory or current_directory()),
  }
  entry.mode = entry.mode or state.config.default_mode
  save_state()
  redraw_statusline()
end

local function clear_active_session()
  local root = current_project_root()
  local entry = active_entry()
  if not entry then
    return
  end

  entry.session = nil
  if entry.mode == nil then
    state.data[root] = nil
  end

  save_state()
  redraw_statusline()
end

local function authorization_header()
  if state.config.authorization and state.config.authorization ~= '' then
    return state.config.authorization
  end

  if not state.config.password or state.config.password == '' then
    return nil
  end

  return 'Basic ' .. vim.base64.encode(':' .. state.config.password)
end

local function build_url(path, query)
  local url = state.config.server_url:gsub('/+$', '') .. path
  if not query or vim.tbl_isempty(query) then
    return url
  end

  local items = {}
  for key, value in pairs(query) do
    if value ~= nil then
      table.insert(items, vim.uri_encode(key) .. '=' .. vim.uri_encode(tostring(value)))
    end
  end

  table.sort(items)
  if vim.tbl_isempty(items) then
    return url
  end

  return url .. '?' .. table.concat(items, '&')
end

local function split_status(stdout)
  local marker = '\n__OPENCODE_STATUS__:'
  local index = stdout:find(marker, 1, true)
  while index do
    local next_index = stdout:find(marker, index + 1, true)
    if not next_index then
      local body = stdout:sub(1, index - 1)
      local status = tonumber(vim.trim(stdout:sub(index + #marker)))
      return body, status
    end
    index = next_index
  end

  if vim.startswith(stdout, '__OPENCODE_STATUS__:') then
    return '', tonumber(vim.trim(stdout:sub(20)))
  end

  return stdout, nil
end

local function decode_json(raw)
  if raw == '' then
    return true
  end

  local ok, decoded = pcall(vim.json.decode, raw)
  if not ok then
    return nil, 'Failed to parse server response'
  end

  return decoded
end

local function request(method, path, opts)
  opts = opts or {}

  local cmd = {
    state.config.curl_bin,
    '--silent',
    '--show-error',
    '--request', method,
    '--header', 'Accept: application/json',
    '--write-out', '\n__OPENCODE_STATUS__:%{http_code}',
  }

  local auth = authorization_header()
  if auth then
    table.insert(cmd, '--header')
    table.insert(cmd, 'Authorization: ' .. auth)
  end

  if opts.body ~= nil then
    table.insert(cmd, '--header')
    table.insert(cmd, 'Content-Type: application/json')
    table.insert(cmd, '--data-binary')
    table.insert(cmd, vim.json.encode(opts.body))
  end

  table.insert(cmd, build_url(path, opts.query))

  local result = vim.system(cmd, { text = true }):wait()
  if result.code ~= 0 then
    local stderr = vim.trim(result.stderr or '')
    return nil, stderr ~= '' and stderr or 'Failed to reach opencode server'
  end

  local raw_body, status = split_status(result.stdout or '')
  if not status then
    return nil, 'Failed to parse opencode response status'
  end

  if status >= 400 then
    local decoded = decode_json(raw_body)
    local message = raw_body
    if type(decoded) == 'table' then
      message = decoded.message or decoded.error or decoded.detail or raw_body
      if type(message) == 'table' then
        message = vim.inspect(message)
      end
    end

    message = vim.trim(tostring(message))
    if message == '' then
      message = 'HTTP ' .. status
    else
      message = 'HTTP ' .. status .. ': ' .. message
    end

    return nil, message, status
  end

  local decoded, decode_error = decode_json(raw_body)
  if decoded == nil then
    return nil, decode_error, status
  end

  return decoded, nil, status
end

local function current_file_path()
  local file_path = vim.api.nvim_buf_get_name(0)
  if file_path == '' then
    notify('Opencode prompt requires a file-backed buffer', vim.log.levels.ERROR)
    return nil
  end

  return normalize_path(file_path)
end

local function current_selection()
  local mode = vim.fn.mode()
  if not mode:match('[vV\22]') then
    return nil
  end

  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local lines = vim.fn.getregion(start_pos, end_pos, { type = mode })
  local start_line = math.min(start_pos[2], end_pos[2])
  local end_line = math.max(start_pos[2], end_pos[2])

  return {
    lines = lines,
    start_line = start_line,
    end_line = end_line,
  }
end

local function build_prompt_lines(selection)
  local file_path = current_file_path()
  if not file_path then
    return nil
  end

  local lines = {
    'File: ' .. relative_to_root(file_path, current_project_root()),
  }

  if selection then
    table.insert(lines, string.format('Lines: %d-%d', selection.start_line, selection.end_line))
    table.insert(lines, '')
    table.insert(lines, 'Selection Start')
    vim.list_extend(lines, selection.lines)
    table.insert(lines, 'Selection End')
  else
    local cursor = vim.api.nvim_win_get_cursor(0)
    table.insert(lines, 'Line: ' .. cursor[1])
    table.insert(lines, 'Column: ' .. (cursor[2] + 1))
  end

  table.insert(lines, '')
  table.insert(lines, 'Request:')
  table.insert(lines, '')

  return lines
end

local function prompt_has_request(lines)
  local marker = nil
  for index = #lines, 1, -1 do
    if vim.trim(lines[index]) == 'Request:' then
      marker = index
      break
    end
  end

  if not marker then
    return vim.trim(table.concat(lines, '\n')) ~= ''
  end

  for index = marker + 1, #lines do
    if vim.trim(lines[index]) ~= '' then
      return true
    end
  end

  return false
end

local function list_sessions()
  local sessions, err = request('GET', '/session', {
    query = {
      directory = current_directory(),
    },
  })
  if not sessions then
    return nil, err
  end

  local root = current_project_root()
  local filtered = {}
  for _, session in ipairs(sessions) do
    local directory = session.directory and normalize_path(session.directory) or ''
    if directory == root or vim.startswith(directory, root .. '/') then
      table.insert(filtered, session)
    end
  end

  table.sort(filtered, function(left, right)
    return (left.time and left.time.updated or 0) > (right.time and right.time.updated or 0)
  end)

  return filtered
end

local function create_session(callback)
  vim.ui.input({ prompt = 'New opencode session title (optional): ' }, function(input)
    if input == nil then
      return
    end

    local title = vim.trim(input)
    local session, err = request('POST', '/session', {
      query = {
        directory = current_directory(),
      },
      body = title == '' and {} or { title = title },
    })
    if not session then
      notify(err, vim.log.levels.ERROR)
      return
    end

    set_active_session(session)
    notify('Active opencode session: ' .. short_session_title(session))
    if callback then
      callback(session)
    end
  end)
end

local function pick_session(callback)
  local sessions, err = list_sessions()
  if not sessions then
    notify(err, vim.log.levels.ERROR)
    return
  end

  local current = active_session()
  local root = current_project_root()
  local items = {
    {
      kind = 'new',
      label = '+ Create new session',
    },
  }

  for _, session in ipairs(sessions) do
    local label = short_session_title(session)
    local relative_dir = relative_to_root(session.directory, root)
    if relative_dir ~= '.' then
      label = label .. ' [' .. relative_dir .. ']'
    end
    if current and current.id == session.id then
      label = '* ' .. label
    end

    table.insert(items, {
      kind = 'session',
      label = label,
      session = session,
    })
  end

  vim.ui.select(items, {
    prompt = 'Opencode session',
    format_item = function(item)
      return item.label
    end,
  }, function(choice)
    if not choice then
      return
    end

    if choice.kind == 'new' then
      create_session(callback)
      return
    end

    set_active_session(choice.session)
    notify('Active opencode session: ' .. short_session_title(choice.session))
    if callback then
      callback(choice.session)
    end
  end)
end

local function ensure_session(callback)
  local session = active_session()
  if session then
    callback(session)
    return
  end

  pick_session(callback)
end

local function submit_prompt(session, mode, text)
  return request('POST', '/session/' .. session.id .. '/prompt_async', {
    query = {
      directory = normalize_path(session.directory or current_directory()),
    },
    body = {
      agent = mode,
      parts = {
        {
          type = 'text',
          text = text,
        },
      },
    },
  })
end

local function prompt_title(mode)
  local session = active_session()
  local title = session and short_session_title(session) or 'no session'
  return string.format(' Opencode [%s] %s ', mode, shorten(title, 40))
end

local function open_prompt_window(lines)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].buftype = 'nofile'
  vim.bo[buf].bufhidden = 'wipe'
  vim.bo[buf].swapfile = false
  vim.bo[buf].filetype = 'markdown'

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  local width = math.min(math.max(70, math.floor(vim.o.columns * 0.72)), 120)
  local height = math.min(math.max(#lines + 2, 10), math.floor(vim.o.lines * 0.7))

  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    row = math.max(0, math.floor((vim.o.lines - height) / 2) - 1),
    col = math.floor((vim.o.columns - width) / 2),
    width = width,
    height = height,
    style = 'minimal',
    border = 'rounded',
    title = prompt_title(active_mode()),
    title_pos = 'center',
  })

  vim.wo[win].wrap = true
  vim.wo[win].linebreak = true

  return buf, win
end

function M.open_prompt()
  local selection = current_selection()
  local lines = build_prompt_lines(selection)
  if not lines then
    return
  end

  ensure_session(function(session)

    local buf, win = open_prompt_window(lines)
    local ctx = {
      buf = buf,
      win = win,
      mode = active_mode(),
    }

    local function close_prompt()
      if vim.api.nvim_win_is_valid(ctx.win) then
        vim.api.nvim_win_close(ctx.win, true)
      end
    end

    local function update_title()
      if not vim.api.nvim_win_is_valid(ctx.win) then
        return
      end

      local config = vim.api.nvim_win_get_config(ctx.win)
      config.title = prompt_title(ctx.mode)
      vim.api.nvim_win_set_config(ctx.win, config)
    end

    local function toggle_mode()
      ctx.mode = ctx.mode == 'plan' and 'build' or 'plan'
      set_mode(ctx.mode)
      update_title()
    end

    local function submit()
      local prompt_lines = vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)
      if not prompt_has_request(prompt_lines) then
        notify('Opencode request cannot be empty', vim.log.levels.ERROR)
        return
      end

      local _, err, status = submit_prompt(session, ctx.mode, table.concat(prompt_lines, '\n'))
      if err then
        if status == 404 then
          clear_active_session()
        end
        notify(err, vim.log.levels.ERROR)
        return
      end

      set_mode(ctx.mode)
      close_prompt()
      notify('Submitted ' .. ctx.mode .. ' prompt to ' .. short_session_title(session))
    end

    vim.keymap.set({ 'n', 'i' }, '<Tab>', toggle_mode, {
      buffer = ctx.buf,
      desc = 'Toggle opencode mode',
      silent = true,
    })
    vim.keymap.set({ 'n', 'i' }, '<C-s>', submit, {
      buffer = ctx.buf,
      desc = 'Submit opencode prompt',
      silent = true,
    })
    vim.keymap.set('n', '<Esc>', close_prompt, {
      buffer = ctx.buf,
      desc = 'Close opencode prompt',
      silent = true,
    })
    vim.keymap.set('n', 'q', close_prompt, {
      buffer = ctx.buf,
      desc = 'Close opencode prompt',
      silent = true,
    })

    vim.api.nvim_win_set_cursor(ctx.win, { #lines, 0 })
    vim.schedule(function()
      if vim.api.nvim_win_is_valid(ctx.win) then
        vim.cmd('startinsert')
      end
    end)
  end)
end

function M.pick_session()
  pick_session()
end

function M.clear_session()
  clear_active_session()
  notify('Cleared active opencode session')
end

function M.statusline()
  local session = active_session()
  if not session then
    return ''
  end

  local text = string.format('OC[%s] %s', active_mode(), shorten(short_session_title(session), 28))
  local escaped = text:gsub('%%', '%%%%')
  return escaped
end

function M.setup(opts)
  state.config = vim.tbl_deep_extend('force', state.config, opts or {})

  if state.setup then
    return
  end

  state.setup = true

  _G.OpencodeStatusline = function()
    return require('opencode').statusline()
  end

  vim.api.nvim_create_user_command('OpencodeSession', function()
    require('opencode').pick_session()
  end, {
    desc = 'Pick or create an opencode session',
    nargs = 0,
  })

  vim.api.nvim_create_user_command('OpencodePrompt', function()
    require('opencode').open_prompt()
  end, {
    desc = 'Open the opencode prompt float',
    nargs = 0,
  })

  vim.api.nvim_create_user_command('OpencodeClearSession', function()
    require('opencode').clear_session()
  end, {
    desc = 'Clear the active opencode session',
    nargs = 0,
  })

  vim.api.nvim_create_autocmd('DirChanged', {
    callback = redraw_statusline,
  })
end

return M
