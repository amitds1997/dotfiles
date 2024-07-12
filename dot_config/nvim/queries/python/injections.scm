;extends

; Highlight SQL strings with SQL highlighting
(string 
  (string_content) @injection.content
    (#vim-match? @injection.content "^.*(select|SELECT|create|CREATE|drop|DROP|insert|INSERT|update|UPDATE|alter|ALTER).*")
    (#set! injection.language "sql")
    (#offset! @injection.content 0 0 0 0))
