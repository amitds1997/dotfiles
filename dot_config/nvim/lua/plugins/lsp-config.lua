local lsp_config = function()
  local lspconfig = require("lspconfig")
  local python_exec_path = vim.fn.exepath("python")
  local mason_lspconfig = require("mason-lspconfig")

  require("lspconfig.ui.windows").default_options.border = "rounded"

  local ensure_installed = {
    "bashls",
    "dockerls",
    "docker_compose_language_service",
    "clangd",
    "lua_ls",
    "jsonls",
    "marksman",
    "yamlls",
    "ruff_lsp",
  }

  local ensure_lsp_installed = {
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

  local function on_attach(client, bufnr)
    vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })

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
        i = {
          function()
            require("trouble").open("lsp_implementations")
          end,
          "Go to symbol implementations",
        },
        d = {
          function()
            require("trouble").open("lsp_definitions")
          end,
          "Go to symbol definition",
        },
        rr = {
          function()
            require("trouble").open("lsp_references")
          end,
          "Go to symbol references",
        },
        t = {
          function()
            require("trouble").open("lsp_type_definitions")
          end,
          "Go to type definitions",
        },

        -- Show LSP information
        h = { lsp_buf.hover, "Show symbol hover info" },
        s = { lsp_buf.signature_help, "Show symbol signature info" },
        c = { lsp_buf.code_action, "Show code actions" },
        n = { require("nvim-navbuddy").open, "Open symbol tree explorer" },
        o = { require("lspconfig.ui.lspinfo"), "Display attached, active, and configured LSP servers" },

        -- LSP changes
        rn = {
          function()
            return ":IncRename " .. vim.fn.expand("<cword>")
          end,
          "Rename symbol",
          expr = true,
        },
        f = {
          function()
            lsp_buf.format({ async = true })
          end,
          "Format code",
        },

        w = {
          name = "lsp-workspace",

          a = { lsp_buf.add_workspace_folder, "Add workspace folder" },
          r = { lsp_buf.remove_workspace_folder, "Remove workspace folder" },
          l = {
            function()
              vim.notify(vim.inspect(lsp_buf.list_workspace_folders))
            end,
            "List workspace folders",
          },
        },
      },
    }
    wk.register(wk_maps, bufopts)
  end

  local capabilities = require("cmp_nvim_lsp").default_capabilities()
  mason_lspconfig.setup({
    ensure_installed = ensure_installed,
    automatic_installation = true,
    handlers = {
      function(server)
        lspconfig[server].setup({
          on_attach = on_attach,
          capabilities = capabilities,
        })
      end,
      jsonls = function()
        lspconfig.jsonls.setup({
          on_attach = on_attach,
          capabilities = capabilities,
          settings = {
            json = {
              schemas = require("schemastore").json.schemas(),
              validate = { enable = false },
            },
          },
        })
      end,
      yamlls = function()
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
      lua_ls = function()
        lspconfig.lua_ls.setup({
          on_attach = on_attach,
          capabilities = capabilities,
          settings = {
            Lua = {
              runtime = {
                version = "LuaJIT",
              },
            },
            workspace = {
              vim.env.VIMRUNTIME,
            },
          },
        })
      end,
      ruff_lsp = function()
        lspconfig.ruff_lsp.setup({
          on_attach = function(client, bufnr)
            client.server_capabilities.hoverProvider = false
            on_attach(client, bufnr)
          end,
        })
      end,
      pyright = function()
        lspconfig.pyright.setup({
          on_attach = on_attach,
          capabilities = capabilities,
          settings = {
            pyright = {
              disableOrganizeImports = true,
            },
            python = {
              analysis = {
                autoImportCompletions = true,
                autoSearchPaths = true,
                typeCheckingMode = "standard",
                diagnosticMode = "workspace",
                -- Add rules from here: https://microsoft.github.io/pyright/#/configuration?id=type-check-diagnostics-settings
                diagnosticSeverityOverrides = {},
              },
              pythonPath = python_exec_path,
            },
          },
        })
      end,
    },
  })
end

return {
  "neovim/nvim-lspconfig",
  config = lsp_config,
  event = { "BufNewFile", "BufReadPre" },
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "SmiteshP/nvim-navbuddy",
    "smjonas/inc-rename.nvim",
    "b0o/schemastore.nvim", -- Enable schemas availability for JSON and YAML
  },
}
