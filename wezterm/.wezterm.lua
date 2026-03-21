local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local is_windows = wezterm.target_triple:find('windows') ~= nil
local is_macos = wezterm.target_triple:find('apple') ~= nil

-- Font
config.font = wezterm.font('JetBrainsMono Nerd Font', { weight = 'Regular' })
config.font_size = is_macos and 14.0 or 10.0

-- Shell
if is_windows then
  config.default_prog = { 'pwsh', '-NoLogo' }
elseif is_macos then
  config.default_prog = { '/bin/zsh', '-l' }
end

-- Window
config.window_close_confirmation = 'NeverPrompt'
config.window_padding = { left = 10, right = 10, top = 8, bottom = 8 }
config.initial_cols = 220
config.initial_rows = 55

if is_windows then
  config.window_background_opacity = 0.72
  config.win32_system_backdrop = 'Acrylic'
  config.window_decorations = 'INTEGRATED_BUTTONS | RESIZE'
  config.integrated_title_button_style = 'Windows'
  config.integrated_title_buttons = { 'Hide', 'Maximize', 'Close' }
elseif is_macos then
  config.window_background_opacity = 0.85
  config.macos_window_background_blur = 20
  config.window_decorations = 'RESIZE'
end

config.window_frame = {
  font = wezterm.font('JetBrainsMono Nerd Font', { weight = 'Bold' }),
  font_size = is_macos and 13.0 or 10.0,
  active_titlebar_bg = '#2b2b2b',
  inactive_titlebar_bg = '#2b2b2b',
  active_titlebar_fg = '#c8bfb0',
  inactive_titlebar_fg = '#8a8278',
  active_titlebar_border_bottom = '#2b2b2b',
  inactive_titlebar_border_bottom = '#2b2b2b',
  button_fg = '#c8bfb0',
  button_bg = '#2b2b2b',
  button_hover_fg = '#ddd5c8',
  button_hover_bg = '#383838',
}

-- Tab bar
config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = false
config.hide_tab_bar_if_only_one_tab = false
config.tab_max_width = 40

-- Colors — Earthtone on graphite
config.colors = {
  foreground = '#d5cdc0',
  background = '#2b2b2b',
  cursor_bg = '#d4b07a',
  cursor_fg = '#2b2b2b',
  cursor_border = '#d4b07a',

  -- Earthtone ANSI palette (tan, cream, maroon, moss, navy)
  ansi = {
    '#3c3836', -- black   (warm charcoal)
    '#b85060', -- red     (maroon)
    '#8aaa78', -- green   (moss)
    '#daba84', -- yellow  (tan/camel)
    '#6a90aa', -- blue    (navy slate)
    '#b08090', -- magenta (dusty berry)
    '#78b098', -- cyan    (sage green)
    '#d5cdc0', -- white   (cream)
  },
  brights = {
    '#5a524a', -- bright black   (warm grey)
    '#d07080', -- bright red     (rosewood)
    '#a0c490', -- bright green   (light moss)
    '#e8d4a4', -- bright yellow  (beige)
    '#8aaac8', -- bright blue    (brighter navy)
    '#c898a8', -- bright magenta (mauve rose)
    '#90c8b0', -- bright cyan    (seafoam)
    '#e8e0d4', -- bright white   (warm cream)
  },

  tab_bar = {
    background = '#2b2b2b',
    active_tab = { bg_color = '#383838', fg_color = '#ddd5c8' },
    inactive_tab = { bg_color = '#2b2b2b', fg_color = '#8a8278' },
    inactive_tab_hover = { bg_color = '#383838', fg_color = '#c8bfb0' },
    new_tab = { bg_color = '#2b2b2b', fg_color = '#8a8278' },
    new_tab_hover = { bg_color = '#383838', fg_color = '#c8bfb0' },
  },
}

-- Cursor
config.default_cursor_style = 'SteadyBar'
config.cursor_blink_rate = 0

-- Panes
config.inactive_pane_hsb = { saturation = 0.9, brightness = 0.75 }

-- Keys
local act = wezterm.action
config.keys = {
  { key = '\\', mods = 'CTRL|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '-',  mods = 'CTRL|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = 'h',  mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Left' },
  { key = 'l',  mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Right' },
  { key = 'k',  mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Up' },
  { key = 'j',  mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Down' },
  { key = 't',  mods = 'CTRL|SHIFT', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'w',  mods = 'CTRL|SHIFT', action = act.CloseCurrentTab { confirm = true } },
  { key = '[',  mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(-1) },
  { key = ']',  mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(1) },
  { key = 'z',  mods = 'CTRL|SHIFT', action = act.TogglePaneZoomState },
  { key = 'c',  mods = 'CTRL|SHIFT', action = act.CopyTo 'Clipboard' },
  { key = 'v',  mods = 'CTRL|SHIFT', action = act.PasteFrom 'Clipboard' },
  { key = '=',  mods = 'CTRL', action = act.IncreaseFontSize },
  { key = '-',  mods = 'CTRL', action = act.DecreaseFontSize },
  { key = '0',  mods = 'CTRL', action = act.ResetFontSize },
}

-- Windows-only: WSL tab shortcut
if is_windows then
  table.insert(config.keys, {
    key = 'u', mods = 'CTRL|SHIFT',
    action = act.SpawnCommandInNewTab { args = { 'wsl.exe', '-d', 'Ubuntu' } },
  })
  config.launch_menu = {
    { label = 'PowerShell', args = { 'pwsh', '-NoLogo' } },
    { label = 'WSL Ubuntu',  args = { 'wsl.exe', '-d', 'Ubuntu' } },
  }
end

-- Misc
config.scrollback_lines = 10000
config.audible_bell = 'Disabled'
config.check_for_updates = false
config.enable_scroll_bar = false

return config
