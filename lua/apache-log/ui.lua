local config = require 'apache-log.config'
local parser = require 'apache-log.parser'

local M = {}

local state = {
  list_buf = nil,
  list_win = nil,
  detail_buf = nil,
  detail_win = nil,
  entries = {},
  new_count = 0,
  auto_scroll = true,
}

local level_highlights = {
  error = 'DiagnosticError',
  warn = 'DiagnosticWarn',
  warning = 'DiagnosticWarn',
  notice = 'DiagnosticInfo',
  info = 'DiagnosticInfo',
  debug = 'DiagnosticHint',
}

local function buf_valid(buf)
  return buf and vim.api.nvim_buf_is_valid(buf)
end

local function win_valid(win)
  return win and vim.api.nvim_win_is_valid(win)
end

local function update_buffer_name(path)
  if not buf_valid(state.list_buf) then
    return
  end

  local name = 'ApacheLog: ' .. vim.fn.fnamemodify(path or '', ':t')
  if state.new_count > 0 then
    name = name .. ' [+' .. state.new_count .. ']'
  end

  vim.api.nvim_buf_set_name(state.list_buf, name)
end

function M.create_list_buffer()
  local buf = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_set_option_value('buftype', 'nofile', { buf = buf })
  vim.api.nvim_set_option_value('bufhidden', 'wipe', { buf = buf })
  vim.api.nvim_set_option_value('swapfile', false, { buf = buf })
  vim.api.nvim_set_option_value('modifiable', false, { buf = buf })
  vim.api.nvim_set_option_value('filetype', 'apache-log-list', { buf = buf })

  state.list_buf = buf
  return buf
end

function M.create_detail_buffer()
  local buf = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_set_option_value('buftype', 'nofile', { buf = buf })
  vim.api.nvim_set_option_value('bufhidden', 'wipe', { buf = buf })
  vim.api.nvim_set_option_value('swapfile', false, { buf = buf })
  vim.api.nvim_set_option_value('modifiable', false, { buf = buf })
  vim.api.nvim_set_option_value('filetype', 'apache-log-detail', { buf = buf })

  state.detail_buf = buf
  return buf
end

function M.open_list_split()
  local width = math.floor(vim.o.columns * config.options.list_width)

  vim.cmd 'botright vsplit'
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_width(win, width)

  if buf_valid(state.list_buf) then
    vim.api.nvim_win_set_buf(win, state.list_buf)
  end

  vim.api.nvim_set_option_value('number', true, { win = win })
  vim.api.nvim_set_option_value('relativenumber', false, { win = win })
  vim.api.nvim_set_option_value('wrap', false, { win = win })
  vim.api.nvim_set_option_value('cursorline', true, { win = win })
  vim.api.nvim_set_option_value('winfixwidth', true, { win = win })

  state.list_win = win
  return win
end

function M.open_detail_split()
  if not vim.api.nvim_win_is_valid(state.list_win) then
    return nil
  end

  vim.api.nvim_set_current_win(state.list_win)

  local list_height = vim.api.nvim_win_get_height(state.list_win)
  local detail_height = math.floor(list_height * config.options.detail_height)

  vim.cmd 'belowright split'
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_height(win, detail_height)

  if not buf_valid(state.detail_buf) then
    M.create_detail_buffer()
  end

  vim.api.nvim_win_set_buf(win, state.detail_buf)

  vim.api.nvim_set_option_value('number', false, { win = win })
  vim.api.nvim_set_option_value('wrap', true, { win = win })
  vim.api.nvim_set_option_value('cursorline', false, { win = win })
  vim.api.nvim_set_option_value('winfixheight', true, { win = win })

  state.detail_win = win

  vim.api.nvim_set_current_win(state.list_win)

  return win
end

