-- Copies current filepath to clipboard. Use a postfix`!` for relative path
vim.api.nvim_create_user_command('CopyPath', function(opts)
  local path = vim.fn.expand(opts.bang and '%:.' or '%:p')
  vim.fn.setreg('+', path)
  print('Copied: ' .. path)
end, {
  bang = true,
  desc = 'Copies current filepath to clipboard. Use a postfix `!` for relative path',
})
