# CUSTOM PLUGINS KNOWLEDGE BASE

## OVERVIEW
User-owned Lazy.nvim plugin specs and overrides, typically one file per plugin or feature area. `lua/custom/plugins/init.lua` registers the handful of servers that must be enabled immediately, while the rest of the directory is imported lazily.

## WHERE TO LOOK
| Task | Location | Notes |
| --- | --- | --- |
| Add new plugin spec | `lua/custom/plugins/<name>.lua` | Return a Lazy.nvim spec table and let `lazy-plugins.lua` import it via the `custom.plugins` path. |
| Plugin aggregation | `lua/custom/plugins/init.lua` | Side-effect file that calls `vim.lsp.config`/`vim.lsp.enable` for `phptools`, `ghostty`, `ts_ls`, and `vue_ls`. Keep this file limited to server registration. |
| LSP infrastructure | `lua/custom/plugins/lspconfig.lua` | Mason, diagnostics, handlers, keymaps, and shared settings for every server. |
| Formatting conventions | `lua/custom/plugins/conform.lua`, `lua/custom/plugins/lint.lua` | Controls format-on-save, lint-on-save, and filetype skips. |
| Completion & editing helpers | `lua/custom/plugins/blink-cmp.lua`, `autopairs.lua`, `mini.lua`, `gitsigns.lua`, `harpoon2.lua` | Hook into Snips, cmp, and buffer-local commands. |
| Search/UI surface | `lua/custom/plugins/snacks.lua`, `which-key.lua`, `lualine.lua`, `bufferline.lua` | Snacks modules power the flyout search experience and UI polish, replacing the disabled Telescope spec. |
| Language-specific tooling | `treesitter.lua`, `phpactor.lua`, `laravel.lua`, `obsidian.lua`, `rendermarkdown.lua`, `apache-log.lua` | Domain-specific language plugins plus the external Apache log viewer. |

## ACTIVE DOMAINS
- **Completion & Editors**: `blink-cmp`, `snacks` (snippet choice), `autopairs`, `mini`, `harpoon2` keep insert-mode editing smooth.
- **UI/Navigation**: `which-key`, `snacks`, `lualine`, `bufferline`, `gitsigns` define the visible interface and status indicators.
- **LSP + Formatting**: `lspconfig`, `conform`, `lint`, `treesitter` coordinate Mason, diagnostics, formatters, linters, and treesitter parsers.
- **Language-layer tooling**: `phpactor`, `laravel`, `obsidian`, `rendermarkdown`, `apache-log` expose workspace-specific commands or viewers.

## CONVENTIONS
- Each file (aside from `init.lua`) should return a table of Lazy.nvim specs with clear load triggers (`event`, `ft`, `cmd`, `keys`, etc.).
- Prefer single quotes and omit call parentheses when requiring modules (e.g., `local config = require 'config'`).
- Append the modeline `-- vim: ts=2 sts=2 sw=2 et` to Lua files that participate in runtime loading.
- Use descriptive variable names, explicit `local` declarations, and consistent snake_case for helper values.
- Keep plugin-specific logic in its own file; bind shared utilities back to `lspconfig.lua` or Snacks modules when needed.

## ANTI-PATTERNS
- Do not move plugin specs into `plugin/`; that directory is for always-loaded runtime glue.
- Avoid embedding ad-hoc runtime code (autocmds, keymaps, commands) inside Lazy specs—runtime hooks belong in `plugin/` or `after/ftplugin/`.
- Do not add new LSP servers outside `lua/custom/plugins/init.lua`/`lspconfig.lua` unless the server needs special bootstrap handling.

## KNOWN DEVIATIONS
- `lua/custom/plugins/telescope.lua.disabled` lives beside this directory but is intentionally excluded from the import tree; Snacks modules drive search instead.
- The Apache log viewer spec points to `~/Repos/apache-log.nvim`, so the external repository must exist for the plugin to load.

## NOTES
- Use `:Lazy` to check plugin load status when developing specs.
- Keep `lua/custom/plugins/AGENTS.md` updated with any new domain-specific conventions that emerge inside this directory.
