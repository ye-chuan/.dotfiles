-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

if wezterm.target_triple == "x86_64-pc-windows-msvc" then   -- If running on Windows
    config.default_prog = { "powershell" }
else
    config.default_prog = { "bash" }
end

config.check_for_updates_interval_seconds = 86400   -- Check for update only once a day
config.font = wezterm.font_with_fallback {
    "JetBrains Mono",       -- Included in WezTerm itself
    "Noto Sans CJK SC",
    "Noto Sans CJK TC",
    "Noto Sans CJK JP",
    "Noto Sans CJK HK",
    "Noto Sans CJK KR",
}
config.color_scheme = "Catppuccin Mocha"
config.enable_tab_bar = false
-- config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false -- Use native tabs instead of ascii tabs
--config.window_decorations = "RESIZE"    -- Remove title bar
config.window_background_opacity = 0.9
config.scrollback_lines = 3500

config.set_environment_variables = {
  -- Environmental variables can be set directly in WezTerm here.
  -- e.g. cmd.exe uses the %PROMPT% environmental variable to decide
  -- what to use as the prompt.
  -- The $P $_ etc. special codes are described in `prompt /?`
  -- $E is the ESC character used to send escape sequences to the terminal
  -- Terminal text colours are set via a Control Sequence Introducer (CSI) sequence
  -- CSI sequences starts with `ESC [` encoded as `$E[` here.
  -- The final byte of a CSI sequence determines it's function, for graphic rendition
  -- we use `m` as the final byte, producing what is known as a Select Graphic Rendition
  -- (SGR) sequence.
  -- The format is in `ESC [ n m` (no spaces) where n (can span multiple bytes)
  -- decides the style of the characters that comes after (italics/colours/etc)
  -- If no `n` is given, the default of 0 will be assumed which will reset all style.
  -- e.g. `$E[4m` will underline the subsequent characters, until `$E[m`

  -- Here we are first emitting a OSC 7 (Operating System Command 7) sequence:
  -- `$E]7;file://localhost/$P$E\` ($E\) ends the path, the \ is escaped below as \\
  -- After which we then actually set the prompt as `$E[32m$T$E[0m $E[35m$P$E[36m$_$G$E[0m`
  -- We emit as OSC 7 as a way to communicate the current working directory with the terminal
  -- when the cwd changes (this is how WezTerm does it so that it can spawn new tabs in cwd)
  -- For modern shells in Linux systems this might be done automatically, but for cmd.exe we
  -- can configure this hacky way of emitting as OSC 7 everytime it prints the prompt.
  prompt = '$E]7;file://localhost/$P$E\\$E[32m$T$E[0m $E[35m$P$E[36m$_$G$E[0m ',
}

---- Keymaps
config.disable_default_key_bindings = true
-- This leader cannot be triggered (considered "off") as we will be mainly using tmux
-- To enable it we will use the `toggle-leader` event defined below
config.leader = { key = "\\", mods = "CTRL|SHIFT", timeout_milliseconds = 1000 }
config.keys = {
    -- Toggle the leader (e.g. for convenience when using tmux)
    {
        key = "b",
        mods = "CTRL|SHIFT",
        action = wezterm.action.EmitEvent("toggle-leader")
    },
    -- Forward the leader if pressed twice (doesn't work when leader is toggled away in our custom toggle event)
    {
        key = config.leader.key,
        mods = "LEADER|" .. config.leader.mods,
        action = wezterm.action.SendKey { key = config.leader.key, mods = config.leader.mods }
    },
    -- Clipboard
    {
        key = "c",
        mods = "CTRL|SHIFT",
        action = wezterm.action.CopyTo("Clipboard"),
    },
    {
        key = "v",
        mods = "CTRL|SHIFT",
        action = wezterm.action.PasteFrom("Clipboard"),
    },
    -- Window
    {
        key = "Enter",
        mods = "CTRL|SHIFT",
        action = wezterm.action.ToggleFullScreen,
    },
    -- Visuals
    {
        key = "_",
        mods = "CTRL|SHIFT",
        action = wezterm.action.DecreaseFontSize,
    },
    {
        key = "+",
        mods = "CTRL|SHIFT",
        action = wezterm.action.IncreaseFontSize,
    },
    -- Scroll
    {
        key = "u",
        mods = "CTRL|SHIFT",
        action = wezterm.action.ScrollByPage(-0.5),
    },
    {
        key = "d",
        mods = "CTRL|SHIFT",
        action = wezterm.action.ScrollByPage(0.5),
    },
    {
        key = "y",
        mods = "CTRL|SHIFT",
        action = wezterm.action.ScrollByLine(-1),
    },
    {
        key = "e",
        mods = "CTRL|SHIFT",
        action = wezterm.action.ScrollByLine(1),
    },
    {
        key = "g",
        mods = "CTRL|SHIFT",
        action = wezterm.action.ScrollToTop,
    },
    -- Text
    {
        key = "[",
        mods = "LEADER|CTRL",
        action = wezterm.action.ActivateCopyMode,
    },
    {
        key = "Space",
        mods = "CTRL|SHIFT",
        action = wezterm.action.QuickSelect,
    },
    {
        key = "?",
        mods = "CTRL|SHIFT",
        action = wezterm.action.Search("CurrentSelectionOrEmptyString"),
    },
    -- Others
    {
        key = ":",
        mods = "CTRL|SHIFT",
        action = wezterm.action.ActivateCommandPalette,
    },

    ---- Multiplexer (will use mappings very similar to tmux for easy transition next time)
    --- Panes
    {
        key = "s",  -- Apparently Vim and WezTerm has different definitions of split horizontal...
        mods = "LEADER",
        action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
    },
    {
        key = "s",
        mods = "LEADER|SHIFT",
        action = wezterm.action.SplitPane {
            top_level = true,
            direction = "Down",
            command = { domain = "CurrentPaneDomain" },
        },
    },
    {
        key = "v",
        mods = "LEADER",
        action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
    },
    {
        key = "v",
        mods = "LEADER|SHIFT",
        action = wezterm.action.SplitPane {
            top_level = true,
            direction = "Right",
            command = { domain = "CurrentPaneDomain" },
        },
    },
    {
        key = "!",
        mods = "LEADER|SHIFT",
        action = wezterm.action_callback(function(win, pane)    -- action_callback helps create an event and hook it to this a callback with `wezterm.on(event_name, callback)`
            local tab, window = pane:move_to_new_tab()
            tab:activate()
        end),
    },
    -- Pane Movement
    {
        key = "q",
        mods = "LEADER|CTRL",
        action = wezterm.action.PaneSelect({ mode = "SwapWithActive" }),
    },
    -- Pane Navigation
    {
        key = "h",
        mods = "LEADER",
        action = wezterm.action.ActivatePaneDirection("Left"),
    },
    {
        key = "l",
        mods = "LEADER",
        action = wezterm.action.ActivatePaneDirection("Right"),
    },
    {
        key = "j",
        mods = "LEADER",
        action = wezterm.action.ActivatePaneDirection("Down"),
    },
    {
        key = "k",
        mods = "LEADER",
        action = wezterm.action.ActivatePaneDirection("Up"),
    },
    {
        key = "q",
        mods = "LEADER",
        action = wezterm.action.PaneSelect({ mode = "Activate" }),
    },
    {
        key = "x",
        mods = "LEADER",
        action = wezterm.action.CloseCurrentPane({ confirm = true }),
        -- No confirmation for what WezTerm deems stateless (see `config.skip_close_confirmation_for_processes_named`)
    },
    -- Pane Resize
    {
        key = "LeftArrow",
        mods = "CTRL|SHIFT",
        action = wezterm.action.AdjustPaneSize({"Left", 1}),
    },
    {
        key = "RightArrow",
        mods = "CTRL|SHIFT",
        action = wezterm.action.AdjustPaneSize({"Right", 1}),
    },
    {
        key = "UpArrow",
        mods = "CTRL|SHIFT",
        action = wezterm.action.AdjustPaneSize({"Up", 1}),
    },
    {
        key = "DownArrow",
        mods = "CTRL|SHIFT",
        action = wezterm.action.AdjustPaneSize({"Down", 1}),
    },
    {
        key = "z",
        mods = "LEADER",
        action = wezterm.action.TogglePaneZoomState,
    },
    --- Tabs (tmux windows)
    {
        key = "c",
        mods = "LEADER",
        action = wezterm.action.SpawnTab( "CurrentPaneDomain" ),
    },
    {
        key = "&",
        mods = "LEADER|SHIFT",
        action = wezterm.action.CloseCurrentTab({ confirm = true }),
    },
    {
        key = ",",
        mods = "LEADER",
        action = wezterm.action.PromptInputLine({   -- Prompt for new name
            description = "Rename Tab",
            action = wezterm.action_callback(function(window, pane, line)
                if line then    -- If line is not `nil` (meaning didn't press ESC)
                    window:active_tab():set_title(line) -- If line is "" then default name will be used
                end
            end),
        }),
    },
    -- Tabs Navigation
    {
        key = "Backspace",
        mods = "LEADER",
        action = wezterm.action.ActivateLastTab,
    },
    {
        key = "w",
        mods = "LEADER",
        action = wezterm.action.ShowTabNavigator,
    },
    {
        key = "n",
        mods = "LEADER",
        action = wezterm.action.ActivateTabRelative(1),
    },
    {
        key = "p",
        mods = "LEADER",
        action = wezterm.action.ActivateTabRelative(-1),
    },
    { key = "1", mods = "LEADER", action = wezterm.action.ActivateTab(0) },
    { key = "2", mods = "LEADER", action = wezterm.action.ActivateTab(1) },
    { key = "3", mods = "LEADER", action = wezterm.action.ActivateTab(2) },
    { key = "4", mods = "LEADER", action = wezterm.action.ActivateTab(3) },
    { key = "5", mods = "LEADER", action = wezterm.action.ActivateTab(4) },
    { key = "6", mods = "LEADER", action = wezterm.action.ActivateTab(5) },
    { key = "7", mods = "LEADER", action = wezterm.action.ActivateTab(6) },
    { key = "8", mods = "LEADER", action = wezterm.action.ActivateTab(7) },
    { key = "9", mods = "LEADER", action = wezterm.action.ActivateTab(8) },
    { key = "0", mods = "LEADER", action = wezterm.action.ActivateTab(9) },
}


---- Events
-- Toggles WezTerm's Leader on/off ("off" technically means CTRL-SHIFT-\ which cannot be triggered)
wezterm.on("toggle-leader", function (window, pane)
    -- WezTerm has an `overrides` table that overrides config per-window during runtime
    local overrides = window:get_config_overrides() or {}

    if not overrides.leader then
        overrides.leader = { key = "\\", mods = "CTRL", timeout_milliseconds = 1000 }
        wezterm.log_info("LeafBoat> Toggled Leader to: " .. overrides.leader.mods .. "-" .. overrides.leader.key)
    else
        overrides.leader = nil
        wezterm.log_info("LeafBoat> Untoggled Leader back to: " .. config.leader.mods .. "-" .. config.leader.key)
    end

    window:set_config_overrides(overrides)
end)

-- Centers The Tab (i.e. group of panes) within the WezTerm Window
function center_tab(window, pane)
    -- Minimum padding on one horizontal/vertical side
    -- In cells (e.g. 1cell, 0.5cell)
    local MIN_HORIZONTAL_PADDING = 0.6
    local MIN_VERTICAL_PADDING = 0.29

    local override = window:get_config_overrides() or {}
    local new_padding = {}

    local win_dim = window:get_dimensions()
    local tab_dim = window:active_tab():get_size()

    -- A tab consists of just cells with no padding
    local cell_height = tab_dim.pixel_height / tab_dim.rows
    local cell_width = tab_dim.pixel_width / tab_dim.cols

    local gap_h = win_dim.pixel_width - tab_dim.pixel_width
    local gap_v = win_dim.pixel_height - tab_dim.pixel_height

    -- We fit as many cells as possible into the gaps,
    local remaining_h = gap_h % cell_width
    local remaining_v = gap_v % cell_height

    -- Satisfy the minimum padding by removing cell rows & cols
    local min_h_padding_px = MIN_HORIZONTAL_PADDING * cell_width
    local min_v_padding_px = MIN_VERTICAL_PADDING * cell_height
    remaining_h = remaining_h + cell_width*(
        math.ceil((min_h_padding_px*2-remaining_h)/cell_width)
    )
    remaining_v = remaining_v + cell_height*(
        math.ceil((min_v_padding_px*2-remaining_v)/cell_height)
    )

    -- Evenly distribute the gaps
    new_padding.left = remaining_h // 2
    new_padding.right = remaining_h - new_padding.left
    new_padding.top = remaining_v // 2
    new_padding.bottom = remaining_v - new_padding.top

    wezterm.log_info("LeafBoat> Centered Tab with:", new_padding)
    override.window_padding = new_padding
    window:set_config_overrides(override)
end
wezterm.on("window-resized", center_tab)

---- and finally, return the configuration to wezterm
return config
