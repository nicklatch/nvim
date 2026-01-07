local M = {}

local LOG_PATTERN = '^%[([^%]]+)%] %[([^:]+):([^%]]+)%] %[pid (%d+):tid (%d+)%] %[client ([^%]]+)%] (.+)$'
local LOG_PATTERN_ALT = '^%[([^%]]+)%] %[([^:]+):([^%]]+)%] %[pid (%d+):tid (%d+)%] (.+)%[client ([^%]]+)%] (.+)$'
local PHP_ERROR_PATTERN = 'PHP ([^:]+): (.+) in ([^:]+):(%d+)'

local STACK_FRAME_PATTERN = '#(%d+) ([^%(]+)%((%d+)%): (.+)'
local STACK_FRAME_MAIN_PATTERN = '#(%d+) {main}'

local REFERER_PATTERN = ', referer: (.+)$'

function M.unescape_newlines(str)
  if not str then
    return ''
  end
  return str:gsub('\\n', '\n')
end

local function parse_stack_frame(line)
  local frame_num = line:match(STACK_FRAME_MAIN_PATTERN)
  if frame_num then
    return {
      frame = tonumber(frame_num),
      file = '{main}',
      line = nil,
      func = nil,
    }
  end

  local frame, file, line_num, func = line:match(STACK_FRAME_PATTERN)
  if frame then
    return {
      frame = tonumber(frame),
      file = file,
      line = tonumber(line_num),
      func = func,
    }
  end

  return nil
end

function M.parse_stack_trace(message)
  local frames = {}
  local unescaped = M.unescape_newlines(message)

  for line in unescaped:gmatch '[^\n]+' do
    local trimmed = line:match '^%s*(.-)%s*$'
    if trimmed:match '^#%d+' then
      local frame = parse_stack_frame(trimmed)
      if frame then
        table.insert(frames, frame)
      end
    end
  end

  return frames
end

function M.parse_php_error(message)
  if not message then
    return nil
  end

  local error_type, error_msg, file, line = message:match(PHP_ERROR_PATTERN)
  if error_type then
    return {
      type = error_type,
      message = error_msg,
      file = file,
      line = tonumber(line),
    }
  end

  return nil
end

function M.extract_referer(message)
  if not message then
    return nil, message
  end

  local referer = message:match(REFERER_PATTERN)
  if referer then
    local clean_message = message:gsub(REFERER_PATTERN, '')
    return referer, clean_message
  end

  return nil, message
end

local function extract_apache_code(message)
  local code = message:match '^(AH%d+): '
  if code then
    local clean_message = message:gsub('^AH%d+: ', '')
    return code, clean_message
  end

  code = message:match '(AH%d+): '
  if code then
    return code, message
  end
  return nil, message
end

local function extract_php_message(message)
  local php_msg = message:match "Got error 'PHP message: (.+)'$"
  if php_msg then
    return php_msg
  end

  php_msg = message:match "Got error 'PHP message: (.+)"
  if php_msg then
    php_msg = php_msg:gsub("'$", '')
    return php_msg
  end
  return message
end

function M.parse_line(raw_line)
  if not raw_line or raw_line == '' then
    return nil
  end

  local timestamp, module, level, pid, tid, client, message

  timestamp, module, level, pid, tid, client, message = raw_line:match(LOG_PATTERN)

  if not timestamp then
    local prefix_msg
    timestamp, module, level, pid, tid, prefix_msg, client, message = raw_line:match(LOG_PATTERN_ALT)
    if timestamp and prefix_msg then
      message = prefix_msg .. message
    end
  end

  if not timestamp then
    return {
      raw = raw_line,
      timestamp = nil,
      module = nil,
      level = 'unknown',
      pid = nil,
      tid = nil,
      client = nil,
      message = raw_line,
      apache_code = nil,
      php_error = nil,
      stack_trace = {},
      referer = nil,
    }
  end

  local referer, clean_message = M.extract_referer(message)

  local apache_code
  apache_code, clean_message = extract_apache_code(clean_message)

  local php_message = extract_php_message(clean_message)

  local php_error = M.parse_php_error(php_message)

  local stack_trace = M.parse_stack_trace(php_message)

  return {
    raw = raw_line,
    timestamp = timestamp,
    module = module,
    level = level,
    pid = tonumber(pid),
    tid = tonumber(tid),
    client = client,
    message = M.unescape_newlines(php_message),
    apache_code = apache_code,
    php_error = php_error,
    stack_trace = stack_trace,
    referer = referer,
  }
end

function M.create_preview(entry, max_length)
  max_length = max_length or 80

  if not entry then
    return ''
  end

  local parts = {}

  local level_icons = {
    error = 'E',
    warn = 'W',
    warning = 'W',
    notice = 'N',
    info = 'I',
    debug = 'D',
  }
  local level_icon = level_icons[entry.level] or '?'
  table.insert(parts, '[' .. level_icon .. ']')

  if entry.timestamp then
    local short_time = entry.timestamp:match '%d+:%d+:%d+' or entry.timestamp
    table.insert(parts, short_time)
  end

  if entry.php_error then
    table.insert(parts, entry.php_error.type .. ':')
    local short_msg = entry.php_error.message:match '^([^\n]+)' or entry.php_error.message
    table.insert(parts, short_msg)
  elseif entry.message then
    local short_msg = entry.message:match '^([^\n]+)' or entry.message
    table.insert(parts, short_msg)
  end

  local preview = table.concat(parts, ' ')

  if #preview > max_length then
    preview = preview:sub(1, max_length - 3) .. '...'
  end

  return preview
end

function M.parse_file(content)
  local entries = {}

  for line in content:gmatch '[^\n]+' do
    local entry = M.parse_line(line)
    if entry then
      table.insert(entries, entry)
    end
  end

  return entries
end

return M
