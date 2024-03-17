local C = {}

---@enum border_styles
-- Shamelessly copied over from: https://github.com/mikesmithgh/borderline.nvim/blob/1bc8237a41f5277b35aaf153635f927aa8fa5224/lua/borderline/borders.lua
C.border_styles = {
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
}

return C
