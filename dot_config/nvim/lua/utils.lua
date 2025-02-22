local U = {}

function U.create_augroup(name)
  return vim.api.nvim_create_augroup("amitds1997/" .. name, { clear = true })
end

function U.debounce(ms, fn)
  local timer = vim.uv.new_timer()
  return function(...)
    local argv = { ... }

    if not timer then
      vim.notify("Failed to create a timer", vim.log.levels.ERROR)
      return
    end

    timer:start(ms, 0, function()
      timer:stop()
      vim.schedule_wrap(fn)(unpack(argv))
    end)
  end
end

function U.set_keymap(lhs, rhs, desc, mode)
  mode = mode or "n"
  vim.validate {
    mode = { mode, { "string", "table" } },
    desc = { desc, "string" },
  }
  vim.keymap.set(mode, lhs, rhs, { desc = desc })
end

return U
