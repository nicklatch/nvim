local M = {}

M.defaults = {
  auto_scroll = true,
  list_width = 0.5,
  detail_height = 0.4,
  debounce_ms = 200,
  truncate_length = 80,
}

M.options = vim.deepcopy(M.defaults)

function M.setup(opts)
  M.options = vim.tbl_deep_extend('force', M.defaults, opts or {})
end

return M

-- vim: ts=2 sts=2 sw=2 et
