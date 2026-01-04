-- NeoVim Specific Options (similar to sharedrc but NeoVim only)

vim.opt.winborder = "rounded"   -- Since v0.11: cleans a lot of the LSP handler-specific border configs with this global option

-- HACK: Since tmux < 3.2 do not support `load-buffer -w -` which emits OSC 52, we are temporarily having Neovim directly emit
-- OSC 52 sequence when in an SSH session (Neovim cannot auto-determine if terminal has support for OSC 52 if the terminal is tmux)
-- So we are assuming if using NeoVim in a SSH session that the terminal emulator has OSC 52 support.
if os.getenv("SSH_TTY") then    -- Very simple (not robust) check for SSH Session
    vim.g.clipboard = "osc52"
end
