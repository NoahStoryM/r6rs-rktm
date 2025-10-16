#!r6rs

(library (r6rr racket base private lambda)
  (export case-λ λ
          identity)
  (import (rnrs base (6))
          (rename (rnrs control (6)) [case-lambda case-λ]))

  (define-syntax λ-iter
    (syntax-rules ()
      [(_ (v ...) () () b ...)
       (lambda (v ...) b ...)]
      [(_ (v ...) () (c ...) b ...)
       (case-λ c ... [(v ...) b ...])]
      [(_ (v0 ...) ([v1 e1] [v2 e2] ...) (c ...) b ...)
       (λ-iter
        (v0 ... v1)
        ([v2 e2] ...)
        (c ... [(v0 ...) (letrec* ([v1 e1] [v2 e2] ...) b ...)])
        b ...)]
      [(_ (v0 ...) (v1 v2 ...) () b ...)
       (λ-iter (v0 ... v1) (v2 ...) () b ...)]))

  (define-syntax λ
    (syntax-rules ()
      [(_ (v1 v2 ...) b1 b2 ...)
       (λ-iter () (v1 v2 ...) () b1 b2 ...)]
      [(_ v b1 b2 ...)
       (lambda v b1 b2 ...)]))

  (define-syntax identity
    (syntax-rules ()
      [(_ (id ...)) (values id ...)]
      [(_ (id ... . rest-id)) (apply values id ... rest-id)])))
