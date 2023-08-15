## Backlog

### Unplanned

- [ ] Fix the startup time caused by last line remembering code
- [ ] Setup [scalameta/nvim-metals](https://github.com/scalameta/nvim-metals)
- [ ] Fix too many diagnostics messages in clang when opening neovim project
- [ ] Set correct colors for DAP debugging in `./lua/plugins/dap/nvim-dap-ui.lua`

### Features

- [ ] Select menu to quickly cycle through open buffers (`:Telescope buffers`??)
- [ ] Auto-format on save (Lua)

### Chore

- DAP
    - [ ] Add winbar to every DAP window. Interesting observation: The README of the [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui) already has what I would need 🤔
    - [ ] Setup correct options to start and close windows
    - [ ] Add debug adapter
        - [ ] Configure Lua adapter
            - Handle termination
        - [ ] Python adapter
    - [ ] Completion in DAP: [cmp-dap](https://github.com/rcarriga/cmp-dap)
    - [ ] Do we need this? [nvim-dap-repl-highlights](https://github.com/LiadOz/nvim-dap-repl-highlights)
- LSP 
    - [ ] Code path in winbar
    - [ ] Syntax-based navigation
    - [ ] Syntax tree browser (LSP syntax tree) - [symbols-outline.nvim](https://github.com/simrat39/symbols-outline.nvim)
    - [ ] Syntax based code folding
- Session management
    - [ ] `:mkview` and session management
    - [ ] [ahmedkhalf/project.nvim](https://github.com/ahmedkhalf/project.nvim) and co

### Bugs

- [ ] Nvim-tree fix last window cannot close error
- [ ] Opening a link from helpbox initiated by `k` leads to a buffer where `q` and `<Tab>` do not work
- [ ] E445: Other window contains changes
- [ ] `<Shift-Tab>` should move back instead of forward
