;; extends

; Highlight HTML in strings
((string_content) @injection.content
  (#lua-match? @injection.content "<")
  (#set! injection.language "html"))

