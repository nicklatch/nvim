return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
      require('catppuccin').setup {
        flavour = 'mocha', -- Options: "latte", "macchiato", "frappe", "mocha"
        integrations = {
          gitsigns = { enabled = true },
          harpoon = true,
          mason = true,
          render_markdown = true,
          telescope = { enabled = true },
          which_key = true,
          indent_blankline = {
            colored_indent_levels = true,
            enabled = true,
          },
          blink_cmp = { style = 'bordered' },
          dap_ui = true,
          dap = true,
          neotree = true,
        },
      }
      -- vim.cmd.colorscheme 'catppuccin'
    end,
  },
}
