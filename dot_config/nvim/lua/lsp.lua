local methods = vim.lsp.protocol.Methods

-- By default, codelens are off
vim.g.codelens = vim.g.codelens == true

-- Enable all LSP servers that have been setup in `lsp/` directory
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  once = true,
  callback = function()
    local server_configs = vim
      .iter(vim.api.nvim_get_runtime_file("lsp/*.lua", true))
      :map(function(file)
        return vim.fn.fnamemodify(file, ":t:r")
      end)
      :totable()
    vim.lsp.enable(server_configs)
  end,
})

--- Sets up LSP keymaps and autocommands for the given buffer.
---@param client vim.lsp.Client
---@param bufnr integer
local function on_attach(client, bufnr)
  local function keymap(lhs, rhs, desc, opts)
    local mode = opts and opts["mode"] or "n"
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc, noremap = true })
  end

  -- Handle textDocument/documentHighlight support
  if client:supports_method(methods.textDocument_documentHighlight, bufnr) then
    local under_cursor_highlights_group = require("core.utils").create_augroup("create_highlights", false)

    -- When cursor movement is paused or we jump to the normal mode, enable instance highlighting
    vim.api.nvim_create_autocmd({ "CursorHold", "InsertLeave" }, {
      group = under_cursor_highlights_group,
      desc = "Highlight references under the cursor",
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })

    -- If the cursor has moved or we go to insert mode or close buffer, disable all instance highlighting
    vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter", "BufLeave" }, {
      group = under_cursor_highlights_group,
      desc = "Clear highlight references",
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })

    -- If the LSP gets detached for any reason, we want to make sure things don't persist
    vim.api.nvim_create_autocmd("LspDetach", {
      group = under_cursor_highlights_group,
      desc = "Clear highlight references on LSP detach",
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.clear_references()
        vim.api.nvim_clear_autocmds { group = under_cursor_highlights_group, buffer = bufnr }
      end,
    })
  end

  -- Handle textDocument/onTypeFormatting support
  if client:supports_method(methods.textDocument_onTypeFormatting) and vim.fn.has "nvim-0.12" == 1 then
    vim.lsp.on_type_formatting.enable(true, {
      client_id = client.id,
    })
  end

  -- Handle textDocument/documentColor support
  if client:supports_method(methods.textDocument_documentColor) and vim.fn.has "nvim-0.12" == 1 then
    vim.lsp.document_color.enable(true, bufnr)
    vim.keymap.set(
      { "n", "x" },
      "<leader>lC",
      vim.lsp.document_color.color_presentation,
      { desc = "Color presentation" }
    )
  end

  -- Handle textDocument/codeLens support
  if client:supports_method(methods.textDocument_codeLens) then
    if vim.g.codelens then
      vim.lsp.codelens.refresh { bufnr = bufnr }
    end
    vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
      buffer = bufnr,
      callback = function()
        if vim.g.codelens then
          vim.lsp.codelens.refresh { bufnr = bufnr }
        else
          vim.lsp.codelens.clear(nil, bufnr)
        end
      end,
    })
    keymap("<leader>lcr", vim.lsp.codelens.run, "Run codelens")
    keymap("<leader>lcR", function()
      if vim.g.codelens then
        vim.lsp.codelens.refresh { bufnr = bufnr }
      end
    end, "Refresh codelens")
  end

  if client:supports_method(methods.textDocument_declaration) then
    keymap("<leader>lD", function()
      vim.lsp.buf.declaration()
    end, "Declarations(s)")
  end
  if client:supports_method(methods.textDocument_definition) then
    keymap("<leader>ld", function()
      vim.lsp.buf.definition()
    end, "Definition(s)")
  end
  if client:supports_method(methods.textDocument_implementation) then
    keymap("<leader>li", function()
      vim.lsp.buf.implementation()
    end, "Implementation(s)")
  end
  if client:supports_method(methods.textDocument_references) then
    keymap("<leader>lr", function()
      vim.lsp.buf.references()
    end, "References")
  end
  if client:supports_method(methods.textDocument_documentSymbol) then
    keymap("<leader>ls", function()
      vim.lsp.buf.document_symbol()
    end, "Document symbols")
  end
  if client:supports_method(methods.textDocument_typeDefinition) then
    keymap("<leader>lt", function()
      vim.lsp.buf.type_definition()
    end, "Type definitions")
  end
  if client:supports_method(methods.callHierarchy_incomingCalls) then
    keymap("<leader>lI", function()
      vim.lsp.buf.incoming_calls()
    end, "Incoming call(s)")
  end
  if client:supports_method(methods.callHierarchy_outgoingCalls) then
    keymap("<leader>lO", function()
      vim.lsp.buf.outgoing_calls()
    end, "Outgoing call(s)")
  end
  if client:supports_method(methods.workspace_symbol) then
    keymap("<leader>lS", function()
      vim.lsp.buf.workspace_symbol()
    end, "Workspace symbols")
  end

  -- Action-taking LSP methods
  if client:supports_method(methods.textDocument_codeAction) then
    keymap("<leader>la", function(opts)
      require("tiny-code-action").code_action(opts)
    end, "Code action(s)")
  end
  if client:supports_method(methods.textDocument_rename) then
    keymap("<leader>lR", function()
      require("live-rename").rename()
    end, "Rename symbol", { mode = { "n", "v" } })
  end

  -- Diagnostic keymaps
  keymap("[d", function()
    vim.diagnostic.jump { count = -1 }
  end, "Previous diagnostic")
  keymap("]d", function()
    vim.diagnostic.jump { count = 1 }
  end, "Next diagnostic")
  keymap("[e", function()
    vim.diagnostic.jump { count = -1, severity = vim.diagnostic.severity.ERROR }
  end, "Previous error")
  keymap("]e", function()
    vim.diagnostic.jump { count = 1, severity = vim.diagnostic.severity.ERROR }
  end, "Next error")
end

-- Sometimes, LSP servers do not register all capabilities at once and might
-- dynamically come up with things like "oh, we support so and so", so we need to
-- recall attach so that we have the correct keymaps set up accordingly
local register_capability = vim.lsp.handlers[methods.client_registerCapability]
vim.lsp.handlers[methods.client_registerCapability] = function(err, res, ctx)
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  if not client then
    return
  end

  on_attach(client, vim.api.nvim_get_current_buf())
  return register_capability(err, res, ctx)
end

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "Configure LSP keymaps",
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    assert(client ~= nil, "Client is not available for buffer")

    on_attach(client, args.buf)
  end,
})

return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "yaml-language-server",
        "bash-language-server",
        "basedpyright",
        "rust-analyzer",
        "marksman",
        "json-lsp",
        "ruff",
        "gopls",
        "tombi",
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

          -- Disables indent shown via `mini.indentscope`
          vim.b[buf].disable_indent = true
          vim.wo[win].cocu = "nc"

          -- Hide `#` at beginning of source titles
          vim.cmd [[syntax match HashHeader /^#\+/ conceal]]
        end,
      })
    end,
  },
}
