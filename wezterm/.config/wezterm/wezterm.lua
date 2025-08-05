local wezterm = require 'wezterm'
local act = wezterm.action
local mux = wezterm.mux

local dtsp_workspace = 'dtsp'

-- This table will hold the configuration.
local config = {}


local function dtsp_running()
  local names = mux.get_workspace_names()
  local found = false
  -- Iterate through the table
  for _, name in ipairs(names) do
    if name == "dtsp" then
      found = true
      break
    end
  end
  -- Send notification with result
  local message = found and "Found 'dtsp' in the names table!" or "'dtsp' not found in the names table."
  local command = {
    "dunstify",
    "-a", "WezTerm",
    "-u", "normal",
    "-t", "5000",
    "Check dtsp",
    message
  }
  wezterm.run_child_process(command)
  -- Return boolean
  return found
end


local function start_dtsp_session()
  local project_dir = '/home/o/code/dte/dtspv2/apps/v3/backend'
  local fe_dir = '/home/o/code/dte/fe/apps/v3/frontend'

  local t1, t1p1, window = mux.spawn_window {
    workspace = dtsp_workspace,
    cwd = project_dir,
  }

  -- Prepare tabs
  local t2, t2p1, _ = window:spawn_tab {
    cwd = project_dir .. '/apps/container',
  }
  local t3, t3p1, _ = window:spawn_tab {
    cwd = project_dir,
  }
  local t4, t4p1, _ = window:spawn_tab {
    cwd = fe_dir,
  }

  t1:set_title 'nvim'
  t2:set_title 'backend'
  t3:set_title 'lazygit'
  t4:set_title 'frontend'


  -- Set splits for backend services
  local t2p2 = t2p1:split {
    direction = 'Right',
    cwd = project_dir .. '/apps/satellite',
    --size = 0.333,
  }

  local t2p3 = t2p2:split {
    direction = 'Bottom',
    cwd = project_dir .. '/apps/gateway',
    --size = 0.666,
  }

  local t2p4 = t2p1:split {
    direction = 'Bottom',
    cwd = project_dir .. '/apps/identity',
  }

  -- Run commands in all panes
  t1p1:send_text 'nvim .\n'

  t2p1:send_text 'air\n'
  t2p2:send_text 'air\n'
  t2p3:send_text 'air\n'
  t2p4:send_text 'air\n'

  t3p1:send_text 'lazygit\n'

  t4p1:send_text 'npm run dev\n'

  -- Activate the window
  t1p1:activate()
  mux.set_active_workspace(dtsp_workspace)
end

local function create_session()
  if dtsp_running()
  then
    mux.set_active_workspace("dtsp")
  else
    start_dtsp_session()
  end
end

function kill_session(window, pane)
  local session_choices = {}
  local spaces = mux.get_workspace_names()
  for _, name in pairs(spaces) do
    table.insert(session_choices, { label = name })
  end
  wezterm.log_info(spaces)

  window:perform_action(
    act.InputSelector {
      action = wezterm.action_callback(function(inner_window, inner_pane, id, label)
        if not id and not label then
          wezterm.log_info 'cancelled'
        else
          wezterm.log_info(label)

          local success, stdout, stderr = wezterm.run_child_process { "ls" }
          wezterm.log_info(success)
          wezterm.log_info(stdout)
          wezterm.log_info(stderr)
        end
      end),
      title = 'Kill wezterm session',
      choices = session_choices,
      alphabet = '1234567',
      description = 'Write the number you want to choose or press / to search.',
    },
    pane
  )
end

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

wezterm.on('update-right-status', function(window, pane)
  window:set_right_status(window:active_workspace())
end)

--config.color_scheme = 'Catppuccin Mocha (Gogh)'
config.color_scheme = 'One Dark (Gogh)'
config.colors = {
  --   background = '#181b20',
  background = '#0f0f18', -- darker Catppuccin
  foreground = ' #a6a6a6',
}

config.audible_bell = "Disabled"
--config.font = wezterm.font('FiraCode Nerd Font', { weight = 'Thin' })
config.font = wezterm.font('IosevkaTerm Nerd Font', { weight = 'ExtraLight' })
--config.font = wezterm.font('JetBrains Mono', { weight = 'Thin' })
config.font_size = 10.5

