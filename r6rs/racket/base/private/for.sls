#!r6rs

(library (r6rs racket base private for)
  (export for/fold
          for*/fold)
  (import (rnrs base (6))
          (r6rs racket base private lambda)
          (r6rs racket base private sequences))

  (define-syntax for/fold-loop
    (syntax-rules ()
      [(_ [rest-id init-expr] result-expr ([(more? get) [id seq-expr]] ...) body-or-break ... body)
       (let*-values ([(more? get) (sequence-generate seq-expr)] ...)
         (define (loop . rest-id)
           (if (and (more?) ...)
               (let-values ([id (get)] ...)
                 (call-with-values (λ () body-or-break ... body) loop))
               result-expr))
         (call-with-values (λ () init-expr) loop))]))

  (define-syntax for/fold
    (syntax-rules (:result :when :unless :do :break :final)
      [(_ [rest-id init-expr] :result result-expr () body-or-break ... body)
       (let*-values ([rest-id init-expr]
                     [rest-id (begin body-or-break ... body)])
         result-expr)]
      [(_ [rest-id init-expr] :result result-expr ([id seq-expr] ...) body-or-break ... body)
       (for/fold-loop [rest-id init-expr] result-expr ([(more? get) [id seq-expr]] ...) body-or-break ... body)]
      [(_ [rest-id init-expr] for-clause body-or-break ... body)
       (for/fold [rest-id init-expr] :result (identity rest-id) for-clause body-or-break ... body)]))
  (define-syntax for*/fold
    (syntax-rules (:when :unless :do :break :final)
      [(_ [rest-id init-expr] :result result-expr () body-or-break ... body)
       (for/fold [rest-id init-expr] :result result-expr () body-or-break ... body)]
      [(_ [rest-id init-expr] :result result-expr ([id seq-expr]) body-or-break ... body)
       (for/fold [rest-id init-expr] :result result-expr ([id seq-expr]) body-or-break ... body)]
      [(_ [rest-id init-expr] :result result-expr ([id1 seq-expr1] [id2 seq-expr2] ...) body-or-break ... body)
       (for/fold [rest-id init-expr]
                 :result result-expr
                 ([id1 seq-expr1])
         (for*/fold [rest-id (identity rest-id)]
                    :result (identity rest-id)
                    ([id2 seq-expr2] ...)
           body-or-break ...
           body))]
      [(_ [rest-id init-expr] for-clause body-or-break ... body)
       (for*/fold [rest-id init-expr] :result (identity rest-id) for-clause body-or-break ... body)]))
  )
