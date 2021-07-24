local M = {}

M.config = function()
  local saga = require 'lspsaga'

  saga.init_lsp_saga({
    use_saga_diagnostic_sign = false,
    max_preview_lines = 10
  })
end

return M
