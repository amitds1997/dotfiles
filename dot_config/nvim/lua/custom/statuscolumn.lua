-- Stole this from `snacks.nvim`
local M = {}

---@private
---@alias SignType "mark"|"git"|"fold"|"sign"
---@alias Sign {name:string, text:string, texthl:string, priority:number, type:SignType}

---@type table<string,string>
local cache = {}
---@type table<number,table<number, Sign[]>>
local sign_cache = {}
---@type table<number,string>
local icon_cache = {}

---@type SignType[]
local left_config = { "mark", "sign" }
---@type SignType[]
local right_config = { "fold", "git" }

---We need to regularly update the statuscolumn, so we need to initiate a timer
---that is able to take care of this for us
local timer = assert(vim.uv.new_timer())
timer:start(50, 50, function()
  sign_cache = {}
  cache = {}
end)

---@private
---@param name string
function M.is_git_sign(name)
  for _, pat in ipairs { "GitSign", "MiniDiffSign" } do
    if name:find(pat) then
      return true
    end
  end
end

---Get all signs and marks (including global) present in buffer
---@private
---@param bufnr integer Buffer no.
---@return table<number, Sign[]> signs All buffer-related signs
function M.get_buf_signs(bufnr)
  ---@type table<number, Sign[]>
  local buf_signs = {}

  -- Add all ext-signs
  local extmarks = vim.api.nvim_buf_get_extmarks(bufnr, -1, 0, -1, { details = true, type = "sign" })
  for _, extmark in pairs(extmarks) do
    local lnum = extmark[2] + 1
    buf_signs[lnum] = buf_signs[lnum] or {}
    local name = extmark[4].sign_hl_group or extmark[4].sign_name or ""
    table.insert(buf_signs[lnum], {
      name = name,
      type = M.is_git_sign(name) and "git" or "sign",
      text = extmark[4].sign_text,
      texthl = extmark[4].sign_hl_group or extmark[4].number_hl_group,
      priority = extmark[4].priority,
    })
  end

  -- Add marks
  local marks = vim.fn.getmarklist(bufnr)
  vim.list_extend(marks, vim.fn.getmarklist())
  for _, mark in ipairs(marks) do
    if mark.pos[1] == bufnr and mark.mark:match "[a-zA-Z]" then
      local lnum = mark.pos[2]
      buf_signs[lnum] = buf_signs[lnum] or {}
      table.insert(buf_signs[lnum], { text = mark.mark:sub(2), texthl = "DiagnosticHint", type = "mark" })
    end
  end

  return buf_signs
end

---Get all signs present on a specific line in the buffer in window
---@private
---@param winr integer Window no.
---@param bufnr integer Buffer no.
---@param lnum integer Line no.
function M.get_line_signs(winr, bufnr, lnum)
  local buf_signs = sign_cache[bufnr]
  if not buf_signs then
    buf_signs = M.get_buf_signs(bufnr)
    sign_cache[bufnr] = buf_signs
  end
  local line_signs = buf_signs[lnum] or {}

  vim.api.nvim_win_call(winr, function()
    if vim.fn.foldclosed(lnum) >= 0 then
      line_signs[#line_signs + 1] =
        { text = vim.opt.fillchars:get().foldclose or "", texthl = "Folded", type = "fold" }
    elseif vim.fn.foldlevel(lnum) > vim.fn.foldlevel(lnum - 1) then
      line_signs[#line_signs + 1] = { text = vim.opt.fillchars:get().foldopen or "", type = "fold" }
    end
  end)

  table.sort(line_signs, function(a, b)
    return (a.priority or 0) > (b.priority or 0)
  end)
  return line_signs
end

---Get icon associated with a particular sign
---@private
---@param sign Sign
function M.icon(sign)
  if not sign then
    return "  "
  end
  local key = (sign.text or "") .. (sign.texthl or "")
  if not icon_cache[key] then
    local text = vim.fn.strcharpart((sign.text or "") .. "  ", 0, 2)
    icon_cache[key] = sign.texthl and ("%#" .. sign.texthl .. "#" .. text .. "%*") or text
  end
  return icon_cache[key]
end

---Find first sign that qualifies type criteria
---@param types SignType[]
---@param signs table<SignType, Sign>
---@return Sign? sign First sign of one of the provided type
local function find_first(types, signs)
  for _, t in ipairs(types) do
    if signs[t] then
      return signs[t]
    end
  end
end

---@private
function M.click_fold_toggle()
  local pos = vim.fn.getmousepos()
  vim.api.nvim_win_set_cursor(pos.winid, { pos.line, 1 })
  vim.api.nvim_win_call(pos.winid, function()
    if vim.fn.foldlevel(pos.line) > 0 then
      vim.cmd "normal! za"
    end
  end)
end

---@private
function M.click_debug_toggle()
  local pos = vim.fn.getmousepos()
  vim.api.nvim_win_set_cursor(pos.winid, { pos.line, 1 })
  vim.api.nvim_win_call(pos.winid, function()
    require("dap").toggle_breakpoint()
  end)
end

---@private
function M._get()
  local win = vim.g.statusline_winid

  local nu = vim.wo[win].number
  local rnu = vim.wo[win].relativenumber
  local show_signs = vim.v.virtnum == 0 and vim.wo[win].signcolumn ~= "no"

  if not (show_signs or nu or rnu) then
    return ""
  end
  local components = { "", "", "" }

  -- Get line number
  if (nu or rnu) and vim.v.virtnum == 0 then
    local num = (rnu and vim.v.relnum ~= 0) and vim.v.relnum or vim.v.lnum
    components[2] = "%=" .. num .. " "
  end

  if show_signs then
    local buf = vim.api.nvim_win_get_buf(win)
    local is_file = vim.bo[buf].buftype == ""
    local signs = M.get_line_signs(win, buf, vim.v.lnum)

    if #signs == 0 then
      components[1] = "  "
      components[3] = is_file and "  " or ""
    else
      ---@type table<SignType, Sign>
      local signs_by_type = {}
      for _, s in ipairs(signs) do
        signs_by_type[s.type] = signs_by_type[s.type] or s
      end

      ---@type Sign?
      local left = find_first(left_config, signs_by_type)
      ---@type Sign?
      local right = find_first(right_config, signs_by_type)

      local git = signs_by_type.git
      if git and left and left.type == "fold" then
        left.texthl = signs_by_type.git.texthl
      end
      if git and right and right.type == "fold" then
        right.texthl = signs_by_type.git.texthl
      end

      components[1] = left and M.icon(left) or "  "
      components[3] = is_file and (right and M.icon(right) or "  ") or ""
    end
  end

  -- Wrap component 3 in fold handler and component 1 in debugging point setter
  components[1] = "%@v:lua.require'custom.statuscolumn'.click_debug_toggle@" .. components[1] .. "%T"
  components[3] = "%@v:lua.require'custom.statuscolumn'.click_fold_toggle@" .. components[3] .. "%T"

  return table.concat(components, "")
end

function M.get()
  local win = vim.g.statusline_winid
  local buf = vim.api.nvim_win_get_buf(win)
  local key = ("%d:%d:%d:%d:%d"):format(win, buf, vim.v.lnum, vim.v.virtnum ~= 0 and 1 or 0, vim.v.relnum)
  if cache[key] then
    return cache[key]
  end
  local ok, ret = pcall(M._get)
  if ok then
    cache[key] = ret
    return ret
  end
  return ""
end

return M
