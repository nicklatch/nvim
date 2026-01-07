local config = require 'apache-log.config'

local M = {}

-- Use vim.uv (Neovim 0.10+) or vim.loop (older versions)
local uv = vim.uv or vim.loop

-- State
local state = {
  handle = nil,
  timer = nil,
  path = nil,
  last_size = 0,
}

-- Stop watching
function M.stop()
  if state.timer then
    state.timer:stop()
    state.timer:close()
    state.timer = nil
  end

  if state.handle then
    state.handle:stop()
    state.handle:close()
    state.handle = nil
  end

  state.path = nil
  state.last_size = 0
end

-- Start watching a file
-- callback(new_content) is called with new content when file changes
function M.start(path, callback)
  -- Stop any existing watcher
  M.stop()

  -- Validate path exists
  local stat = uv.fs_stat(path)
  if not stat then
    vim.notify('ApacheLog: File not found: ' .. path, vim.log.levels.ERROR)
    return false
  end

  state.path = path
  state.last_size = stat.size

  -- Create debounce timer
  state.timer = uv.new_timer()

  -- Create file watcher
  state.handle = uv.new_fs_event()

  local function on_change()
    -- Read new content
    local new_stat = uv.fs_stat(path)
    if not new_stat then
      return
    end

    -- Only process if file grew
    if new_stat.size <= state.last_size then
      state.last_size = new_stat.size
      return
    end

    -- Read new content from last position
    local fd = uv.fs_open(path, 'r', 438) -- 438 = 0666
    if not fd then
      return
    end

    local new_content = uv.fs_read(fd, new_stat.size - state.last_size, state.last_size)
    uv.fs_close(fd)

    state.last_size = new_stat.size

    if new_content and #new_content > 0 and callback then
      callback(new_content)
    end
  end

  -- Debounced callback
  local function debounced_callback()
    if state.timer then
      state.timer:stop()
      state.timer:start(config.options.debounce_ms, 0, vim.schedule_wrap(on_change))
    end
  end

  -- Start watching
  local success, err = state.handle:start(path, {}, function(err_msg, filename, events)
    if err_msg then
      vim.schedule(function()
        vim.notify('ApacheLog: Watch error: ' .. err_msg, vim.log.levels.ERROR)
      end)
      return
    end
    debounced_callback()
  end)

  if not success then
    vim.notify('ApacheLog: Failed to start watcher: ' .. (err or 'unknown error'), vim.log.levels.ERROR)
    M.stop()
    return false
  end

  return true
end

-- Check if currently watching
function M.is_watching()
  return state.handle ~= nil
end

-- Get current watched path
function M.get_path()
  return state.path
end

return M

-- vim: ts=2 sts=2 sw=2 et
