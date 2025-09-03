---@class toggle.Opts
---@field id? string
---@field name string
---@field get fun(): boolean
---@field set fun(state: boolean)
---@field notify? boolean
---@field disable_toggle? boolean
---@field map? fun(mode: string|string[], lhs: string, rhs: string|fun(), opts?: vim.keymap.set.Opts)

---@class toggle.Class
---@field opts toggle.Opts
local Toggle = {}
Toggle.__index = Toggle

local M = setmetatable({}, {
  -- selene: allow(shadowing)
  __call = function(M, ...)
    return M.new(...)
  end,
})

---@type table<string, toggle.Class>
M.toggles = {}

---@param ... toggle.Opts
function M.new(...)
  local self = setmetatable({}, Toggle)
  self.opts = vim.tbl_deep_extend("force", { notify = false, map = vim.keymap.set, disable_toggle = false }, ...)
  local id = self.opts.name:lower():gsub("%W+", "_"):gsub("_+$", ""):gsub("^_+", "")
  self.opts.id = id
  M.toggles[id] = self
  return self
end

function M.get(id)
  if not M.toggles[id] and M[id] then
    M[id]()
  end
  return M.toggles[id]
end

function Toggle:get()
  local ok, ret = pcall(self.opts.get)
  if not ok then
    vim.notify_once(
      table.concat({
        "Failed to get state for `" .. self.opts.name .. "` toggle:",
        ret,
      }, "\n"),
      vim.log.levels.ERROR,
      {
        title = self.opts.name,
      }
    )
    return false
  end
  return ret
end

---@param state boolean
function Toggle:set(state)
  local ok, ret = pcall(self.opts.set, state) --@type boolean, string?
  if not ok then
    vim.notify_once(
      table.concat({
        "Failed to set state for `" .. self.opts.name .. "` toggle:",
        ret,
      }, "\n"),
      vim.log.levels.ERROR,
      {
        title = self.opts.name,
      }
    )
  end
end

function Toggle:toggle()
  local state = self:get()
  self:set(not state)
  local new_state = self:get()
  if state == new_state then
    vim.notify_once("Toggle `" .. self.opts.name .. "` did not change state", vim.log.levels.WARN)
  end
  if self.opts.notify then
    local enable_status = self.opts.disable_toggle ~= new_state
    local status = enable_status and "enabled" or "disabled"
    vim.notify(
      "`" .. self.opts.name .. "` is " .. status,
      enable_status and vim.log.levels.INFO or vim.log.levels.WARN,
      {
        title = self.opts.name,
      }
    )
  end
end

---@param keys string
---@param opts? vim.keymap.set.Opts | { mode: string|string[]}
function Toggle:map(keys, opts)
  opts = opts or {}
  local mode = opts.mode or "n"
  opts.mode = nil
  opts.desc = opts.desc or ("Toggle " .. self.opts.name)
  self.opts.map(mode, keys, function()
    self:toggle()
  end, opts)
end

---@param option string
---@param opts? {on?: unknown, off?: unknown, global?: boolean}
function M.option(option, opts)
  opts = opts or {}
  local on = opts.on == nil and true or opts.on
  local off = opts.off ~= nil and opts.off or false
  return M.new({
    id = option,
    name = option,
    get = function()
      if opts.global then
        return vim.opt[option]:get() == on
      end
      return vim.opt_local[option]:get() == on
    end,
    set = function(state)
      if opts.global then
        vim.opt[option] = state and on or off
        return
      end
      vim.opt_local[option] = state and on or off
    end,
  }, opts)
end

return M
