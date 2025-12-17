-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })

vim.keymap.set('n', ';;', '<Esc>A;<Esc>')
vim.keymap.set('n', ',,', '<Esc>A,<Esc>')

vim.keymap.set('i', ';;', '<Esc>A;<Esc>')
vim.keymap.set('i', ',,', '<Esc>A,<Esc>')

-- Exit terminal mode in the builtin terminal with <C-\><C-n>
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
-- vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
-- vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
-- vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Window and kitty navigation
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

-- AutoCmds

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Only highlight misspellings in comments and doc comments
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'php',
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelloptions = 'camel'
    vim.cmd 'syn match phpComment /\\/\\*\\_.\\{-}\\*\\// contains=@Spell'
    vim.cmd 'syn match phpComment /\\/\\/.*$/ contains=@Spell'
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'markdown', 'text', 'gitcommit' },
  callback = function()
    vim.opt_local.spell = true
  end,
})

-- vim: ts=2 sts=2 sw=2 et
