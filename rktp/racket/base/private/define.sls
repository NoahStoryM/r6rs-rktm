#!r6rs

(library (rktp racket base private define)
  (export define-syntax-rule)
  (import (rnrs))

  (define-syntax define-syntax-rule
    (syntax-rules ()
      [(_ (id . pattern) template)
       (define-syntax id
         (syntax-rules ()
           [(id . pattern) template]))])))
