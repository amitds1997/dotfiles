vim.api.nvim_create_user_command("GetPermalink", function(o)
  vim.print(vim.inspect(o))
  vim.system({ "git", "branch", "--show-current" }, { text = true }, function(obj)
    if obj.code == 0 then
      vim.schedule(function()
        local filename = vim.fn.expand("%:p:~:.")
        if filename == "" then
          vim.notify("Not a valid file")
          return
        end
        local cmd =
          { "gh", "browse", "-n", "-b", obj.stdout:gsub("\n", ""), ("%s:%s-%s"):format(filename, o.line1, o.line2) }
        vim.system(cmd, { text = true }, function(other_obj)
          if other_obj.code == 0 then
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

vim.keymap.set({ "n", "v" }, "<Leader>gel", function()
  vim.cmd("GetPermalink")
end, { desc = "Get link to lines on remote" })