function M.render_list(entries)
  if not buf_valid(state.list_buf) then
    return
  end

  state.entries = entries
  local lines = {}

  for _, entry in ipairs(entries) do
    local preview = parser.create_preview(entry, config.options.truncate_length)
    table.insert(lines, preview)
  end

  vim.api.nvim_set_option_value('modifiable', true, { buf = state.list_buf })
  vim.api.nvim_buf_set_lines(state.list_buf, 0, -1, false, lines)
  vim.api.nvim_set_option_value('modifiable', false, { buf = state.list_buf })

  for i, entry in ipairs(entries) do
    local hl = level_highlights[entry.level] or 'Normal'
    vim.api.nvim_buf_add_highlight(state.list_buf, -1, hl, i - 1, 0, 3)
  end
end

function M.append_entries(new_entries, path)
  if not buf_valid(state.list_buf) then
    return
  end

  local lines = {}
  for _, entry in ipairs(new_entries) do
    table.insert(state.entries, entry)
    local preview = parser.create_preview(entry, config.options.truncate_length)
    table.insert(lines, preview)
  end

  local line_count = vim.api.nvim_buf_line_count(state.list_buf)

  vim.api.nvim_set_option_value('modifiable', true, { buf = state.list_buf })
  vim.api.nvim_buf_set_lines(state.list_buf, line_count, line_count, false, lines)
  vim.api.nvim_set_option_value('modifiable', false, { buf = state.list_buf })

  for i, entry in ipairs(new_entries) do
    local hl = level_highlights[entry.level] or 'Normal'
    local line_idx = line_count + i - 1
    vim.api.nvim_buf_add_highlight(state.list_buf, -1, hl, line_idx, 0, 3)
  end

  if vim.api.nvim_win_is_valid(state.list_win) then
    local cursor = vim.api.nvim_win_get_cursor(state.list_win)
    local was_at_bottom = cursor[1] >= line_count

    if state.auto_scroll or was_at_bottom then
      local new_line_count = vim.api.nvim_buf_line_count(state.list_buf)
      vim.api.nvim_win_set_cursor(state.list_win, { new_line_count, 0 })
      state.new_count = 0
    else
      state.new_count = state.new_count + #new_entries
    end

    update_buffer_name(path)
  end
end

