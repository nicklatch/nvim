return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    main = 'nvim-treesitter.config',
    opts = {
      ensure_installed = {
        'bash',
        'diff',
        'html',
        'css',
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
        'blade',
        'twig',
      },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = {
        enable = true,
        disable = { 'ruby' },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
