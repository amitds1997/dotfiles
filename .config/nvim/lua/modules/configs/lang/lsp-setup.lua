return function ()
  local lspconfig = require("lspconfig")
  local mason = require("mason")
  local mason_lspconfig = require("mason-lspconfig")

  require("lspconfig.ui.windows").default_options.border = "rounded"

  mason.setup({
    ui = {
      border = "rounded"
    }
  })
  mason_lspconfig.setup({
    ensure_installed = { "pyright", "bashls", "dockerls", "gopls", "clangd", "lua_ls", "jsonls", "marksman" },
    automatic_installation = true,
  })

  -- Neodev: Setup Lua server for plugin development when needed
  require("neodev").setup({
    library = { plugins = { "nvim-dap-ui" }, types = true }
  })

  local ok, trouble = pcall(require, "trouble")
  if not ok then trouble = nil end

  local on_attach = function (_, bufnr)
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    -- Mappings
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)

    vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
    vim.keymap.set({ "n", "i" }, "<C-k>", vim.lsp.buf.signature_help, bufopts)

    if trouble then
      vim.keymap.set("n", "gd", "<cmd>TroubleToggle lsp_definitions<CR>", bufopts)
      vim.keymap.set("n", "gi", "<cmd>TroubleToggle lsp_implementations<CR>", bufopts)
      vim.keymap.set("n", "gr", "<cmd>TroubleToggle lsp_references<CR>", bufopts)
    else
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
      vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
    end

    vim.keymap.set("n", "<Leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set("n", "<Leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set("n", "<Leader>wl", function () print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, bufopts)

    vim.keymap.set("n", "<Leader>D", vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename, bufopts)
    vim.keymap.set("n", "<Leader>ca", vim.lsp.buf.code_action, bufopts)
    vim.keymap.set("n", "<Leader>fc", function () vim.lsp.buf.format({ async = true }) end, bufopts)

    -- Diagnostics mappings
    local diagnostic_opts = { noremap = true, silent = true }
    vim.keymap.set("n", "<Leader>do", vim.diagnostic.open_float, diagnostic_opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, diagnostic_opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, diagnostic_opts)
    vim.keymap.set("n", "<Leader>dq", vim.diagnostic.setloclist, diagnostic_opts)
  end

  local capabilities = require("cmp_nvim_lsp").default_capabilities()

  mason_lspconfig.setup_handlers({
    function (server)
      lspconfig[server].setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })
    end,
    lua_ls = function ()
      lspconfig.lua_ls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          Lua = {
            telemetry = {
              enable = false,
            },
          }
        }
      })
    end,
  })
end
