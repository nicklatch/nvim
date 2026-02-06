-- Status line | https://github.com/nvim-lualine/lualine.nvim
return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local function truncated_branch()
      local is_git_repo = vim.fn.system 'git rev-parse --git-dir 2>/dev/null'
      if vim.v.shell_error ~= 0 then
        return ''
      end
      local branch = vim.fn.systemlist('git rev-parse --abbrev-ref HEAD')[1]
      return branch:match 'GO%-%d+' or branch or ''
    end
    require('lualine').setup {
      theme = 'auto',
      sections = {
        lualine_b = {
          truncated_branch,
          'diff',
          'diagnostics',
          {
            '%w',
            cond = function()
              return vim.wo.previewwindow
            end,
          },
          {
            '%r',
            cond = function()
              return vim.bo.readonly
            end,
          },
          {
            '%q',
            cond = function()
              return vim.bo.buftype == 'quickfix'
            end,
          },
        },
      },
    }
  end,
}
