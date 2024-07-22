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
    "ruff",
    "rust_analyzer",
    "texlab",
    "helm_ls",
    "tailwindcss",
    "volar",
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
      vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
    end

    local wk_maps = {
      { "<leader>lca", "<cmd>Lspsaga code_action<CR>", buffer = bufnr, desc = "Show possible code actions" },
      { "<leader>lci", "<cmd>Lspsaga incoming_calls<CR>", buffer = bufnr, desc = "Show all incoming calls" },
      { "<leader>lco", "<cmd>Lspsaga outgoing_calls<CR>", buffer = bufnr, desc = "Show all outgoing calls" },
      { "<leader>ldo", "<cmd>Lspsaga outline<CR>", buffer = bufnr, desc = "Show document symbol outline" },
      { "<leader>lds", "<cmd>Telescope lsp_document_symbols<CR>", buffer = bufnr, desc = "Search document symbols" },
      { "<leader>lec", vim.lsp.codelens.run, buffer = bufnr, desc = "Run codelens on the line" },
      {
        "<leader>leo",
        require("lspconfig.ui.lspinfo"),
        buffer = bufnr,
        desc = "Display attached, active, and configured LSP servers",
      },
      { "<leader>lgd", "<cmd>Lspsaga goto_definition<CR>", buffer = bufnr, desc = "Go to definition" },
      { "<leader>lgt", "<cmd>Lspsaga goto_type_definition<CR>", buffer = bufnr, desc = "Go to type definition" },
      { "<leader>lh", vim.lsp.buf.hover, buffer = bufnr, desc = "Show symbol hover info" },
      { "<leader>lpd", "<cmd>Lspsaga peek_definition<CR>", buffer = bufnr, desc = "Peek symbol definition" },
      { "<leader>lpt", "<cmd>Lspsaga peek_type_definition<CR>", buffer = bufnr, desc = "Peek symbol type definition" },
      { "<leader>lr", "<cmd>Lspsaga rename<CR>", buffer = bufnr, desc = "Rename symbol" },
      { "<leader>lsa", "<cmd>Lspsaga finder<CR>", buffer = bufnr, desc = "Show all symbol details" },
      { "<leader>lsc", "<cmd>Lspsaga finder dec<CR>", buffer = bufnr, desc = "Show symbol declaration" },
      { "<leader>lsd", "<cmd>Lspsaga finder def<CR>", buffer = bufnr, desc = "Show symbol definition" },
      { "<leader>lsi", "<cmd>Lspsaga finder imp<CR>", buffer = bufnr, desc = "Show symbol implementations" },
      { "<leader>lsr", "<cmd>Lspsaga finder ref<CR>", buffer = bufnr, desc = "Show symbol references" },
      { "<leader>lwa", vim.lsp.buf.add_workspace_folder, buffer = bufnr, desc = "Add workspace folder" },
      {
        "<leader>lwl",
        function()
          vim.notify(vim.inspect(vim.lsp.buf.list_workspace_folders))
        end,
        buffer = bufnr,
        desc = "List workspace folders",
      },
      { "<leader>lwr", vim.lsp.buf.remove_workspace_folder, buffer = bufnr, desc = "Remove workspace folder" },
    }

    require("which-key").add(wk_maps)
  end

  local capabilities = vim.tbl_deep_extend(
    "force",
    vim.lsp.protocol.make_client_capabilities(),
    require("cmp_nvim_lsp").default_capabilities()
  )
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }

  require("lazydev").setup()

  -- If you need to add a manual lspconfig.setup() calls, do it before this call, because
  -- this will always try to install LSP server if available.
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
      bashls = function()
        lspconfig.bashls.setup({
          on_attach = on_attach,
          capabilities = capabilities,
          settings = require("plugins.lsp-config.bashls"),
        })
      end,
      helm_ls = function()
        lspconfig.helm_ls.setup({
          on_attach = on_attach,
          capabilities = capabilities,
          settings = {
            ["helm-ls"] = {
              yamlls = {
                path = "yaml-language-server",
              },
            },
          },
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
      ruff = function()
        lspconfig.ruff.setup({
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
    "b0o/schemastore.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "folke/lazydev.nvim",
    { "towolf/vim-helm", ft = "helm" },
  },
}
