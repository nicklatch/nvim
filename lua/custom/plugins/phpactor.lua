-- PHP tooling | https://github.com/gbprod/phpactor.nvim
return {
  {
    'gbprod/phpactor.nvim',
    ft = 'php',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'neovim/nvim-lspconfig',
    },
    opts = {
      install = {
        check_on_startup = 'always',
        autou_update = true,
      },
      lspconfig = {
        enabled = false, -- Using PHPTools/Devsense for LSP for now.
      },
    },
  },
}
