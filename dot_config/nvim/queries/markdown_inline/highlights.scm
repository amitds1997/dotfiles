;extends

; Target the backslash_escape node
((backslash_escape) @markup.normal
 (#match? @markup.normal "^\\\\_")
 (#set! priority 120)
 (#set! conceal "_"))