function M.render_detail(entry)
  if not entry then
    return
  end

  if not state.detail_win or not vim.api.nvim_win_is_valid(state.detail_win) then
    M.open_detail_split()
  end

  if not buf_valid(state.detail_buf) then
    return
  end

  local lines = {}
  local highlights = {}

  local function add_line(text)
    table.insert(lines, text or '')
  end

  local function add_field(label, value, value_hl)
    if value then
      local line = string.format('%-12s %s', label, value)
      table.insert(lines, line)
      if value_hl then
        table.insert(highlights, { #lines, 13, #line, value_hl })
      end

      table.insert(highlights, { #lines, 0, 12, 'Comment' })
    end
  end

  local function add_separator(title)
    local sep = string.rep('━', 60)
    if title then
      add_line('━━━ ' .. title .. ' ' .. sep:sub(1, 55 - #title))
    else
      add_line(sep)
    end
    table.insert(highlights, { #lines, 0, -1, 'Comment' })
  end

  add_separator 'Log Entry'
  add_field('Timestamp', entry.timestamp)
  add_field('Level', entry.level and (entry.level .. ' (' .. (entry.module or 'unknown') .. ')'), level_highlights[entry.level])
  add_field('Client', entry.client)
  add_field('PID/TID', entry.pid and entry.tid and (entry.pid .. ':' .. entry.tid), 'Number')
  add_line ''

  if entry.php_error or entry.apache_code or entry.message then
    add_separator 'Error'

    if entry.apache_code and entry.php_error then
      add_line(entry.apache_code .. ': ' .. entry.php_error.type)
      table.insert(highlights, { #lines, 0, #entry.apache_code, 'DiagnosticError' })
    elseif entry.apache_code then
      add_line(entry.apache_code)
      table.insert(highlights, { #lines, 0, #entry.apache_code, 'DiagnosticError' })
    elseif entry.php_error then
      add_line(entry.php_error.type)
      table.insert(highlights, { #lines, 0, -1, 'DiagnosticError' })
    end

    if entry.php_error and entry.php_error.message then
      add_line ''

      for msg_line in entry.php_error.message:gmatch '[^\n]+' do
        add_line(msg_line)
      end
    elseif entry.message then
      add_line ''

      for msg_line in entry.message:gmatch '[^\n]+' do
        add_line(msg_line)
      end
    end

    if entry.php_error and entry.php_error.file then
      add_line ''
      local location = entry.php_error.file .. ':' .. entry.php_error.line
      add_field('Location', location, 'DiagnosticError')
    end
  end

  if entry.stack_trace and #entry.stack_trace > 0 then
    add_line ''
    add_separator 'Stack Trace'

    for _, frame in ipairs(entry.stack_trace) do
      local frame_line
      if frame.file == '{main}' then
        frame_line = string.format('#%d {main}', frame.frame)
      else
        frame_line = string.format('#%d %s:%d', frame.frame, frame.file, frame.line or 0)
        table.insert(highlights, { #lines + 1, 3, #frame_line, 'DiagnosticError' })
      end
      add_line(frame_line)

      if frame.func then
        add_line('   ' .. frame.func)
        table.insert(highlights, { #lines, 3, -1, 'Function' })
      end
    end
  end

  if entry.referer then
    add_line ''
    add_field('Referer', entry.referer, 'String')
  end

  vim.api.nvim_set_option_value('modifiable', true, { buf = state.detail_buf })
  vim.api.nvim_buf_set_lines(state.detail_buf, 0, -1, false, lines)
  vim.api.nvim_set_option_value('modifiable', false, { buf = state.detail_buf })

  for _, hl in ipairs(highlights) do
    local line, col_start, col_end, hl_group = hl[1], hl[2], hl[3], hl[4]
    vim.api.nvim_buf_add_highlight(state.detail_buf, -1, hl_group, line - 1, col_start, col_end)
  end

  vim.api.nvim_buf_set_name(state.detail_buf, 'ApacheLog: Detail')
end

function M.setup_list_keymaps(close_callback)
  if not buf_valid(state.list_buf) then
    return
  end

  local opts = { buffer = state.list_buf, noremap = true, silent = true }

  vim.keymap.set('n', '<CR>', function()
    local line = vim.api.nvim_win_get_cursor(0)[1]
    local entry = state.entries[line]
    if entry then
      M.render_detail(entry)
    else
      vim.notify('ApacheLog: No entry at line ' .. line, vim.log.levels.WARN)
    end
  end, vim.tbl_extend('force', opts, { desc = 'Show log entry detail' }))

  vim.keymap.set('n', 'q', function()
    if close_callback then
      close_callback()
    end
  end, vim.tbl_extend('force', opts, { desc = 'Close Apache Log viewer' }))

  vim.keymap.set('n', 'G', function()
    state.auto_scroll = true
    state.new_count = 0
    vim.cmd 'normal! G'
    update_buffer_name()
  end, vim.tbl_extend('force', opts, { desc = 'Go to end, enable auto-scroll' }))

  vim.keymap.set('n', 'gg', function()
    state.auto_scroll = false
    vim.cmd 'normal! gg'
  end, vim.tbl_extend('force', opts, { desc = 'Go to start, disable auto-scroll' }))
end

function M.setup_detail_keymaps(close_callback)
  if not buf_valid(state.detail_buf) then
    return
  end

  local opts = { buffer = state.detail_buf, noremap = true, silent = true }

  vim.keymap.set('n', 'q', function()
    if close_callback then
      close_callback()
    end
  end, vim.tbl_extend('force', opts, { desc = 'Close Apache Log viewer' }))
end

function M.close_all()
  if state.detail_win and vim.api.nvim_win_is_valid(state.detail_win) then
    vim.api.nvim_win_close(state.detail_win, true)
  end

  if state.list_win and vim.api.nvim_win_is_valid(state.list_win) then
    vim.api.nvim_win_close(state.list_win, true)
  end

  state.list_buf = nil
  state.list_win = nil
  state.detail_buf = nil
  state.detail_win = nil
  state.entries = {}
  state.new_count = 0
  state.auto_scroll = true
end

function M.get_state()
  return state
end

function M.set_auto_scroll(value)
  state.auto_scroll = value
end

return M
