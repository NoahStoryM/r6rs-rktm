#!r6rs

(library (rktp racket base private aliases)
  (export (rename [lambda λ] [case-lambda case-λ]
                  [not false?]
                  [values identity]))
  (import (rnrs)))
