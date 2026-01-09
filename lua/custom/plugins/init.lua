return {
  vim.lsp.config('phptools', {
    init_options = {
      ['0'] = vim.env.DEVSENSE_KEY,
      debug = {
        inline_values = true,
      },
    },
  }),
  -- vim.lsp.enable 'phptools',

  vim.lsp.config('ghostty', {
    cmd = { 'ghostty-ls' },
    filetypes = { 'ghostty' },
  }),
  vim.lsp.enable 'ghostty',
}
