# PROJECT KNOWLEDGE BASE

## OVERVIEW
Neovim configuration centered on `folke/lazy.nvim`, separating core runtime tweaks (options, keymaps, autocmds) from lazily loaded feature specs. The `lua/custom/plugins/` tree contains almost everything that lands in `:Lazy`; the rest of the repo keeps editor-global glue (options, filetypes, snippets of ftplugin logic, Tree-sitter queries) thin and deterministic.

## STRUCTURE
```
./
├── init.lua                     # leaders + requires bootstrap & plugin entrypoints
├── lua/
│   ├── lazy-bootstrap.lua       # clones/prepends lazy.nvim if needed
│   └── lazy-plugins.lua         # sets icon defaults and imports custom plugin specs
├── lua/custom/plugins/          # feature-by-feature Lazy specs and LSP registration point
│   └── AGENTS.md                # plugin-domain knowledge base
├── plugin/
│   ├── 10_options.lua           # editor options
│   ├── 20_auto_cmds.lua         # autocmds (LSP, yank, spell, etc.)
│   ├── 20_user_cmds.lua         # runtime `:CopyPath`, `:Format`, etc.
│   ├── 30_keymaps.lua           # global mappings (search, diagnostics, terminal shortcuts)
│   ├── 40_filetypes.lua         # ad-hoc filetypes, ftautocmds
│   └── floating-term.lua         # centered terminal (presently TODO to replace with Snacks)
├── after/ftplugin/              # filetype-specific overrides (php, markdown, lua, json, sql, etc.)
├── queries/                     # custom Tree-sitter injections/queries for php + markdown
├── doc/                         # kickstart help text
├── .beads/                      # beads issue database, hooks, metadata (auto-managed)
└── .github/workflows/           # Stylua CI check
```

## LOADING FLOW
1. `init.lua` sets `mapleader`/`maplocalleader`, enables Nerd Font metrics, and requires the bootstrap/plugin entrypoints.
2. `lua/lazy-bootstrap.lua` ensures `lazy.nvim` is checked out under `stdpath('data')/lazy/` and prepends it to `runtimepath`.
3. `lua/lazy-plugins.lua` calls `require('lazy').setup()`, registers `guess-indent`, configures icon fallbacks, and imports every spec from `lua/custom/plugins/`.
4. Lazy eagerly sources `lua/custom/plugins/init.lua` for LSP server registration and then loads the remaining spec files via the import.
5. Global runtime hooks (`plugin/*.lua`), `after/ftplugin/*`, and `queries/*` execute automatically as Neovim starts or detects filetypes.

## WHERE TO LOOK
| Task | Location | Notes |
| --- | --- | --- |
| Bootstrap & Lazy setup | `init.lua`, `lua/lazy-bootstrap.lua`, `lua/lazy-plugins.lua` | Sets leaders, ensures `lazy.nvim`, configures icons, imports `custom.plugins`. |
| Feature plugins | `lua/custom/plugins/*.lua` | Each file should return Lazy specs; `init.lua` handles the handful of explicit LSP server registrations (`phptools`, `ghostty`, `ts_ls`, `vue_ls`). |
| LSP infrastructure | `lua/custom/plugins/lspconfig.lua` | Mason, diagnostics, handlers, keymaps, and shared settings for all servers. |
| Global runtime behavior | `plugin/10_options.lua`, `20_auto_cmds.lua`, `20_user_cmds.lua`, `30_keymaps.lua`, `40_filetypes.lua` | Always-loaded options, autocmds, user commands, keymaps, and ad-hoc filetype additions. |
| Filetype overrides | `after/ftplugin/*.lua` | Per-language setups (php, markdown, lua, json, xml, just, etc.). |
| Tree-sitter injections | `queries/php/injections.scm`, `queries/markdown/injections.scm` | PHP string/HTML injections and Markdown `phpx` fences. |
| Local Apache log plugin | `~/Repos/apache-log.nvim` (tied in via `lua/custom/plugins/apache-log.lua`) | External repo required for `apache-log` spec; ensure the path exists before enabling. |
| Beads database | `.beads/issues.jsonl` (managed by hooks) | Hooks flush/import JSONL; do not edit manually without running `bd` commands. |

