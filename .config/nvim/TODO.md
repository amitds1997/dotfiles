## Backlog

### Unplanned

- [ ] Setup [scalameta/nvim-metals](https://github.com/scalameta/nvim-metals)
- [ ] Fix too many diagnostics messages in clang when opening neovim project
- [ ] Set correct colors for DAP debugging in `./lua/plugins/dap/nvim-dap-ui.lua`

### Features

- [ ] Select menu to quickly cycle through open buffers (`:Telescope buffers`??)
- [ ] Auto-format on save (Lua)

### Chore

- DAP
    - [ ] Fix nvim-dap-python not picking up virtualenvs
- Session management
    - [ ] `:mkview` and session management
    - [ ] [ahmedkhalf/project.nvim](https://github.com/ahmedkhalf/project.nvim) and co

### Bugs

- [ ] Opening a link from helpbox initiated by `<leader>lh` leads to a buffer where `q` and `<Tab>` do not work
- [ ] E445: Other window contains changes
- [ ] `<Shift-Tab>` should move back instead of forward
- [ ] DAP windows (Window resizing is opposite of what it should be with custom shortcut, actual one works)
