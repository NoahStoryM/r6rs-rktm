#!r6rs

(library (rktm racket base private math)
  (export exact-integer?
          exact-nonnegative-integer?
          (rename [exact-nonnegative-integer? natural?]))
  (import (rnrs base))

  (define (exact-integer? v) (and (integer? v) (exact? v)))
  (define (exact-nonnegative-integer? v) (and (exact-integer? v) (not (negative? v)))))
