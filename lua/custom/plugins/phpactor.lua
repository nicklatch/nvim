-- PHP tooling | https://github.com/gbprod/phpactor.nvim
return {
  {
    'gbprod/phpactor.nvim',
    ft = 'php',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'neovim/nvim-lspconfig',
      'nvim-tree/nvim-web-devicons',
    },
    opts = {
      install = {
        check_on_startup = 'daily',
        autou_update = true,
      },
      lspconfig = {
        enabled = false, -- Using PHPTools/Devsense for LSP for now.
      },
    },
  },
}