config.window_decorations = "RESIZE"
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}
--config.line_height = 0.88
--config.line_height = 1.1
--config.cell_width = 0.9

-- Dim inactive panes
config.inactive_pane_hsb = {
  --hue = 5.0,        -- Keep hue unchanged
  saturation = 2,   -- Slightly desaturate for a faded effect
  brightness = 0.3, -- Reduce brightness to dim inactive panes
}

config.freetype_load_target = 'Normal'

config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 2000 }
config.keys = {
  { key = 'h',          mods = 'ALT',       action = act.ActivatePaneDirection 'Left' },
  { key = 'j',          mods = 'ALT',       action = act.ActivatePaneDirection 'Down' },
  { key = 'k',          mods = 'ALT',       action = act.ActivatePaneDirection 'Up' },
  { key = 'l',          mods = 'ALT',       action = act.ActivatePaneDirection 'Right' },
  { key = 's',          mods = 'LEADER',    action = act.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES' }, },
  { key = ']',          mods = 'ALT',       action = act.SwitchWorkspaceRelative(1) },
  { key = '[',          mods = 'ALT',       action = act.SwitchWorkspaceRelative(-1) },
  { mods = "LEADER",    key = "d",          action = wezterm.action_callback(create_session), },
  { mods = "LEADER",    key = "z",          action = act.TogglePaneZoomState },
  { mods = "LEADER",    key = "n",          action = act.ActivateTabRelative(1) },
  { mods = "LEADER",    key = "c",          action = act.SpawnTab "CurrentPaneDomain", },
  { mods = "LEADER",    key = "x",          action = act.CloseCurrentPane { confirm = true } },
  { mods = "LEADER",    key = "b",          action = act.ActivateTabRelative(-1) },
  { mods = "LEADER",    key = "n",          action = act.ActivateTabRelative(1) },
  { mods = "LEADER",    key = "v",          action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
  { mods = "LEADER",    key = "-",          action = act.SplitVertical { domain = "CurrentPaneDomain" } },
  { mods = "ALT|SHIFT", key = "LeftArrow",  action = act.AdjustPaneSize { "Left", 5 } },
  { mods = "ALT|SHIFT", key = "RightArrow", action = act.AdjustPaneSize { "Right", 5 } },
  { mods = "ALT|SHIFT", key = "DownArrow",  action = act.AdjustPaneSize { "Down", 5 } },
  { mods = "ALT|SHIFT", key = "UpArrow",    action = act.AdjustPaneSize { "Up", 5 } },
}

-- Mouse bindings configuration
config.mouse_bindings = {
  -- Disable the default single-click behavior for opening links
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "NONE",
    action = wezterm.action.DisableDefaultAssignment,
  },
  -- Ctrl+Click to open the link under the mouse cursor
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "CTRL",
    action = wezterm.action.OpenLinkAtMouseCursor,
  },
  -- Disable the Ctrl+Click down event to prevent programs from seeing it
  {
    event = { Down = { streak = 1, button = "Left" } },
    mods = "CTRL",
    action = wezterm.action.Nop,
  },
}
for i = 1, 9 do
  -- leader + number to activate that tab
  table.insert(config.keys, {
    key = tostring(i),
    mods = "LEADER",
    action = act.ActivateTab(i - 1),
  })
end

-- tab bar
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = false
config.use_fancy_tab_bar = false
config.tab_and_split_indices_are_zero_based = false

-- tmux status
wezterm.on("update-right-status", function(window, _)
  local SOLID_LEFT_ARROW = ""
  local ARROW_FOREGROUND = { Foreground = { Color = "#c6a0f6" } }
  local prefix = ""

  if window:leader_is_active() then
    prefix = " " .. utf8.char(0x1f30a) -- ocean wave
    SOLID_LEFT_ARROW = utf8.char(0xe0b2)
  end

  if window:active_tab():tab_id() ~= 0 then
    ARROW_FOREGROUND = { Foreground = { Color = "#1e2030" } }
  end -- arrow color based on if tab is first pane

  window:set_left_status(wezterm.format {
    { Background = { Color = "#b7bdf8" } },
    { Text = prefix },
    ARROW_FOREGROUND,
    { Text = SOLID_LEFT_ARROW }
  })
end)

-- and finally, return the configuration to wezterm
config.front_end = "WebGpu"
return config
