local function conform_setup()
  local pkg_list = { "stylua", "isort", "black", "sqlfmt", "mdformat", "yamlfix", "shfmt" }

  for _, pkg in ipairs(pkg_list) do
    require("custom.mason_installer"):install(pkg)
  end

  local mdformat = require("mason-registry").get_package("mdformat")
  mdformat:on("install:success", function()
    local pip_path = require("core.utils").path_join(mdformat:get_install_path(), "venv", "bin", "pip")
    local args = { "install", "mdformat-gfm", "mdformat-frontmatter", "mdformat-footnote" }

    require("plenary.job")
      :new({
        command = pip_path,
        args = args,
        on_start = function()
          vim.notify("Installing mdformat dependencies")
        end,
        on_exit = function(_, return_val)
          if return_val == 0 then
            vim.notify("mdformat dependencies installed successfully")
          end
        end,
      })
      :start()
  end)

  local function handle_disabling_formatting(bufnr, default)
    -- Check if formatting has been disabled on the buffer
    if vim.b[bufnr].disable_autoformat then
      return
    end
    return default
  end

  require("conform").setup({
    log_level = vim.log.levels.DEBUG,
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "isort", "black" },
      markdown = { "mdformat", "injected" },
      sql = { "sqlfmt" },
      yaml = { "yamlfix" },
      sh = { "shfmt" },
    },
    format_after_save = function(bufnr)
      return handle_disabling_formatting(bufnr, {
        lsp_fallback = true,
      })
    end,
    formatters = {
      mdformat = {
        prepend_args = { "--number" },
      },
    },
  })

  require("conform").formatters.injected = {
    options = {
      lang_to_formatters = {
        yaml = {}, -- Do not try to format YAML (because it is also used for frontmatter)
      },
    },
  }
end

return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  config = conform_setup,
  cmd = "ConformInfo",
  dependencies = {
    "williamboman/mason.nvim",
    "nvim-lua/plenary.nvim",
  },
}
