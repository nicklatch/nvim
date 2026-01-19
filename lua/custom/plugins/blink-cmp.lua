-- Repo: https://github.com/saghen/blink.cmp
-- Docs: https://cmp.saghen.dev/
return {
  { -- Autocompletion
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
        opts = {},
      },
      'folke/lazydev.nvim',
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = {
        preset = 'enter',
      },
      appearance = {
        nerd_font_variant = 'mono',
      },

      completion = {
        menu = {
          border = 'rounded',
          max_height = 10,
          draw = {
            columns = {
              { 'kind_icon' },
              { 'label', 'label_description', gap = 1 },
              { 'source_name' },
            },
            components = {
              source_name = {
                text = function(ctx)
                  local source_names = {
                    lsp = '[LSP]',
                    buffer = '[Buffer]',
                    path = '[Path]',
                    snippets = '[Snippet]',
                  }
                  return (source_names[ctx.source_name] or '[') .. ctx.source_name .. ']'
                end,
                highlight = 'CmpItemMenu',
              },
            },
          },
          auto_show = true,
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 250,
          window = { border = 'rounded' },
        },
        ghost_text = {
          enabled = true,
        },
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer', 'lazydev' },
        providers = {
          lsp = { score_offset = 1000 },
          path = { score_offset = 3 },
          snippets = {
            score_offset = -100,
            max_items = 3,
            min_keyword_length = 3,
          },
          buffer = {
            score_offset = -100,
            min_keyword_length = 3,
          },
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        },
      },
      snippets = { preset = 'luasnip' },
      fuzzy = { implementation = 'prefer_rust_with_warning' },
      signature = {
        enabled = true,
        window = {
          border = 'rounded',
          max_width = 20,
        },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
