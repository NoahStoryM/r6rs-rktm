#!r6rs

(library (rktp racket base private begin)
  (export begin0)
  (import (rnrs)
          (rktp racket base private define))

  (define-syntax-rule (begin0 b0 b* ...)
    (let ([v b0]) b* ... v)))
