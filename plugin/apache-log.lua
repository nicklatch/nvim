-- Apache Log Viewer Plugin
-- View and monitor Apache error logs with live updates

-- Prevent double-loading
if vim.g.loaded_apache_log then
  return
end
vim.g.loaded_apache_log = true

-- Create user command
vim.api.nvim_create_user_command('ApacheLog', function(opts)
  local apache_log = require 'apache-log'

  if opts.args == '' then
    if apache_log.is_open() then
      apache_log.close()
    else
      vim.notify('ApacheLog: Please provide a log file path', vim.log.levels.WARN)
      vim.notify('Usage: :ApacheLog /path/to/error.log', vim.log.levels.INFO)
    end
  else
    apache_log.open(opts.args)
  end
end, {
  nargs = '?',
  complete = 'file',
  desc = 'Open Apache error log viewer',
})

-- Optional: Create a close command
vim.api.nvim_create_user_command('ApacheLogClose', function()
  require('apache-log').close()
end, {
  desc = 'Close Apache error log viewer',
})

-- vim: ts=2 sts=2 sw=2 et
