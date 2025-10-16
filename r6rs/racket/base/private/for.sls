#!r6rs

(library (r6rs racket base private for)
  (export :result :length :fill
          :when :unless :do
          :break :final
          for/foldl for*/foldl)
  (import (rnrs base (6))
          (r6rs racket base private lambda)
          (r6rs racket base private sequences)
          (r6rs racket undefined))

  (define :result undefined)
  (define :length undefined)
  (define :fill undefined)
  (define :when undefined)
  (define :unless undefined)
  (define :do undefined)
  (define :break undefined)
  (define :final undefined)

  (define-syntax for/foldl-loop
    (syntax-rules ()
      [(_ [rest-id init-expr]
          result-expr
          ([(more?1 get1) [id1 seq-expr1]] ...)
          ([id2 seq-expr2] [id3 seq-expr3] ...)
          body-or-break ... body)
       (for/foldl-loop [rest-id init-expr]
                       result-expr
                       ([(more?1 get1) [id1 seq-expr1]]
                        ...
                        [(more?2 get2) [id2 seq-expr2]])
                       ([id3 seq-expr3] ...)
         body-or-break ... body)]
      [(_ [rest-id init-expr]
          result-expr
          ([(more? get) [id seq-expr]] ...)
          ()
         body-or-break ... body)
       (let-values ([(more? get) (sequence-generate seq-expr)] ...)
         (define (loop . rest-id)
           (if (and (more?) ...)
               (let-values ([id (get)] ...)
                 (call-with-values (λ () body-or-break ... body) loop))
               result-expr))
         (call-with-values (λ () init-expr) loop))]))

  (define-syntax for/foldl
    (syntax-rules (:result :when :unless :do :break :final)
      [(_ [rest-id init-expr]
          :result result-expr
          ()
         body-or-break ... body)
       (let*-values ([rest-id init-expr]
                     [rest-id (begin body-or-break ... body)])
         result-expr)]
      [(_ [rest-id init-expr]
          :result result-expr
          ([id seq-expr] ...)
         body-or-break ... body)
       (for/foldl-loop [rest-id init-expr]
                       result-expr
                       ()
                       ([id seq-expr] ...)
         body-or-break ... body)]
      [(_ [rest-id init-expr]
          for-clause*
         body-or-break ... body)
       (for/foldl [rest-id init-expr]
                  :result (identity rest-id)
                  for-clause*
         body-or-break ... body)]))
  (define-syntax for*/foldl
    (syntax-rules (:result :when :unless :do :break :final)
      [(_ [rest-id init-expr]
          :result result-expr
          ()
         body-or-break ... body)
       (for/foldl [rest-id init-expr]
                  :result result-expr
                  ()
         body-or-break ... body)]
      [(_ [rest-id init-expr]
          :result result-expr
          (for-clause)
         body-or-break ... body)
       (for/foldl [rest-id init-expr]
                  :result result-expr
                  (for-clause)
         body-or-break ... body)]
      [(_ [rest-id init-expr]
          :result result-expr
          (for-clause . for-clause*)
         body-or-break ... body)
       (for/foldl [rest-id init-expr]
                  :result result-expr
                  (for-clause)
         (for*/foldl [rest-id (identity rest-id)]
                     :result (identity rest-id)
                     for-clause*
           body-or-break ...
           body))]
      [(_ [rest-id init-expr]
          for-clause*
         body-or-break ... body)
       (for*/foldl [rest-id init-expr]
                   :result (identity rest-id)
                   for-clause*
         body-or-break ... body)]))
  )
