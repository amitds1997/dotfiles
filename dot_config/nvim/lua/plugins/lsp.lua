---@diagnostic disable: missing-fields
return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "yaml-language-server",
        "bash-language-server",
        "basedpyright",
        "typescript-language-server",
        "rust-analyzer",
        "marksman",
        "json-lsp",
        "ruff",
        "gopls",
        "tombi",
        "copilot-language-server",
      },
    },
  },
  "saecki/live-rename.nvim",
  "b0o/schemastore.nvim",
  {
    "rachartier/tiny-code-action.nvim",
    opts = {
      picker = {
        "buffer",
        opts = {
          hotkeys = true,
          hotkeys_mode = "sequential",
        },
      },
    },
    config = function(_, opts)
      require("tiny-code-action").setup(opts)

      vim.api.nvim_create_autocmd("User", {
        pattern = { "TinyCodeActionWindowEnterMain", "TinyCodeActionWindowEnterPreview" },
        callback = function(event)
          local buf = event.data.buf
          local win = event.data.win
          vim.diagnostic.enable(false, { bufnr = buf })

          -- Disables indent shown via `mini.indentscope`
          vim.b[buf].disable_indent = true
        end,
      })
    end,
  },
}
