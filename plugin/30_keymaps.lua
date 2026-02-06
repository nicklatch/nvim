-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })

-- QOL
vim.keymap.set('n', ';;', '<Esc>A;<Esc>')
vim.keymap.set('n', ',,', '<Esc>A,<Esc>')
vim.keymap.set('i', ';;', '<Esc>A;<Esc>')
vim.keymap.set('i', ',,', '<Esc>A,<Esc>')

-- Exit terminal mode in the builtin terminal with <C-\><C-n>
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<leader>bd', '<cmd>bdelete<CR>', { desc = '[B]uffer [d]elete' })

-- Window navigation
vim.keymap.set('n', '<C-j>', function()
  if vim.fn.exists ':NvimTmuxNavigateDown' ~= 0 then
    vim.cmd.NvimTmuxNavigateDown()
  else
    vim.cmd.wincmd 'j'
  end
end, { desc = 'Navigate down' })

vim.keymap.set('n', '<C-k>', function()
  if vim.fn.exists ':NvimTmuxNavigateUp' ~= 0 then
    vim.cmd.NvimTmuxNavigateUp()
  else
    vim.cmd.wincmd 'k'
  end
end, { desc = 'Navigate up' })

vim.keymap.set('n', '<C-l>', function()
  if vim.fn.exists ':NvimTmuxNavigateRight' ~= 0 then
    vim.cmd.NvimTmuxNavigateRight()
  else
    vim.cmd.wincmd 'l'
  end
end, { desc = 'Navigate right' })

vim.keymap.set('n', '<C-h>', function()
  if vim.fn.exists ':NvimTmuxNavigateLeft' ~= 0 then
    vim.cmd.NvimTmuxNavigateLeft()
  else
    vim.cmd.wincmd 'h'
  end
end, { desc = 'Navigate left' })

-- Quick find/replace for word under cursor
vim.keymap.set('n', 'S', function()
  local cmd = ':%s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>'
  local keys = vim.api.nvim_replace_termcodes(cmd, true, false, true)
  vim.api.nvim_feedkeys(keys, 'n', false)
end, { desc = 'Quick find/replace word under cursor' })

-- vim: ts=2 sts=2 sw=2 et
