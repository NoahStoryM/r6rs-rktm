#!r6rs

(library (rktm racket base private void)
  (export void void?)
  (import (rnrs))
  (define (void . _) (if #f #f))
  (define (void? . a*)
    (let-values ([v* (void)])
      (equal? v* a*))))
