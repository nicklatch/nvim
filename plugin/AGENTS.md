# RUNTIME PLUGINS KNOWLEDGE BASE

## OVERVIEW
Files under `plugin/` execute every startup: they keep global Vim options, autocmds, user commands, keymaps, and the floating terminal helper separated from the Lazy-managed plugins.

## FILES + RESPONSIBILITIES
- `10_options.lua` – global editor options (numbers, clipboard, indent/formatting defaults, motion tweaks).
- `20_auto_cmds.lua` – yank highlighting, spell toggles for Markdown/Text/Commit, and any editor-global autocmds.
- `20_user_cmds.lua` – `:CopyPath` helper that copies absolute or relative file paths to the `+` register.
- `30_keymaps.lua` – diagnostics shortcuts, window navigation (with tmux fallbacks), quick punctuation entry, terminal exit, buffer delete, and search/replace helpers.
- `40_filetypes.lua` – ad-hoc filetype mappings (Caddy, Scheme, `.h` → C).
- `floating-term.lua` – custom `:Floaterminal` command for a centered, rounded floating terminal (marked TODO to replace with the Snacks terminal float once stable).

## CONVENTIONS
- Keep `plugin/` logic idempotent; avoid requiring heavy modules (use `vim.schedule` for async actions like clipboard writes).
- Keymap descriptions follow the `[S]earch`/`[D]iagnostics` pattern and live in `plugin/30_keymaps.lua` rather than mixing into Lazy specs.
- Autocmds and user commands belong here, never inside lazy-loaded specs or ftplugins.
- Floating terminal config is glue-only; once Snacks’ floating terminal wins, simplify this file accordingly.

## NOTES
- Runtime files load before Lazy specs finish; keep side effects lightweight so startup stays snappy.
- When in doubt, add new global map/autocmd/command to this directory and mention it in this doc for discoverability.
