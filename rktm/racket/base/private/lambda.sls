#!r6rs

(library (rktm racket base private lambda)
  (export (rename [case-lambda case-λ]
                  [lambda λ]
                  [values identity]))
  (import (rnrs base)
          (rnrs control)))
