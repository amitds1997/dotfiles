local wezterm = require('wezterm')
local act = wezterm.action

local CtrlShiftMod = 'CTRL|SHIFT'
local SuperShiftMod = 'SUPER|SHIFT'
local CtrlMod = 'CTRL'

-- Show which key table is active in the status area
wezterm.on('update-right-status', function(window, _)
  local name = window:active_key_table()
  if name then
    name = 'TABLE: ' .. name
  end
  window:set_right_status(name or '')
end)

local key_tables = {
  -- Defines the keys that are active in our resize-pane mode.
  -- Since we're likely to want to make multiple adjustments,
  -- we made the activation one_shot=false. We therefore need
  -- to define a key assignment for getting out of this mode.
  -- 'resize_pane' here corresponds to the name="resize_pane" in
  -- the key assignments.
  resize_pane = {
    { key = 'h',          action = act.AdjustPaneSize { 'Left', 1 } },
    { key = 'l',          action = act.AdjustPaneSize { 'Right', 1 } },
    { key = 'k',          action = act.AdjustPaneSize { 'Up', 1 } },
    { key = 'j',          action = act.AdjustPaneSize { 'Down', 1 } },

    -- Cancel the mode by pressing escape
    { key = 'Escape',     action = 'PopKeyTable' },
  },
}

local keys = {
  {
    key = 'r',
    mods = CtrlShiftMod,
    action = act.ActivateKeyTable {
      name = 'resize_pane',
      one_shot = false,
    }
  },
  -- Switch active pane
  { key = 'h', mods = CtrlShiftMod, action = act.ActivatePaneDirection 'Left' },
  { key = 'l', mods = CtrlShiftMod, action = act.ActivatePaneDirection 'Right' },
  { key = 'k', mods = CtrlShiftMod, action = act.ActivatePaneDirection 'Up' },
  { key = 'j', mods = CtrlShiftMod, action = act.ActivatePaneDirection 'Down' },
  { -- Toogle b/w pane acquiring all available space vs split arrangement.
    key = ';',
    mods = CtrlShiftMod,
    action = act.TogglePaneZoomState,
  },
  { -- Split to the right
    key = 'Enter',
    mods = CtrlMod,
    action = act.SplitHorizontal { domain = 'CurrentPaneDomain' }
  },
  { -- Split into an additional pane below
    key = 'Enter',
    mods = CtrlShiftMod,
    action = act.SplitVertical { domain = 'CurrentPaneDomain' }
  },
  {
    key = '[',
    mods = CtrlShiftMod,
    action = act.RotatePanes 'Clockwise',
  },
  {
    key = ']',
    mods = CtrlShiftMod,
    action = act.RotatePanes 'CounterClockwise',
  },
  { -- Show debug overlay
    key = 'l',
    mods = SuperShiftMod,
    action = act.ShowDebugOverlay,
  },
}

return { keys = keys, key_tables = key_tables }
