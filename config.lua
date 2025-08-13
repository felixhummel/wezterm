---@diagnostic disable: lowercase-global
local wezterm = require("wezterm") --[[@as Wezterm]]
local scheme_switcher = require("scheme_switcher")

local config = wezterm.config_builder()

config.check_for_updates = false
config.font_size = 11
config.adjust_window_size_when_changing_font_size = false
-- `Pro` oder `Tango (terminal.sexy)` - letzteres kommt am nächsten an mein xfce4-terminal theme ran, hat aber muted FG auf hellem BG
config.color_scheme = "Phrak1 (terminal.sexy)"
config.tab_bar_at_bottom = true
config.window_decorations = "NONE"

local function map(mods, key, action)
	return { mods = mods, key = key, action = action }
end
local act = wezterm.action
-- :vnew | read !wezterm show-keys --lua
config.keys = {
	map("SUPER", "[", scheme_switcher.prev_scheme),
	map("SUPER", "]", scheme_switcher.next_scheme),
	map("CTRL", "Escape", act.ShowDebugOverlay),
	map("CTRL|SHIFT", "n", act.SpawnTab("CurrentPaneDomain")),
	map("CTRL|ALT", "Z", act.TogglePaneZoomState),
	map("CTRL|ALT", "q", act.CloseCurrentTab({ confirm = true })),
	map("SHIFT", "LeftArrow", act.ActivateTabRelative(-1)),
	map("SHIFT", "RightArrow", act.ActivateTabRelative(1)),
	map("CTRL|SHIFT", "LeftArrow", act.MoveTabRelative(-1)),
	map("CTRL|SHIFT", "RightArrow", act.MoveTabRelative(1)),
	map("CTRL|SHIFT", "Insert", act.PasteFrom("Clipboard")),
	{
		key = "r",
		mods = "CTRL|SHIFT",
		action = wezterm.action.PromptInputLine({
			description = "Enter new tab title",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
}
return config
