-- Formatting | https://github.com/stevearc/conform.nvim
return {
  { -- Autoformat
    'stevearc/conform.nvim',
    dependencies = { 'lewis6991/gitsigns.nvim' },
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true, php = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        elseif vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        else
          return {
            timeout_ms = 2500,
            lsp_format = 'fallback',
          }
        end
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        php = { 'mago_format', stop_after_first = true },
        twig = { 'djlint' },
        dockerfile = { 'dockerfmt' },
        markdown = { 'markdownlint' },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use 'stop_after_first' to run the first available formatter from the list
        -- javascript = { "prettierd", "prettier", stop_after_first = true },
      },
      formatters = {
        pint = {
          args = { '--dirty', '$FILENAME' },
        },
        -- djlint = {
        --   args = { '$FILENAME', '--format-css', '--format-js' },
        -- },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
