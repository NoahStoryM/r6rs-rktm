#!r6rs

(library (rktm racket base private define)
  (export define-syntax-rule)
  (import (rnrs base))

  (define-syntax define-syntax-rule
    (syntax-rules ()
      [(_ (id . pattern) template)
       (define-syntax id
         (syntax-rules ()
           [(id . pattern) template]))])))
