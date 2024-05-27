local remote_nvim_config = function()
  ----@param remote-nvim.config.PluginConfig
  require("remote-nvim").setup({
    offline_mode = {
      enabled = true,
      no_github = false,
    },
    remote = {
      app_name = "weird-nvim",
      copy_dirs = {
        config = {
          base = vim.env.XDG_CONFIG_HOME .. "/weird-nvim", -- Path from where data has to be copied
          dirs = "*", -- Directories that should be copied over. "*" means all directories. To specify a subset, use a list like {"lazy", "mason"} where "lazy", "mason" are subdirectories
          -- under path specified in `base`.
          compression = {
            enabled = false, -- Should compression be enabled or not
            additional_opts = {}, -- Any additional options that should be used for compression. Any argument that is passed to `tar` (for compression) can be passed here as separate elements.
          },
        },
      },
    },
    client_callback = function(port, workspace_config)
      local cmd = ("wezterm cli set-tab-title --pane-id $(wezterm cli spawn nvim --server localhost:%s --remote-ui) %s"):format(
        port,
        ("'Remote: %s'"):format(workspace_config.host)
      )
      if vim.env.TERM == "xterm-kitty" then
        cmd = ("kitty -e nvim --server localhost:%s --remote-ui"):format(port)
      end
      vim.fn.jobstart(cmd, {
        detach = true,
        on_exit = function(job_id, exit_code, event_type)
          -- This function will be called when the job exits
          print("Client", job_id, "exited with code", exit_code, "Event type:", event_type)
        end,
      })
    end,
  })
end

return {
  "amitds1997/remote-nvim.nvim",
  version = "*",
  config = remote_nvim_config,
  event = "CmdlineEnter",
  -- dev = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-telescope/telescope.nvim",
  },
}
