local wezterm = require("wezterm")
local config = wezterm.config_builder()

local is_windows = wezterm.target_triple:find("windows")

local function append_table(t1, t2)
	for i = 1, #t2 do
		table.insert(t1, t2[i])
	end
	return t1
end

local function update_table(t1, t2)
	for k, v in pairs(t2) do
		t1[k] = v
	end
	return t1
end

config.disable_default_key_bindings = true
config.leader = { key = "s", mods = "CTRL", timeout_milliseconds = 1000 }

if is_windows then
	config.default_domain = "WSL:Ubuntu-22.04"
	config.color_scheme_dirs = { "C:\\Users\\lofgr\\wezterm\\color_schemes" }
end

config.color_scheme = "tokyonight_moon"
config.bold_brightens_ansi_colors = true
config.font_size = 14
config.window_close_confirmation = "NeverPrompt"
-- config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }

config.enable_kitty_graphics = true

-- performance
config.front_end = "WebGpu"
config.max_fps = 144
config.webgpu_power_preference = "HighPerformance"
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

-- keymaps
local prefix = "LEADER"

config.keys = {
	{ key = "r", mods = prefix, action = wezterm.action.ReloadConfiguration },
	{ key = "f", mods = prefix, action = wezterm.action.ToggleFullScreen },
	{
		key = "/",
		mods = prefix,
		action = wezterm.action.SplitPane({
			direction = "Right",
		}),
	},
	{
		key = "s",
		mods = prefix,
		action = wezterm.action.SplitPane({
			direction = "Down",
		}),
	},
	{ key = "c", mods = prefix, action = wezterm.action.SpawnTab("CurrentPaneDomain") },
	{ key = "n", mods = prefix, action = wezterm.action.ActivateTabRelative(1) },
	{ key = "p", mods = prefix, action = wezterm.action.ActivateTabRelative(-1) },
	{
		key = "t",
		mods = prefix,
		action = wezterm.action.PromptInputLine({
			description = "Rename Tab Title",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	{ key = "d", mods = prefix, action = wezterm.action.CloseCurrentPane({ confirm = false }) },
	{ key = ",", mods = prefix, action = wezterm.action.DecreaseFontSize },
	{ key = ".", mods = prefix, action = wezterm.action.IncreaseFontSize },
	{ key = "V", mods = "CTRL|SHIFT", action = wezterm.action.PasteFrom("Clipboard") },
	{ key = "x", mods = prefix, action = wezterm.action.ActivateCopyMode },
}

-- Simplified split navigation
-- For layouts like: term | nvim_split1 | nvim_split2
-- This will jump immediately from nvim_split2 to term
---@param mods string
---@param key string
---@param direction "Right" | "Left" | "Up" | "Down"
local function split_nav(mods, key, direction)
	local event = "SplitNav_" .. "move" .. "_" .. direction
	wezterm.on(event, function(win, pane)
		local orig_pane_id = pane:pane_id()
		-- try to move in the given direction
		win:perform_action({ ActivatePaneDirection = direction }, pane)
		-- check all panes, if the active pane hasn't changed we pass keys
		-- to the pane (neovim)
		local pane_info = pane:tab():panes_with_info()
		for _, info in ipairs(pane_info) do
			if info.is_active and info.pane:pane_id() == orig_pane_id then
				win:perform_action({ SendKey = { key = key, mods = "ALT" } }, pane)
				break
			end
		end
	end)
	return {
		key = key,
		mods = mods,
		action = wezterm.action.EmitEvent(event),
	}
end

local split_nav_keys = {
	split_nav(prefix, "h", "Left"),
	split_nav(prefix, "j", "Down"),
	split_nav(prefix, "k", "Up"),
	split_nav(prefix, "l", "Right"),
}

append_table(config.keys, split_nav_keys)

return config
