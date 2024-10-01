local C = {
  ---@enum border_styles
  -- Copied from: https://github.com/mikesmithgh/borderline.nvim/blob/1bc8237a41f5277b35aaf153635f927aa8fa5224/lua/borderline/borders.lua
  border_styles = {
    -- no border
    none = { "", "", "", "", "", "", "", "" },
    -- ╔═══╗
    -- ║   ║
    -- ╚═══╝
    double = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" },
    -- ┌───┐
    -- │   │
    -- └───┘
    single = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
    -- ```
    --     ░  where ░ is ' ' with highlight 'FloatShadowThrough'
    --     ▒    and ▒ is ' ' with highlight 'FloatShadow'
    -- ░▒▒▒▒
    -- ```
    shadow = {
      "",
      "",
      { " ", "FloatShadowThrough" },
      { " ", "FloatShadow" },
      { " ", "FloatShadow" },
      { " ", "FloatShadow" },
      { " ", "FloatShadowThrough" },
      "",
    },
    -- ╭───╮
    -- │   │
    -- ╰───╯
    rounded = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    -- █████ where █ is ' '
    -- █   █
    -- █████
    solid = { " ", " ", " ", " ", " ", " ", " ", " " },
    -- ▛▀▀▀▜
    -- ▌   ▐
    -- ▙▄▄▄▟
    block = { "▛", "▀", "▜", "▐", "▟", "▄", "▙", "▌" },
    -- ▄▄▄
    -- ▌ ▐
    -- ▀▀▀
    inner_block = { " ", "▄", " ", "▌", " ", "▀", " ", "▐" },
    -- 🭽▔▔▔🭾
    -- ▏   ▕
    -- 🭼▁▁▁🭿
    thinblock = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" },
    --  ▁▁▁
    -- ▕   ▏
    --  ▔▔▔
    inner_thinblock = { " ", "▁", " ", "▏", " ", "▔", " ", "▕" },
    -- •••••
    -- •   •
    -- •••••
    bullet = { "•", "•", "•", "•", "•", "•", "•", "•" },
    -- ```
    -- *****
    -- *   *
    -- *****
    -- ```
    star = { "*", "*", "*", "*", "*", "*", "*", "*" },
    -- ```
    -- +---+
    -- |   |
    -- +---+
    -- ```
    simple = { "+", "-", "+", "|", "+", "-", "+", "|" },
    -- ┏━━━┓
    -- ┃   ┃
    -- ┗━━━┛
    heavy_single = { "┏", "━", "┓", "┃", "┛", "━", "┗", "┃" },
    -- ░░░░░
    -- ░   ░
    -- ░░░░░
    light_shade = { "░", "░", "░", "░", "░", "░", "░", "░" },
    -- ▒▒▒▒▒
    -- ▒   ▒
    -- ▒▒▒▒▒
    medium_shade = { "▒", "▒", "▒", "▒", "▒", "▒", "▒", "▒" },
    -- ▓▓▓▓▓
    -- ▓   ▓
    -- ▓▓▓▓▓
    dark_shade = { "▓", "▓", "▓", "▓", "▓", "▓", "▓", "▓" },
    -- ↗→→→↘
    -- ↓   ↑
    -- ↖←←←↙
    arrow = { "↗", "→", "↘", "↓", "↙", "←", "↖", "↑" },
    -- █████
    -- █   █
    -- █████
    full_block = { "█", "█", "█", "█", "█", "█", "█", "█" },
    -- ┌───┐
    -- │   │
    -- └───┘
    -- where all characters are highlighted with the highlight `DiffText`
    diff = {
      { "┌", "DiffText" },
      { "─", "DiffText" },
      { "┐", "DiffText" },
      { "│", "DiffText" },
      { "┘", "DiffText" },
      { "─", "DiffText" },
      { "└", "DiffText" },
      { "│", "DiffText" },
    },
  },
  icons = {
    NeovimIcon = "",
    ScrollText = "",
    GitBranch = "",
    Ellipsis = "...",
  },
  -- Used in completion menu for LSP completions
  kind_icons = {
    Array = { icon = " ", hl = "LspKindArray" },
    Boolean = { icon = " ", hl = "LspKindBoolean" },
    Class = { icon = " ", hl = "LspKindClass" },
    Color = { icon = " ", hl = "LspKindColor" },
    Component = { icon = "󰅴 ", "Function" },
    Constant = { icon = " ", hl = "LspKindConstant" },
    Constructor = { icon = " ", hl = "LspKindConstructor" },
    Enum = { icon = " ", hl = "LspKindEnum" },
    EnumMember = { icon = " ", hl = "LspKindEnumMember" },
    Event = { icon = " ", hl = "LspKindEvent" },
    Field = { icon = " ", hl = "LspKindField" },
    File = { icon = " ", hl = "LspKindFile" },
    Folder = { icon = " ", hl = "LspKindFolder" },
    Fragment = { icon = "󰅴 ", hl = "Constant" },
    Function = { icon = "ƒ", hl = "LspKindFunction" },
    Interface = { icon = " ", hl = "LspKindInterface" },
    Key = { icon = "󰌋", hl = "LspKindKey" },
    Keyword = { icon = " ", hl = "LspKindKeyword" },
    Macro = { icon = " ", hl = "Function" },
    Method = { icon = "󰬔 ", hl = "LspKindMethod" },
    Module = { icon = " ", hl = "LspKindModule" },
    Namespace = { icon = "󰌗 ", hl = "LspKindNamespace" },
    Null = { icon = "␀ ", hl = "LspKindNull" },
    Number = { icon = "#", hl = "LspKindNumber" },
    Object = { icon = "O", hl = "LspKindObject" },
    Operator = { icon = " ", hl = "LspKindOperator" },
    Package = { icon = " ", hl = "LspKindPackage" },
    Parameter = { icon = " ", hl = "Identifier" },
    Property = { icon = " ", hl = "LspKindProperty" },
    Reference = { icon = " ", hl = "LspKindReference" },
    Snippet = { icon = " ", hl = "LspKindSnippet" },
    StaticMethod = { icon = "󰬔 ", hl = "Function" },
    String = { icon = " ", hl = "LspKindString" },
    Struct = { icon = " ", hl = "LspKindStruct" },
    Text = { icon = "󰉿 ", hl = "LspKindText" },
    TypeAlias = { icon = "󰁥 ", hl = "Type" },
    TypeParameter = { icon = " ", hl = "LspKindTypeParameter" },
    Unit = { icon = " ", hl = "LspKindUnit" },
    Value = { icon = "󰎠 ", hl = "LspKindValue" },
    Variable = { icon = "α", hl = "LspKindVariable" },
  },
  -- Provide pretty names to LSPs in the status line
  lsps = {
    bashls = { name = "Bash LS", priority = 20 },
    clangd = { name = "Clang LS", priority = 20 },
    dockerls = { name = "Docker LS", priority = 20 },
    eslint = { name = "ESLint", priority = 15 },
    gopls = { name = "Go LS", priority = 20 },
    jsonls = { name = "JSON LS", priority = 20 },
    lua_ls = { name = "Lua LS", priority = 20 },
    marksman = { name = "Marksman", priority = 20 },
    basedpyright = { name = "Python LS", priority = 20 },
    ruff = { name = "Ruff LS", priority = 15 },
    terraformls = { name = "Terraform LS", priority = 20 },
    ts_ls = { name = "Typescript LS", priority = 20 },
    yamlls = { name = "YAML LS", priority = 20 },
    cssls = { name = "CSS LS", priority = 20 },
    rust_analyzer = { name = "Rust LS", priority = 20 },
  },
  -- Use custom icons for diagnostic messages
  severity_icons = {
    [vim.diagnostic.severity.ERROR] = "󰅚 ",
    [vim.diagnostic.severity.WARN] = "󰗖 ",
    [vim.diagnostic.severity.INFO] = " ",
    [vim.diagnostic.severity.HINT] = " ",
  },
}

return C
