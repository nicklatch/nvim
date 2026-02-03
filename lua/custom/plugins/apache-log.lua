return {
  dir = '~/Repos/apache-log.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
  },
  keys = {
    { '<leader>ta', function() require('apache-log').open() end, desc = '[T]oggle [A]pache Log Viewer' },
  },
  cmd = { 'ApacheLog', 'ApacheLogClose' },
  opts = {
    ui = 'nui',
    ui_size = {
      width = 0.85,
      height = 0.7,
    },
    ui_border = 'rounded',
    auto_scroll = true,
    list_width = 0.5,
    detail_height = 0.4,
    debounce_ms = 200,
    truncate_length = 80,
    columns = {
      level = 3,
      time = 8,
      module = 12,
      message = 60,
    },
  },
  config = function(_, opts)
    require('apache-log').setup(opts)
  end,
}
