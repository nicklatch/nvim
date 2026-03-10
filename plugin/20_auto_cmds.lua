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

vim.api.nvim_create_autocmd('FileType', {
  pattern = {
    'bash',
    'diff',
    'html',
    'css',
    'json',
    'javascript',
    'typescript',
    'lua',
    'luadoc',
    'markdown',
    'markdown_inline',
    'query',
    'vim',
    'vimdoc',
    'php',
    'php_only',
    'phpdoc',
    'blade',
    'twig',
  },
  callback = function()
    vim.treesitter.start()
    vim.wo[0][0].foldmethod = 'expr'
    vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.wo[0][0].foldlevel = 99
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
