-- Marks for navigating your project | https://github.com/ThePrimeagen/harpoon/tree/harpoon2
return {
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    config = function()
      require('harpoon').setup {
        menu = {
          width = vim.api.nvim_win_get_width(0) - 4,
        },
        settings = {
          save_on_toggle = true,
        },
      }
    end,
    keys = {
      {
        '<leader>mm',
        function()
          require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())
        end,
        desc = 'List locations',
      },
      {
        '<leader>ma',
        function()
          require('harpoon'):list():add()
        end,
        desc = 'Add Location',
      },
      {
        '<leader>mr',
        function()
          require('harpoon'):list():remove()
        end,
        desc = 'Remove Location',
      },
      {
        '<leader>mn',
        function()
          require('harpoon'):list():next()
        end,
        desc = 'Next Location',
      },
      {
        '<leader>mp',
        function()
          require('harpoon'):list():prev()
        end,
        desc = 'Previous Location',
      },
      {
        '<leader>1',
        function()
          require('harpoon'):list():select(1)
        end,
        desc = 'Harpoon to File 1',
      },
      {
        '<leader>2',
        function()
          require('harpoon'):list():select(2)
        end,
        desc = 'Harpoon to File 2',
      },
      {
        '<leader>3',
        function()
          require('harpoon'):list():select(3)
        end,
        desc = 'Harpoon to File 3',
      },
      {
        '<leader>4',
        function()
          require('harpoon'):list():select(4)
        end,
        desc = 'Harpoon to File 4',
      },
      {
        '<leader>5',
        function()
          require('harpoon'):list():select(5)
        end,
        desc = 'Harpoon to File 5',
      },
    },
  },
}
