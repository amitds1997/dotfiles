-- This is a test line
-- Is this a test line
local lsp_config = function()
  local lspconfig = require("lspconfig")
  local mason_lspconfig = require("mason-lspconfig")
  local lsp_protocol_methods = vim.lsp.protocol.Methods

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
    "rust_analyzer",
    "texlab",
  }

  local ensure_lsp_installed = {
    node = { "eslint", "tsserver" },
    go = { "gopls" },
    python = { "basedpyright" },
  }

  for binary, lsp in pairs(ensure_lsp_installed) do
    if vim.fn.executable(binary) == 1 then
      for _, lsp_name in ipairs(lsp) do
        table.insert(ensure_installed, lsp_name)
      end
    end
  end

  ---Function to execute on LSP getting attached
  ---@param client vim.lsp.Client
  ---@param bufnr any
  local function on_attach(client, bufnr)
    vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })

    if client.supports_method(lsp_protocol_methods.textDocument_inlayHint) then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end

    -- if client.supports_method(lsp_protocol_methods.textDocument_codeLens) then
    --   vim.lsp.codelens.refresh()
    --   vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
    --     buffer = bufnr,
    --     callback = vim.lsp.codelens.refresh,
    --   })
    -- end

    local bufopts = { buffer = bufnr }
    local wk, lsp_buf = package.loaded["which-key"], vim.lsp.buf

    local wk_maps = {
      ["<leader>l"] = {
        name = "LSP",

        h = { lsp_buf.hover, "Show symbol hover info" },
        s = {
          name = "Symbol actions",

          a = { "<cmd>Lspsaga finder<CR>", "Show all symbol details" },
          c = { "<cmd>Lspsaga finder dec<CR>", "Show symbol declaration" },
          d = { "<cmd>Lspsaga finder def<CR>", "Show symbol definition" },
          i = { "<cmd>Lspsaga finder imp<CR>", "Show symbol implementations" },
          r = { "<cmd>Lspsaga finder ref<CR>", "Show symbol references" },
        },
        g = {
          name = "Go to definition",

          d = { "<cmd>Lspsaga goto_definition<CR>", "Go to definition" },
          t = { "<cmd>Lspsaga goto_type_definition<CR>", "Go to type definition" },
        },
        p = {
          name = "Peek definition",

          d = { "<cmd>Lspsaga peek_definition<CR>", "Peek symbol definition" },
          t = { "<cmd>Lspsaga peek_type_definition<CR>", "Peek symbol type definition" },
        },
        c = {
          name = "Code action + Call hierarchy",

          a = { "<cmd>Lspsaga code_action<CR>", "Show possible code actions" },
          i = { "<cmd>Lspsaga incoming_calls<CR>", "Show all incoming calls" },
          o = { "<cmd>Lspsaga outgoing_calls<CR>", "Show all outgoing calls" },
        },
        d = {
          name = "Document actions",
          o = { "<cmd>Lspsaga outline<CR>", "Show document symbol outline" },
          s = { "<cmd>Telescope lsp_document_symbols<CR>", "Search document symbols" },
        },
        e = {
          name = "Extras",

          o = { require("lspconfig.ui.lspinfo"), "Display attached, active, and configured LSP servers" },
          c = { vim.lsp.codelens.run, "Run codelens on the line" },
        },
        r = { "<cmd>Lspsaga rename<CR>", "Rename symbol" },
        w = {
          name = "Workspace actions",

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

  local capabilities = vim.tbl_deep_extend(
    "force",
    vim.lsp.protocol.make_client_capabilities(),
    require("cmp_nvim_lsp").default_capabilities()
  )

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
      gopls = function()
        lspconfig.gopls.setup({
          on_attach = on_attach,
          capabilities = capabilities,
          settings = require("plugins.lsp-config.gopls"),
        })
      end,
      jsonls = function()
        lspconfig.jsonls.setup({
          on_attach = on_attach,
          capabilities = capabilities,
          settings = require("plugins.lsp-config.jsonls"),
        })
      end,
      yamlls = function()
        lspconfig.yamlls.setup({
          on_attach = on_attach,
          capabilities = capabilities,
          settings = require("plugins.lsp-config.yamlls"),
        })
      end,
      lua_ls = function()
        lspconfig.lua_ls.setup({
          on_attach = on_attach,
          capabilities = capabilities,
          settings = require("plugins.lsp-config.lua_ls"),
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
      basedpyright = function()
        lspconfig.basedpyright.setup({
          on_attach = on_attach,
          capabilities = capabilities,
          settings = require("plugins.lsp-config.basedpyright"),
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
    "nvimdev/lspsaga.nvim",
    "b0o/schemastore.nvim", -- Enable schemas availability for JSON and YAML
    "hrsh7th/cmp-nvim-lsp",
  },
}
