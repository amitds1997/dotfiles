local M = require("lualine.component"):extend()

M.processing = false
M.spinner_index = 1
M.last_update_time = 0
M.current_text = ""

local spinner_symbols = {
  "⠋",
  "⠙",
  "⠹",
  "⠸",
  "⠼",
  "⠴",
  "⠦",
  "⠧",
  "⠇",
  "⠏",
}
local spinner_symbols_len = 10

-- Initializer
function M:init(options)
  M.super.init(self, options)

  local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})

  vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "CodeCompanionRequest*",
    group = group,
    callback = function(request)
      event = request.match
      if event == "CodeCompanionRequestStarted" then
        self.processing = true
        M.current_text = "Thinking..."
      elseif event == "CodeCompanionRequestStreaming" then
        M.current_text = "Receiving..."
      elseif event == "CodeCompanionToolStarted" then
        M.current_text = "Using tools..."
      elseif event == "CodeCompanionToolFinished" then
        M.current_text = "Processing tool output..."
      elseif event == "CodeCompanionToolsFinished" then
        M.current_text = ""
      elseif event == "CodeCompanionRequestFinished" then
        self.processing = false
        M.current_text = ""
      end
    end,
  })
end

-- Function that runs every time statusline is updated
function M:update_status()
  if self.processing then
    self.spinner_index = (self.spinner_index % spinner_symbols_len) + 1
    return M.current_text .. " " .. spinner_symbols[self.spinner_index]
  else
    return nil
  end
end

return M
