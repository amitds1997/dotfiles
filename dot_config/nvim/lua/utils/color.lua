local C = {}

---@param c string
local function hexToRgb(c)
  c = string.lower(c)
  return { tonumber(c:sub(2, 3), 16), tonumber(c:sub(4, 5), 16), tonumber(c:sub(6, 7), 16) }
end

---@param foreground string foreground color
---@param background string background color
---@param alpha number|string number between 0 and 1. 0 results in bg, 1 results in fg
local function blend(foreground, background, alpha)
  alpha = type(alpha) == "string" and (tonumber(alpha, 16) / 0xff) or alpha
  local bg = hexToRgb(background)
  local fg = hexToRgb(foreground)

  local blendChannel = function(i)
    local ret = (alpha * fg[i] + ((1 - alpha) * bg[i]))
    return math.floor(math.min(math.max(0, ret), 255) + 0.5)
  end

  return string.format("#%02x%02x%02x", blendChannel(1), blendChannel(2), blendChannel(3))
end

function C.darken(hex, amount, bg)
  if vim.o.background == "dark" then
    -- if the background is dark, lighten instead
    return blend(hex, bg or C.fg, amount)
  end
  return blend(hex, bg or C.bg, amount)
end

function C.lighten(hex, amount, fg)
  if vim.o.background == "light" then
    -- if the background is light, darken instead
    return blend(hex, fg or C.bg, amount)
  end
  return blend(hex, fg or C.fg, amount)
end

--- Gather highlight definitions for a given highlight name and its linked highlights
--- @param hl_name string The name of the highlight group to gather
function C.gather_hl_info(hl_name)
  local gathered_hls = {}

  while hl_name ~= nil do
    local is_ok, hl_def = pcall(vim.api.nvim_get_hl, 0, { name = hl_name })
    if is_ok then
      table.insert(gathered_hls, hl_def)
      hl_name = hl_def.link
    else
      break
    end
  end

  local fin = {}
  if #gathered_hls == 1 then
    fin = gathered_hls[1]
  else
    fin = vim.tbl_deep_extend("keep", fin, unpack(gathered_hls))
  end
  fin["link"] = nil

  return fin
end

return C
