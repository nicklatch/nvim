-- Mmmmm, snacks. | https://github.com/folke/snacks.nvim/tree/main
return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    scratch = {},
    lazygit = {},
    input = {},
    indent = {
      enabled = true,
      animate = {
        duration = {
          step = 10,
          total = 250,
        },
      },
    },
    -- Docs: https://github.com/folke/snacks.nvim/blob/main/docs/picker.md | :h snacks-picker
    picker = {
      win = {
        input = {
          keys = {
            ['<c-s>'] = false,
            ['<c-h>'] = { 'edit_split', mode = { 'i', 'n' } },
          },
        },
      },
      hidden = true,
      ignored = true,
      ui_select = true,
      layout = {
        layout = {
          backdrop = false,
        },
      },
      sources = {
        lsp_symbols = {
          layout = { preset = 'sidebar', layout = { position = 'right' } },
        },
        commands = {
          layout = {
            preset = 'select',
          },
        },
        explorer = {
          auto_close = true,
          layout = {
            preset = 'sidebar',
            preview = true,
          },
        },
        lines = {
          layout = {
            preset = 'ivy',
            preview = true,
          },
        },
        buffers = {
          layout = {
            preset = 'select',
          },
        },
        help = {
          layout = {
            preset = 'ivy',
          },
        },
        keys = {
          layout = {
            preset = 'select',
          },
        },
      },
    },
    explorer = {
      replace_netrw = true,
      trash = true,
    },
  },
  keys = {
    {
      '<leader>tt',
      function()
        Snacks.terminal(nil, {
          win = {
            position = 'float',
            width = 0.8,
            height = 0.6,
            border = 'rounded',
            wo = {
              winhighlight = 'Normal:NormalFloat,FloatBorder:FloatBorder',
            },
          },
          keys = {
            q = 'close',
          },
          enter = true,
        })
      end,
      desc = '[T]oggle a floating [t]erminal',
    },
    {
      '<leader>tj',
      function()
        Snacks.terminal('jiratui ui', {
          win = {
            position = 'float',
            width = 0.9,
            height = 0.9,
            border = 'rounded',
            wo = {
              winhighlight = 'Normal:NormalFloat,FloatBorder:FloatBorder',
            },
          },
          keys = {
            q = 'close',
          },
          enter = true,
        })
      end,
      desc = 'Open Jira TUI',
    },
    {
      '<leader>tsb',
      function()
        Snacks.scratch()
      end,
      desc = 'Toggle Scratch Buffer',
    },
    {
      '<leader>tss',
      function()
        Snacks.scratch.select()
      end,
      desc = 'Select Scratch Buffer',
    },
    {
      '<leader>lg',
      function()
        Snacks.lazygit.open()
      end,
      desc = 'Lazygit',
    },
    {
      '\\',
      function()
        Snacks.explorer()
      end,
      desc = 'File Explorer',
    },
    -- Search keymaps --
    {
      '<leader>sl',
      function()
        Snacks.picker.lsp_config()
      end,
      desc = '[S]earch [L]SP Config',
    },
    {
      '<leader>st',
      function()
        Snacks.picker.todo_comments { keywords = { 'TODO', 'FIX', 'FIXME' } }
      end,
      desc = 'Todo/Fix/Fixme',
    },
    {
      '<leader>sq',
      function()
        Snacks.picker.qflist()
      end,
      desc = 'Quickfix List',
    },
    {
      '<leader>ss',
      function()
        Snacks.picker.pickers()
      end,
      desc = 'Search Pickers',
    },
    {
      '<leader>sf',
      function()
        Snacks.picker.smart()
      end,
      desc = 'Smart Find [F]iles',
    },
    {
      '<leader>sg',
      function()
        Snacks.picker.grep()
      end,
      desc = '[S]earch [G]rep',
    },
    {
      '<leader>sC',
      function()
        Snacks.picker.command_history()
      end,
      desc = '[S]earch [C]ommand History',
    },
    {
      '<leader>sc',
      function()
        Snacks.picker.commands()
      end,
      desc = '[S]earch [C]ommands',
    },
    {
      '<leader>sr',
      function()
        Snacks.picker.recent()
      end,
      desc = '[S]earch [R]ecent',
    },
    {
      '<leader>sR',
      function()
        Snacks.picker.resume()
      end,
      desc = '[S]earch [R]esume',
    },
    {
      '<leader>sm',
      function()
        Snacks.picker.marks()
      end,
      desc = 'Marks',
    },
    {
      '<leader>/',
      function()
        Snacks.picker.lines()
      end,
      desc = 'Search Buffer Lines',
    },
    {
      '<leader>sh',
      function()
        Snacks.picker.help()
      end,
      desc = 'Help Pages',
    },
    {
      '<leader>sw',
      function()
        Snacks.picker.grep_word()
      end,
      desc = 'Visual selection or word',
      mode = { 'n', 'x' },
    },
    {
      '<leader>sd',
      function()
        Snacks.picker.diagnostics_buffer()
      end,
      desc = 'Buffer Diagnostics',
    },
    {
      '<leader><leader>',
      function()
        Snacks.picker.buffers()
      end,
      desc = 'Buffers',
    },
    {
      '<leader>sk',
      function()
        Snacks.picker.keymaps()
      end,
      desc = 'Keymaps',
    },
    -- LSP things --
    {
      'grd',
      function()
        Snacks.picker.lsp_definitions()
      end,
      desc = 'Goto Definition',
    },
    {
      'grD',
      function()
        Snacks.picker.lsp_declarations()
      end,
      desc = 'Goto Declaration',
    },
    {
      'grr',
      function()
        Snacks.picker.lsp_references()
      end,
      nowait = true,
      desc = 'References',
    },
    {
      'gri',
      function()
        Snacks.picker.lsp_implementations()
      end,
      desc = 'Goto Implementation',
    },
    {
      'grt',
      function()
        Snacks.picker.lsp_type_definitions()
      end,
      desc = 'Goto T[y]pe Definition',
    },
    {
      'gO',
      function()
        Snacks.picker.lsp_symbols()
      end,
      desc = 'LSP Symbols',
    },
    {
      'gW',
      function()
        Snacks.picker.lsp_workspace_symbols()
      end,
      desc = 'LSP Workspace Symbols',
    },
  },
}
