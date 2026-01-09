return {
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()
      require('mini.indentscope').setup {
        draw = {
          delay = 25,
          animation = require('mini.indentscope').gen_animation.quadratic {
            easing = 'out',
            duration = 25,
            unit = 'total',
          },
        },
        symbol = '│',
        options = { try_as_border = true },
      }

      -- require('mini.statusline').setup()
      -- statusline.setup { use_icons = vim.g.have_nerd_font }
      -- ---@diagnostic disable-next-line: duplicate-set-field
      -- statusline.section_location = function()
      -- return '%2l:%-2v'
      -- end
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
