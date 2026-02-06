;; extends

((fenced_code_block
  (info_string) @lang
  (code_fence_content) @content)
 (#eq? @lang "phpx")
 (#set! injection.language "php_only"))

