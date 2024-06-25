local C = {
  ---@enum border_styles
  -- Shamelessly copied over from: https://github.com/mikesmithgh/borderline.nvim/blob/1bc8237a41f5277b35aaf153635f927aa8fa5224/lua/borderline/borders.lua
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
  kind_icons = {
    Array = " ",
    Class = " ",
    Color = " ",
    Copilot = "󰚩 ",
    Constant = " ",
    Constructor = " ",
    Enum = " ",
    EnumMember = " ",
    Event = " ",
    Field = " ",
    File = " ",
    Folder = " ",
    Function = "󰊕 ",
    Interface = " ",
    Keyword = " ",
    Method = "󰬔 ",
    Module = " ",
    Operator = " ",
    Property = " ",
    Reference = " ",
    Snippet = " ",
    Struct = " ",
    Text = "󰉿 ",
    TypeParameter = " ",
    Unit = " ",
    Value = "󰎠 ",
    Variable = "α",
  },
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
    tsserver = { name = "Typescript LS", priority = 20 },
    yamlls = { name = "YAML LS", priority = 20 },
    cssls = { name = "CSS LS", priority = 20 },
    rust_analyzer = { name = "Rust LS", priority = 20 },
  },
  severity_icons = {
    [vim.diagnostic.severity.ERROR] = "󰅚 ",
    [vim.diagnostic.severity.WARN] = "󰗖 ",
    [vim.diagnostic.severity.INFO] = " ",
    [vim.diagnostic.severity.HINT] = " ",
  },
}

return C
