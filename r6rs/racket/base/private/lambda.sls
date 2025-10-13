#!r6rs

(library (r6rs racket base private lambda)
  (export (rename [case-lambda case-λ]
                  [values identity])
          λ)
  (import (rnrs base)
          (rnrs control))

  (define-syntax λ
    (syntax-rules ()
      [(_ ([v1 e1]) b1 b2 ...)
       (case-lambda
         [() (let ([v1 e1]) b1 b2 ...)]
         [(v1) b1 b2 ...])]
      [(_ ([v1 e1] [v2 e2]) b1 b2 ...)
       (case-lambda
         [() (let* ([v1 e1] [v2 e2]) b1 b2 ...)]
         [(v1) (let ([v2 e2]) b1 b2 ...)]
         [(v1 v2) b1 b2 ...])]
      [(_ ([v1 e1] [v2 e2] [v3 e3]) b1 b2 ...)
       (case-lambda
         [() (let* ([v1 e1] [v2 e2] [v3 e3]) b1 b2 ...)]
         [(v1) (let* ([v2 e2] [v3 e3]) b1 b2 ...)]
         [(v1 v2) (let ([v3 e3]) b1 b2 ...)]
         [(v1 v2 v3) b1 b2 ...])]
      [(_ ([v1 e1] [v2 e2] [v3 e3] [v4 e4]) b1 b2 ...)
       (case-lambda
         [() (let* ([v1 e1] [v2 e2] [v3 e3] [v4 e4]) b1 b2 ...)]
         [(v1) (let* ([v2 e2] [v3 e3] [v4 e4]) b1 b2 ...)]
         [(v1 v2) (let* ([v3 e3] [v4 e4]) b1 b2 ...)]
         [(v1 v2 v3) (let ([v4 e4]) b1 b2 ...)]
         [(v1 v2 v3 v4) b1 b2 ...])]
      [(_ ([v1 e1] [v2 e2] [v3 e3] [v4 e4] [v5 e5]) b1 b2 ...)
       (case-lambda
         [() (let* ([v1 e1] [v2 e2] [v3 e3] [v4 e4] [v5 e5]) b1 b2 ...)]
         [(v1) (let* ([v2 e2] [v3 e3] [v4 e4] [v5 e5]) b1 b2 ...)]
         [(v1 v2) (let* ([v3 e3] [v4 e4] [v5 e5]) b1 b2 ...)]
         [(v1 v2 v3) (let* ([v4 e4] [v5 e5]) b1 b2 ...)]
         [(v1 v2 v3 v4) (let ([v5 e5]) b1 b2 ...)]
         [(v1 v2 v3 v4 v5) b1 b2 ...])]
      [(_ (v* ... [v1 e1]) b1 b2 ...)
       (case-lambda
         [(v* ...) (let ([v1 e1]) b1 b2 ...)]
         [(v* ... v1) b1 b2 ...])]
      [(_ (v* ... [v1 e1] [v2 e2]) b1 b2 ...)
       (case-lambda
         [(v* ...) (let* ([v1 e1] [v2 e2]) b1 b2 ...)]
         [(v* ... v1) (let ([v2 e2]) b1 b2 ...)]
         [(v* ... v1 v2) b1 b2 ...])]
      [(_ (v* ... [v1 e1] [v2 e2] [v3 e3]) b1 b2 ...)
       (case-lambda
         [(v* ...) (let* ([v1 e1] [v2 e2] [v3 e3]) b1 b2 ...)]
         [(v* ... v1) (let* ([v2 e2] [v3 e3]) b1 b2 ...)]
         [(v* ... v1 v2) (let ([v3 e3]) b1 b2 ...)]
         [(v* ... v1 v2 v3) b1 b2 ...])]
      [(_ (v* ... [v1 e1] [v2 e2] [v3 e3] [v4 e4]) b1 b2 ...)
       (case-lambda
         [(v* ...) (let* ([v1 e1] [v2 e2] [v3 e3] [v4 e4]) b1 b2 ...)]
         [(v* ... v1) (let* ([v2 e2] [v3 e3] [v4 e4]) b1 b2 ...)]
         [(v* ... v1 v2) (let* ([v3 e3] [v4 e4]) b1 b2 ...)]
         [(v* ... v1 v2 v3) (let ([v4 e4]) b1 b2 ...)]
         [(v* ... v1 v2 v3 v4) b1 b2 ...])]
      [(_ (v* ... [v1 e1] [v2 e2] [v3 e3] [v4 e4] [v5 e5]) b1 b2 ...)
       (case-lambda
         [(v* ...) (let* ([v1 e1] [v2 e2] [v3 e3] [v4 e4] [v5 e5]) b1 b2 ...)]
         [(v* ... v1) (let* ([v2 e2] [v3 e3] [v4 e4] [v5 e5]) b1 b2 ...)]
         [(v* ... v1 v2) (let* ([v3 e3] [v4 e4] [v5 e5]) b1 b2 ...)]
         [(v* ... v1 v2 v3) (let* ([v4 e4] [v5 e5]) b1 b2 ...)]
         [(v* ... v1 v2 v3 v4) (let ([v5 e5]) b1 b2 ...)]
         [(v* ... v1 v2 v3 v4 v5) b1 b2 ...])]
      [(_ v b1 b2 ...)
       (lambda v b1 b2 ...)])))
