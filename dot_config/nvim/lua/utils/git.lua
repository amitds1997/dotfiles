G = {}

function G.get_permalink() end
vim.api.nvim_create_user_command("GetPermalink", function(o)
  vim.system({ "git", "branch", "--show-current" }, { text = true }, function(obj)
    if obj.signal == 0 then
      vim.schedule(function()
        local filename = vim.fn.expand("%:p:~:.")
        if filename == "" then
          vim.notify("Not a valid file")
          return
        end
        local cmd =
          { "gh", "browse", "-n", "-b", obj.stdout:gsub("\n", ""), ("%s:%s-%s"):format(filename, o.line1, o.line2) }
        vim.system(cmd, { text = true }, function(other_obj)
          if other_obj.signal == 0 then
            vim.print("Path is", other_obj.stdout)
          end
        end)
      end)
    else
      vim.notify("Not a Git directory", vim.log.levels.WARN)
    end
  end)
end, {
  desc = "Get permalink for given lines",
  range = true,
})

return G
