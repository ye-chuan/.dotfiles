-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.check_for_updates_interval_seconds = 86400   -- Check for update only once a day
config.color_scheme = "Catppuccin Mocha"
config.enable_tab_bar = false
-- config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false -- Use native tabs instead of ascii tabs
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

-- Keymaps
config.disable_default_key_bindings = true
config.leader = { key = "\\", mods = "CTRL", timeout_milliseconds = 1000 }  -- Will be used for multiplexing like tmux
config.keys = {
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
        mods = "ALT",
        action = wezterm.action.ToggleFullScreen,
    },
    -- Visuals
    {
        key = "-",
        mods = "CTRL",
        action = wezterm.action.DecreaseFontSize,
    },
    {
        key = "=",
        mods = "CTRL",
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
        key = "p",
        mods = "CTRL|SHIFT",
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
        key = "v",
        mods = "LEADER",
        action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
    },
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
        key = "Backspace",
        mods = "LEADER",
        action = wezterm.action.ActivateLastTab,
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
    {
        key = "!",
        mods = "LEADER|SHIFT",
        action = wezterm.action_callback(function(win, pane)    -- action_callback helps create an event and hook it to this a callback with `wezterm.on(event_name, callback)`
            local tab, window = pane:move_to_new_tab()
            tab:activate()
        end),
    },
    {
        key = "z",
        mods = "LEADER",
        action = wezterm.action.TogglePaneZoomState,
    },
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
    -- Navigation
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

-- and finally, return the configuration to wezterm
return config