## BUILD / LINT / TEST COMMANDS
### Formatting
```bash
stylua .
stylua --check .
```
CI (`.github/workflows/stylua.yml`) runs `stylua --check .` on PRs.

### Manual validation
```bash
nvim -c ":checkhealth" -c "qa!"
nvim --clean -u ~/.config/nvim/init.lua           # sanity-check startup without user globals
```
Use `:checkhealth <plugin>` for targeted diagnostics or open the relevant filetypes to confirm behavior.

## CODE STYLE GUIDELINES
- Maximum line width: 160 characters (Stylua enforces).
- Indentation: 2 spaces; avoid tabs.
- Prefer single quotes and omit call parentheses when requiring modules (`local mod = require 'foo'`).
- Always include the modeline `-- vim: ts=2 sts=2 sw=2 et` on Lua files that participate in runtime loading.
- Use explicit `local` declarations for helpers, descriptive variable names, and consistent snake_case for values.
- Keymap descriptions follow the bracket-hint pattern: `{ desc = '[S]earch [F]iles' }`.
- Keep plugin specs in `lua/custom/plugins/`; runtime adjustments belong in `plugin/`, `after/ftplugin/`, or `queries/`.

## PLUGIN CONFIGURATION
- Most files under `lua/custom/plugins/` return Lazy.nvim spec tables. Keep them focused on conditional loading triggers (`event`, `ft`, `cmd`, `keys`, etc.).
- `lua/custom/plugins/init.lua` is the exception: it performs immediate `vim.lsp.config`/`vim.lsp.enable` calls for the small set of servers that need explicit bootstrap (`phptools`, `ghostty`, `ts_ls`, `vue_ls`). Keep this file limited to registration; avoid adding additional specs or runtime glue there.
- `lua/custom/plugins/lspconfig.lua` controls the shared LSP surface: Mason setup, handler wiring, diagnostic symbols, and keymap helpers.
- Do not mix runtime behavior (e.g., autocmds, keymaps) into Lazy specs—use `plugin/` files or ftplugins instead.

## GIT HOOKS AND AUTOMATION
- `.git/hooks/pre-commit` runs `bd sync --flush-only` to ensure pending beads issues are persisted before committing. No Stylua check lives in the hook; formatting is enforced manually or via CI.
- `.git/hooks/post-merge` calls `bd import -i .beads/issues.jsonl` when the JSONL changed, keeping Beads state synchronized.
- Run `bd sync` regularly when working on issues to keep the JSONL in sync with commits.
- CI enforces `stylua --check .` on PRs (see `.github/workflows/stylua.yml`).

## ANTI-PATTERNS
- Don’t move plugin specs into `plugin/`; that directory is for always-loaded Vimscript/Lua glue.
- Don’t define LSP servers in `plugin/` or `after/ftplugin/`; keep registration in `lua/custom/plugins/init.lua` (infra lives in `lspconfig.lua`).
- Don’t copy runtime code between languages; prefer per-ft overrides in `after/ftplugin/`.

## KNOWN DEVIATIONS
- `lua/custom/plugins/telescope.lua.disabled` replaces the disabled Telescope spec; current search experience is driven by Snacks modules (`snacks.lua`, `which-key.lua`, etc.).
- `plugin/floating-term.lua` is slated for removal once the Snacks terminal float is stable.
- An untracked helper (`lua/plugins/dankcolors.lua`) sits outside the Lazy import tree; treat it as side-experiment unless you wire it into `lazy-plugins.lua`.
- `~/Repos/apache-log.nvim` must be present for the `apache-log` spec to work; clone it manually or symlink it if you need that feature.

## NOTES
- Use `:Lazy` to inspect plugin status, trigger installs, or run health checks.
- Use `:Mason` to manage the LSP/DAP/linter stack referenced by this config.
- Re-source with `:source ~/.config/nvim/init.lua` or restart Neovim when rewiring specs.
