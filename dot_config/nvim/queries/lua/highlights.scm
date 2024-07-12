;extends

; add highlighting for builtin keywords
; - Neovim API: `vim`
((identifier) @namespace.builtin
  (#any-of? @namespace.builtin "vim"))
