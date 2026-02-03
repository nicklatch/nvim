# PROJECT KNOWLEDGE BASE

**Generated:** 2026-01-23
**Commit:** b30034a
**Branch:** master

## OVERVIEW

Neovim configuration with Lazy.nvim plugin management, split core vs custom plugin specs, and a custom Apache log viewer.

## STRUCTURE

```
./
├── init.lua                 # main entry point
├── lua/lazy-plugins.lua      # Lazy.nvim setup and imports
├── lua/kickstart/plugins/    # core plugin specs
├── lua/custom/plugins/       # user plugin specs and overrides

├── plugin/                   # auto-loaded runtime modules
├── after/ftplugin/           # per-filetype overrides
├── doc/                      # help docs for this config
└── queries/                  # Tree-sitter queries
```

## WHERE TO LOOK

| Task | Location | Notes |
| --- | --- | --- |
| Add plugins | lua/custom/plugins | One file per plugin or feature area |
| Core plugin defaults | lua/kickstart/plugins | Keep custom overrides separate |
| LSP server setup | lua/custom/plugins/init.lua | Uses vim.lsp.config + vim.lsp.enable |
| Keymaps | plugin/keymaps.lua | Central location for mappings |
| Options | plugin/options.lua | Core editor settings |
| Filetype tweaks | plugin/filetypes.lua, after/ftplugin | Use after/ftplugin for overrides |
| Apache log viewer | ~/Repos/apache-log.nvim | Parser, UI, watcher modules (loaded via lazy.nvim) |

## BUILD/LINT/TEST COMMANDS

### Linting
```bash
# Format code according to style guide
stylua .

# Check for formatting issues (read-only)
stylua --check .
```

### Testing
```bash
# No automated test suite exists
# Run Neovim health checks to verify configuration
:checkhealth

# For specific plugin testing, use:
:checkhealth plugin_name

# For manual testing, use a separate Neovim instance
nvim --clean -u ~/.config/nvim/init.lua
```

### Running a Single Test
Since there's no formal test suite, testing is done through:
1. Manual verification of plugin functionality
2. Neovim's built-in `:checkhealth` command
3. Opening specific file types to verify behavior
4. Using debug utilities like `:echo`, `:lua print()` for custom validation

## CODE STYLE GUIDELINES

### General Formatting
- Line width: Max 160 characters (enforced by stylua)
- Indentation: 2 spaces (no tabs)
- Use single quotes for strings when possible
- No trailing whitespace
- Blank line at end of file
- Files end with: `-- vim: ts=2 sts=2 sw=2 et`

### Imports and Module Structure
- Use `require 'module'` without parentheses (stylua configuration)
- Organize requires at top of file when possible
- Use descriptive variable names for required modules: `local modulename = require 'module-name'`
- Each plugin configuration should be in its own file in `lua/custom/plugins/`

### Lua Code Conventions
- Use 2-space indentation consistently
- Function names: Use camelCase for functions
- Variable names: Use snake_case for variables
- Constants: Use UPPER_CASE for constants
- Prefer explicit variable declarations with `local`

### Naming Conventions
- Plugin configuration files: Match the plugin name when possible
- Function names: Use descriptive names that indicate purpose
- Variable names: Use clear, descriptive names in snake_case
- Configuration files: Place in appropriate directories as documented in STRUCTURE

### Error Handling
- Use `pcall` for operations that may fail
- Provide meaningful error messages with context
- Handle API failures gracefully
- Log errors appropriately for debugging

### Types and Documentation
- Use Lua language server annotations when helpful
- Document complex functions with inline comments
- Use type annotations where beneficial for clarity
- Comment table structures for complex configurations

### Plugin Configuration
- Plugin specs should return a table of Lazy.nvim specs
- Keymap descriptions use bracket hints: `{ desc = '[S]earch [F]iles' }`
- Do not configure LSP servers outside `lua/custom/plugins/init.lua`
- Keep plugin specs separate from runtime code in `plugin/` directory

### Git Hooks and Automation
- Pre-commit hook runs `stylua --check .` to enforce formatting
- CI enforces `stylua --check .` as a gate

## ANTI-PATTERNS (THIS PROJECT)

- Do not configure LSP servers outside `lua/custom/plugins/init.lua`
- Do not move plugin specs into `plugin/` (that directory is runtime code)
- Don't use inconsistent naming across plugin configurations
- Don't put large configurations directly in keymap files

## COMMANDS

```bash
# Format all Lua files
stylua .

# Check for formatting compliance (read-only)
stylua --check .

# Run Neovim health checks
nvim -c ":checkhealth" -c "qa!"
```

## NOTES

- No automated test suite; run `:checkhealth` in Neovim for diagnostics.
- Use `:lua print(vim.inspect(variable))` for debugging complex data
- Use `:source %` to reload configuration during development
- Use `:Lazy` to manage plugins
- Use `:Mason` to manage LSP/DAP/linter installations
