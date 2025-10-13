#!r6rs

(library (r6rs racket base private math)
  (export add1
          sub1
          exact-integer?
          exact-nonnegative-integer?
          (rename [exact-nonnegative-integer? natural?]))
  (import (rnrs base))

  (define (add1 v) (+ v 1))
  (define (sub1 v) (- v 1))
  (define (exact-integer? v) (and (integer? v) (exact? v)))
  (define (exact-nonnegative-integer? v) (and (exact-integer? v) (not (negative? v)))))
