---@diagnostic disable:missing-fields
local remote_nvim_config = function()
  ----@param remote-nvim.config.PluginConfig
  require("remote-nvim").setup({
    offline_mode = {
      enabled = true,
      no_github = false,
    },
    remote = {
      copy_dirs = {
        config = {
          compression = {
            enabled = true,
            -- additional_opts = { "--exclude-vcs" },
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
  dev = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-telescope/telescope.nvim",
  },
}
