---@diagnostic disable: missing-fields
local function remote_nvim_setup()
  require("remote-nvim").setup {
    offline_mode = {
      enabled = false,
      no_github = false,
    },
    remote = {
      copy_dirs = {
        config = {
          compression = {
            enabled = true,
          },
        },
      },
    },
    client_callback = function(port, wk_config)
      local cmd = ("wezterm cli set-tab-title --pane-id $(wezterm cli spawn nvim --server localhost:%s --remote-ui) %s"):format(
        port,
        ("'Remote: %s'"):format(wk_config.host)
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
  }
end

return {
  "amitds1997/remote-nvim.nvim",
  version = "*",
  config = remote_nvim_setup,
  dependencies = {
    "nvim-lua/plenary.nvim", -- For standard functions
    "MunifTanjim/nui.nvim", -- To build the plugin UI
    "nvim-telescope/telescope.nvim", -- For picking b/w different remote methods
  },
  dev = true,
}
