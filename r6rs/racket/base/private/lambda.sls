#!r6rs

(library (r6rs racket base private lambda)
  (export (rename [case-lambda case-λ]
                  [values identity])
          λ)
  (import (rnrs base (6))
          (rnrs control (6)))

  (define-syntax λ
    (syntax-rules ()
      [(_ (v1 v2 ...) b1 b2 ...)
       (opt-λ () (v1 v2 ...) () b1 b2 ...)]
      [(_ v b1 b2 ...)
       (lambda v b1 b2 ...)]))

  (define-syntax opt-λ
    (syntax-rules ()
      [(_ (v ...) () (c ...) b ...)
       (case-lambda c ... [(v ...) b ...])]
      [(_ (v0 ...) ([v1 e1] [v2 e2] ...) (c ...) b ...)
       (opt-λ
        (v0 ... v1)
        ([v2 e2] ...)
        (c ... [(v0 ...) (let* ([v1 e1] [v2 e2] ...) b ...)])
        b ...)]
      [(_ (v0 ...) (v1 v2 ...) () b ...)
       (opt-λ (v0 ... v1) (v2 ...) () b ...)])))
