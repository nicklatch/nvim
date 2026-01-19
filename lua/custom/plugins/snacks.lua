-- lazy.nvim
return {
  'folke/snacks.nvim',
  ---@type snacks.Config
  opts = {
    lazygit = {},
    dashboard = {},
  },
  keys = {
    {
      '<leader>lg',
      function()
        Snacks.lazygit.open()
      end,
      desc = 'Lazygit',
    },
  },
}
