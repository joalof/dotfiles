;; extends
;; matches X, Y, Z, X_foo, etc used in many Python ML libraries
(
  (identifier) @variable.extra
  (#match? @variable.extra "^[XYZ]+[_a-z]*$")
)

;; these are not highlighted correctly
(
  (identifier) @type
  (#match? @type "^(int|float|str|bool)$")
)
