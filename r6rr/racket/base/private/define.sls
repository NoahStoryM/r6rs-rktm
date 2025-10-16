#!r6rs

(library (r6rr racket base private define)
  (export define-syntax-rule)
  (import (rnrs base (6)))

  (define-syntax define-syntax-rule
    (syntax-rules ()
      [(_ (id . pattern) template)
       (define-syntax id
         (syntax-rules ()
           [(id . pattern) template]))])))
