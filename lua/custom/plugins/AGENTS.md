# CUSTOM PLUGINS KNOWLEDGE BASE

## OVERVIEW
User-owned Lazy.nvim plugin specs and overrides, one file per plugin or feature.

## WHERE TO LOOK
| Task | Location | Notes |
| --- | --- | --- |
| Add new plugin | lua/custom/plugins/<feature>.lua | Return a Lazy.nvim spec table |
| Plugin aggregation | lua/custom/plugins/init.lua | Loads custom plugin specs |
| LSP server enablement | lua/custom/plugins/init.lua | Uses vim.lsp.config + vim.lsp.enable |
| LSP core setup | lua/custom/plugins/lspconfig.lua | Mason, handlers, diagnostics, keymaps |
| Formatting | lua/custom/plugins/conform.lua | format_on_save rules and filetype skips |
| Telescope defaults | lua/custom/plugins/telescope.lua | Hidden files and ignore list tuning |

## CONVENTIONS
- Each file returns a table of Lazy.nvim specs
- Prefer single quotes and no call parentheses: `require 'module'`
- Add modeline `-- vim: ts=2 sts=2 sw=2 et` at end of Lua files
- Use bracket hints in keymap descriptions: `{ desc = '[F]ormat buffer' }`

## ANTI-PATTERNS
- Do not move plugin specs into `plugin/` (runtime code only)
- Do not add LSP server config outside `lua/custom/plugins/init.lua`
