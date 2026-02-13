# FILETYPE OVERRIDES KNOWLEDGE BASE

## OVERVIEW
Files under `after/ftplugin/` run immediately after a filetype is detected to adjust local options (indentation, wrap, comment strings) without polluting global state.

## FILES + BEHAVIOR PATTERNS
- `php.lua` / `php_only.lua` – share `vim.opt_local.commentstring = '// %s'`, `shiftwidth = 4`, and `expandtab = true` so PHP and Markdown `phpx` injections stay consistent.
- `markdown.lua` – shiftwidth 4, expandtab true, enabled `wrap`, `linebreak`, and `breakindent` for comfortable prose editing.
- `json.lua`, `jsonc.lua`, `sql.lua`, `javascript.lua`, `twig.lua`, `xml.lua`, `lua.lua`, `just.lua` – set local indent/expand rules (typically shiftwidth 4 and `expandtab = true`) appropriate for the language.

## CONVENTIONS
- Use `vim.opt_local` when adjusting buffer-local options to avoid leaking settings across buffers.
- Keep these files light—no plugin requires or heavy logic; the purpose is single location-specific tweaks.
- Mirror any special commentstring or wrap behavior that would otherwise require repeated autocmds.
- Document new overrides in this AGENTS file so other contributors know where to look when tweaking filetype behavior.

## NOTES
- `php_only.lua` exists because `queries/markdown/injections.scm` marks `phpx` fences as `php_only`; ensure both files stay in sync.
- To add a new filetype tweak, create a file here and keep it under 15 lines so startup stays lean.
