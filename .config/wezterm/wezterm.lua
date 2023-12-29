-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.color_scheme = "Catppuccin Mocha"
config.hide_tab_bar_if_only_one_tab = true
-- config.use_fancy_tab_bar = false -- Use native tabs instead of ascii tabs
config.window_background_opacity = 0.85
config.text_background_opacity = 0.6
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
-- and finally, return the configuration to wezterm
return config
