local lsp_config = function ()
  local lspconfig                                        = require("lspconfig")
  local mason_lspconfig                                  = require("mason-lspconfig")

  require("lspconfig.ui.windows").default_options.border = "rounded"

  local ensure_installed                                 = { "bashls", "dockerls", "clangd", "lua_ls", "jsonls",
    "marksman", "yamlls" }

  local ensure_lsp_installed                             = {
    node = { "eslint", "tsserver", "pyright" },
    go = { "gopls" },
  }

  for binary, lsp in pairs(ensure_lsp_installed) do
    if vim.fn.executable(binary) == 1 then
      for _, lsp_name in ipairs(lsp) do
        table.insert(ensure_installed, lsp_name)
      end
    end
  end

  mason_lspconfig.setup({
    ensure_installed = ensure_installed,
    automatic_installation = true,
  })

  local on_attach = function (client, bufnr)
    vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })

    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_create_autocmd({ "BufWritePre" }, {
        group = vim.api.nvim_create_augroup("AutoLspFormatting", { clear = true }),
        pattern = "*",
        command = [[lua vim.lsp.buf.format()]],
      })
    end

    if client.server_capabilities.documentSymbolProvider then
      require("nvim-navbuddy").attach(client, bufnr)
    end

    local bufopts = { buffer = bufnr }
    local wk, lsp_buf = package.loaded["which-key"], vim.lsp.buf

    local wk_maps = {
      ["<leader>l"] = {
        name = "lsp",

        -- LSP movements
        D = { lsp_buf.declaration, "Go to symbol declaration" },
        i = { function () require("trouble").open("lsp_implementations") end, "Go to symbol implementations" },
        d = { function () require("trouble").open("lsp_definitions") end, "Go to symbol definition" },
        r = { function () require("trouble").open("lsp_references") end, "Go to symbol references" },
        t = { function () require("trouble").open("lsp_type_definitions") end, "Go to type definitions" },

        -- Show LSP information
        h = { lsp_buf.hover, "Show symbol hover info" },
        s = { lsp_buf.signature_help, "Show symbol signature info" },
        c = { lsp_buf.code_action, "Show code actions" },
        n = { require("nvim-navbuddy").open, "Open symbol tree explorer" },
        o = { require("lspconfig.ui.lspinfo"), "Display attached, active, and configured LSP servers" },

        -- LSP changes
        R = { lsp_buf.rename, "Rename symbol" },
        f = { function () lsp_buf.format({ async = true }) end, "Format code" },

        w = {
          name = "lsp-workspace",

          a = { lsp_buf.add_workspace_folder, "Add workspace folder" },
          r = { lsp_buf.remove_workspace_folder, "Remove workspace folder" },
          l = { function ()
            vim.notify(vim.inspect(lsp_buf.list_workspace_folders))
          end, "List workspace folders" },
        },
      },
    }
    wk.register(wk_maps, bufopts)
  end

  local capabilities = require("cmp_nvim_lsp").default_capabilities()

  mason_lspconfig.setup_handlers({
    function (server)
      lspconfig[server].setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })
    end,
    jsonls = function ()
      lspconfig.jsonls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = false },
          }
        }
      })
    end,
    yamlls = function ()
      lspconfig.yamlls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          yaml = {
            schemaStore = {
              enable = false,
              url = "",
            },
            schemas = require("schemastore").yaml.schemas(),
          },
        },
      })
    end,
    lua_ls = function ()
      lspconfig.lua_ls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT",
            },
          },
        },
      })
    end,
  })
end

return {
  "neovim/nvim-lspconfig",
  config = lsp_config,
  event = { "BufNewFile", "BufReadPre" },
  dependencies = {
    {
      "williamboman/mason.nvim",
      cmd = "Mason",
      opts = {
        ui = { border = "rounded" },
      },
    },
    "williamboman/mason-lspconfig.nvim",
    "SmiteshP/nvim-navbuddy",
    "b0o/schemastore.nvim", -- Enable schemas availability for JSON and YAML
  },
}
