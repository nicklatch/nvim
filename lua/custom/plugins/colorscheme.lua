return {
  {
    'EdenEast/nightfox.nvim',
    config = function()
      require('nightfox').setup {
        options = {
          modules = {
            neotree = true,
            telescope = true,
            rainbow_delimiters = true,
            whichkey = true,
          },
        },
      }
      vim.cmd.colorscheme 'carbonfox'
    end,
  },
  -- {
  --   'navarasu/onedark.nvim',
  --   priority = 1000, -- make sure to load this before all the other start plugins
  --   config = function()
  --     require('onedark').setup {
  --       style = 'darker',
  --     }
  --     -- require('onedark').load()
  --     -- vim.cmd.colorscheme 'onedark'
  --   end,
  -- },
  -- {
  --   'datsfilipe/vesper.nvim',
  --   config = function()
  --     require('vesper').setup {}
  --     vim.cmd.colorscheme 'vesper'
  --   end,
  -- },
  -- {
  --   -- https://github.com/catppuccin/nvim
  --   'catppuccin/nvim',
  --   name = 'catppuccin',
  --   priority = 1000,
  --   config = function()
  --     require('catppuccin').setup {
  --       flavour = 'mocha', -- Options: "latte", "macchiato", "frappe", "mocha"
  --       integrations = {
  --         blink_cmp = { style = 'bordered' },
  --         dap_ui = true,
  --         dap = true,
  --         gitsigns = { enabled = true },
  --         harpoon = true,
  --         neotree = true,
  --         mason = true,
  --         mini = { enabled = true, indentscope_color = 'lavender' },
  --         render_markdown = true,
  --         telescope = { enabled = true },
  --         which_key = true,
  --         indent_blankline = {
  --           colored_indent_levels = true,
  --           enabled = true,
  --         },
  --         rainbow_delimiters = true,
  --       },
  --     }
  --     vim.cmd.colorscheme 'catppuccin'
  --   end,
  -- },
}
