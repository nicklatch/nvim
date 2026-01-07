local config = require 'apache-log.config'
local parser = require 'apache-log.parser'
local ui = require 'apache-log.ui'
local watcher = require 'apache-log.watcher'

local M = {}

local uv = vim.uv or vim.loop

local state = {
  path = nil,
  autocmd_group = nil,
}

local function read_file(path)
  local fd = uv.fs_open(path, 'r', 438)
  if not fd then
    return nil
  end

  local stat = uv.fs_fstat(fd)
  if not stat then
    uv.fs_close(fd)
    return nil
  end

  local content = uv.fs_read(fd, stat.size, 0)
  uv.fs_close(fd)

  return content
end

local function on_new_content(new_content)
  local new_entries = parser.parse_file(new_content)
  if #new_entries > 0 then
    ui.append_entries(new_entries, state.path)
  end
end

function M.close()
  watcher.stop()

  if state.autocmd_group then
    vim.api.nvim_del_augroup_by_id(state.autocmd_group)
    state.autocmd_group = nil
  end

  ui.close_all()

  state.path = nil
end

function M.open(path)
  if not path or path == '' then
    vim.notify('ApacheLog: Please provide a log file path', vim.log.levels.ERROR)
    return
  end

  path = vim.fn.expand(path)

  local stat = uv.fs_stat(path)
  if not stat then
    vim.notify('ApacheLog: File not found: ' .. path, vim.log.levels.ERROR)
    return
  end

  M.close()

  state.path = path

  local content = read_file(path)
  if not content then
    vim.notify('ApacheLog: Failed to read file: ' .. path, vim.log.levels.ERROR)
    return
  end

  local entries = parser.parse_file(content)

  ui.create_list_buffer()
  ui.open_list_split()
  ui.render_list(entries)
  ui.setup_list_keymaps(M.close)

  local ui_state = ui.get_state()
  if ui_state.list_buf and vim.api.nvim_buf_is_valid(ui_state.list_buf) then
    vim.api.nvim_buf_set_name(ui_state.list_buf, 'ApacheLog: ' .. vim.fn.fnamemodify(path, ':t'))
  end

  ui.set_auto_scroll(config.options.auto_scroll)

  state.autocmd_group = vim.api.nvim_create_augroup('ApacheLog', { clear = true })

  vim.api.nvim_create_autocmd('BufWipeout', {
    group = state.autocmd_group,
    buffer = ui_state.list_buf,
    callback = function()
      watcher.stop()
      state.path = nil
    end,
  })

  watcher.start(path, on_new_content)

  if config.options.auto_scroll and ui_state.list_win and vim.api.nvim_win_is_valid(ui_state.list_win) then
    local line_count = vim.api.nvim_buf_line_count(ui_state.list_buf)
    if line_count > 0 then
      vim.api.nvim_win_set_cursor(ui_state.list_win, { line_count, 0 })
    end
  end

  vim.notify('ApacheLog: Watching ' .. path .. ' (' .. #entries .. ' entries)', vim.log.levels.INFO)
end

function M.setup(opts)
  config.setup(opts)
end

function M.is_open()
  return state.path ~= nil
end

function M.get_path()
  return state.path
end

return M
