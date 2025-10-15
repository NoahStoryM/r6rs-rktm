#!r6rs

(library (r6rs racket base private lambda)
  (export (rename [case-lambda case-λ])
          λ
          identity)
  (import (rnrs base (6))
          (rnrs control (6)))

  (define-syntax opt-λ
    (syntax-rules ()
      [(_ (v ...) () () b ...)
       (lambda (v ...) b ...)]
      [(_ (v ...) () (c ...) b ...)
       (case-lambda c ... [(v ...) b ...])]
      [(_ (v0 ...) ([v1 e1] [v2 e2] ...) (c ...) b ...)
       (opt-λ
        (v0 ... v1)
        ([v2 e2] ...)
        (c ... [(v0 ...) (letrec* ([v1 e1] [v2 e2] ...) b ...)])
        b ...)]
      [(_ (v0 ...) (v1 v2 ...) () b ...)
       (opt-λ (v0 ... v1) (v2 ...) () b ...)]))

  (define-syntax λ
    (syntax-rules ()
      [(_ (v1 v2 ...) b1 b2 ...)
       (opt-λ () (v1 v2 ...) () b1 b2 ...)]
      [(_ v b1 b2 ...)
       (lambda v b1 b2 ...)]))

  (define-syntax identity
    (syntax-rules ()
      [(_ (id ...)) (values id ...)]
      [(_ (id ... . rest-id)) (apply values id ... rest-id)])))
