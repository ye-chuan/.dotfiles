vim.opt.showmode = false    -- Since we are already using airline to show the mode

require("lualine").setup {
  options = {
    icons_enabled = true,
    theme = "auto",
    component_separators = { left = "", right = ""},
    section_separators = { left = "", right = ""},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    always_show_tabline = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
      refresh_time = 16, -- ~60fps
      events = {
        "WinEnter",
        "BufEnter",
        "BufWritePost",
        "SessionLoadPost",
        "FileChangedShellPost",
        "VimResized",
        "Filetype",
        "CursorMoved",
        "CursorMovedI",
        "ModeChanged",
      },
    }
  },
  sections = {
    lualine_a = {
      {
        "mode",
        fmt = function(s)
          local mappings = {
            ["NORMAL"] = "󰦨",
            ["INSERT"] = "󰏫",
            ["VISUAL"] = "󰒉",
            ["V-BLOCK"] = "󰒆",
            ["V-LINE"] = "󰿚",
            ["COMMAND"] = "",
            ["REPLACE"] = "󰊀",
            ["TERMINAL"] = "",
          }
          if mappings[s] ~= nil then
              return mappings[s]
          end
          return s
        end
      }
    },
    lualine_b = {
      { "filetype", colored = false },
      {
        "lsp_status",
        show_name = false,
        icons_enabled=false,
        symbols = {
          -- Standard unicode symbols to cycle through for LSP progress:
          spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' },
          -- Standard unicode symbol for when LSP is done:
          done = '󰢻',
          -- Delimiter inserted between LSP names:
          separator = ' ',
        },
        -- This function is just to strip the leading space that seem to be stubbornly included
        fmt = function(s)
          return s:sub(2)
        end
      },
      { "diagnostics" },
    },
    lualine_c = {
      {
        "filename",
        path = 1,   -- Show relative path
        shorting_target = 49,   -- Space to leave after the filename (for other components)
        symbols = {
          modified = "●", -- '[+]',
          readonly = "", -- '[-]',
          unnamed = "[No Name]", -- '[No Name]',
          newfile = "", -- '[New]',
        }
      }
    },
    lualine_x = {},
    lualine_y = {
      { "encoding", show_bomb = true },
      { "fileformat" },
    },
    lualine_z = {
      {
        "location",
      },
      {
        "progress",
        fmt = function(s)
          local mappings = {
            ["Top"] = "󰹹󰛼 ",
            ["Bot"] = "󰹹󰛻 ",
          }
          if mappings[s] ~= nil then
              return mappings[s]
          end
          return s
        end
      },
    }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      {
        "filename",
        path = 1,   -- Show relative path
        shorting_target = 7,   -- Space to leave after the filename (for other components)
        symbols = {
          modified = "●", -- '[+]',
          readonly = "", -- '[-]',
          unnamed = "[No Name]", -- '[No Name]',
          newfile = "", -- '[New]',
        }
      }
    },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {
    lualine_a = {
      {
        "buffers",
        show_filename_only = false,
        mode = 4,
        max_length = vim.o.columns,
        symbols = {
          modified = " ●",
          alternate_file = "",
          directory = "",
        },
        -- NOTE: Kinda a workaround since the colouring seems off now when using the default "arrows"
        -- (Background coloured as white instead of transparent or at least black)
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
      }
    },
  },
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}

-- Default
--require('lualine').setup {
--  options = {
--    icons_enabled = true,
--    theme = 'auto',
--    component_separators = { left = '', right = ''},
--    section_separators = { left = '', right = ''},
--    disabled_filetypes = {
--      statusline = {},
--      winbar = {},
--    },
--    ignore_focus = {},
--    always_divide_middle = true,
--    always_show_tabline = true,
--    globalstatus = false,
--    refresh = {
--      statusline = 1000,
--      tabline = 1000,
--      winbar = 1000,
--      refresh_time = 16, -- ~60fps
--      events = {
--        'WinEnter',
--        'BufEnter',
--        'BufWritePost',
--        'SessionLoadPost',
--        'FileChangedShellPost',
--        'VimResized',
--        'Filetype',
--        'CursorMoved',
--        'CursorMovedI',
--        'ModeChanged',
--      },
--    }
--  },
--  sections = {
--    lualine_a = {'mode'},
--    lualine_b = {'branch', 'diff', 'diagnostics'},
--    lualine_c = {'filename'},
--    lualine_x = {'encoding', 'fileformat', 'filetype'},
--    lualine_y = {'progress'},
--    lualine_z = {'location'}
--  },
--  inactive_sections = {
--    lualine_a = {},
--    lualine_b = {},
--    lualine_c = {'filename'},
--    lualine_x = {'location'},
--    lualine_y = {},
--    lualine_z = {}
--  },
--  tabline = {},
--  winbar = {},
--  inactive_winbar = {},
--  extensions = {}
--}
