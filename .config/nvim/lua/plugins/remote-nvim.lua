local remote_nvim = function ()
  require("remote-nvim").setup({
    local_client_config = {
      callback = function (port, workspace_config)
        local cmd = ("wezterm cli set-tab-title --pane-id $(wezterm cli spawn nvim --server localhost:%s --remote-ui) %s")
          :format(port, ("'Remote: %s'"):format(workspace_config.host))
        vim.fn.jobstart(cmd, {
          detach = true,
          on_exit = function (job_id, exit_code, event_type)
            -- This function will be called when the job exits
            print("Job", job_id, "exited with code", exit_code, "Event type:", event_type)
          end,
        })
      end
    }
  })
end

return {
  "amitds1997/remote-nvim.nvim",
  config = remote_nvim,
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
    -- This would be an optional dependency eventually
    "nvim-telescope/telescope.nvim",
  },
}
