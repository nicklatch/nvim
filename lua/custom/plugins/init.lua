return {
  vim.lsp.config('phptools', {
    init_options = {
      ['0'] = vim.env.DEVSENSE_KEY,
      php = {
        version = 7.4,
      },
    },
  }),
  vim.lsp.enable 'phptools',
}
