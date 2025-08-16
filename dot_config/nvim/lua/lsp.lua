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
  local function keymap(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc, noremap = true })
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

    -- If the LSP gets detached for any reason, this feature might be lost
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

  keymap("<leader>lD", function()
    vim.lsp.buf.declaration()
  end, "Declarations(s)")
  keymap("<leader>ld", function()
    vim.lsp.buf.definition()
  end, "Definition(s)")
  keymap("<leader>li", function()
    vim.lsp.buf.implementation()
  end, "Implementation(s)")
  keymap("<leader>lr", function()
    vim.lsp.buf.references()
  end, "References")
  keymap("<leader>ls", function()
    vim.lsp.buf.document_symbol()
  end, "Document symbols")
  keymap("<leader>lt", function()
    vim.lsp.buf.type_definition()
  end, "Type definitions")
  keymap("<leader>lI", function()
    vim.lsp.buf.incoming_calls()
  end, "Incoming call(s)")
  keymap("<leader>lO", function()
    vim.lsp.buf.outgoing_calls()
  end, "Outgoing call(s)")
  keymap("<leader>lS", function()
    vim.lsp.buf.workspace_symbol()
  end, "Workspace symbols")

  -- Add support for Codelens if the LSP supports it

  -- Action-oriented LSP keymaps
  -- Formatting is taken care by `conform.nvim` so nothing for that
  keymap("<leader>la", function(opts)
    require("tiny-code-action").code_action(opts)
  end, "Code action(s)")
  keymap("<leader>lR", function()
    require("live-rename").rename()
  end, "Rename symbol")

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
        "json-lsp",
        "ruff",
        "gopls",
      },
    },
  },
  "saecki/live-rename.nvim",
  "b0o/schemastore.nvim",
  { "rachartier/tiny-code-action.nvim", event = "LspAttach", opts = { picker = "snacks" } },
}
