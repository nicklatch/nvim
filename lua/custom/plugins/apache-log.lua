local default_path = 'var/logs/taps-error.log'

return {
  dir = '~/Repos/nvim_plugins/apache-log.nvim',
  dependencies = {
    'folke/snacks.nvim',
  },
  keys = {
    {
      '<leader>ta',
      function()
        local alog = require 'apache-log'
        if alog.is_open() then
          alog.close()
        else
          alog.open(default_path)
        end
      end,
      desc = '[T]oggle [A]pache Log Viewer',
    },
  },
  cmd = { 'ApacheLog', 'ApacheLogClose' },
  opts = {
    ui = 'snacks',
    auto_scroll = true,
    list_width = 0.5,
    detail_height = 0.4,
    debounce_ms = 200,
    truncate_length = 80,
  },
  config = function(_, opts)
    require('apache-log').setup(opts)
  end,
}

-- vim: ts=2 sts=2 sw=2 et
