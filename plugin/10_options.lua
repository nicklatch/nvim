vim.o.mouse = 'a'
vim.o.mousescroll = 'ver:1,hor:5' -- Customize mouse scroll, with an MX Master mouse, set to 1 to avoid jump

vim.o.switchbuf = 'usetab' -- Use already opened buffers when switching
vim.o.undofile = true -- Persistant undo
vim.o.shada = "'100,<50,s10,:1000,/100,@100,h" -- Limit ShaDa file (for startup)

vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

vim.o.breakindent = true -- Indent wrapped lines to match line start
vim.o.breakindentopt = 'list:-1' -- Add padding for lists (if 'wrap' is set)
vim.o.colorcolumn = '+1' -- Draw column on the right of maximum width
vim.o.cursorline = true
vim.opt.linebreak = true
vim.o.list = true
vim.o.number = true
vim.o.shortmess = 'CFOSWaco' -- Disable some built-in completion messages
vim.o.showmode = false -- Dont need it, its in lualine
vim.o.splitkeep = 'screen' -- Reduce scroll during window split
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.winborder = 'rounded'
vim.o.termguicolors = true
vim.o.signcolumn = 'yes'
vim.o.wrap = false

vim.o.autoindent = true
vim.o.expandtab = true
vim.o.formatoptions = 'rqnl1j' -- Improve comment editing
vim.o.incsearch = true -- Show search matches while typing
vim.o.ignorecase = true
vim.o.smartcase = true -- Respect case if search pattern has upper case
vim.o.smartindent = true -- Make indenting smart
vim.o.spelloptions = 'camel' -- Treat camelCase word parts as separate words
vim.o.virtualedit = 'block' -- Allow going past end of line in blockwise mode
vim.o.iskeyword = '@,48-57,_,192-255,-' -- Treat dash as `word` textobject part

vim.o.updatetime = 250
vim.o.timeoutlen = 300

vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'
vim.o.scrolloff = 10
vim.o.confirm = true
vim.opt.spelllang = 'en_us'

-- vim: ts=2 sts=2 sw=2 et
