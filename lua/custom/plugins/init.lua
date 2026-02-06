return {
  vim.lsp.config('phptools', {
    filetypes = { 'php' },
    init_options = {
      ['0'] = vim.env.DEVSENSE_PHP_LS_LICENSE,
      embeddedLanguages = { css = true, javascript = true },
    },
    settings = {
      php = {
        version = '7.4',
      },
    },
  }),
  vim.lsp.enable 'phptools',

  vim.lsp.config('ghostty', {
    cmd = { 'ghostty-ls' },
    filetypes = { 'ghostty' },
  }),
  vim.lsp.enable 'ghostty',

  -- Vue 3 LSP setup
  vim.lsp.config('ts_ls', {
    init_options = {
      plugins = {
        {
          name = '@vue/typescript-plugin',
          location = vim.fn.stdpath 'data' .. '/mason/packages/vue-language-server/node_modules/@vue/language-server',
          languages = { 'vue' },
          configNamespace = 'typescript',
        },
      },
    },
    filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
  }),

  vim.lsp.config('vue_ls', {}),

  vim.lsp.enable { 'ts_ls', 'vue_ls' },
}
