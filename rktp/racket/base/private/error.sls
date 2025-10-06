#!r6rs

(library (rktp racket base private error)
  (export raise-user-error
          raise-argument-error
          raise-result-error
          raise-arguments-error
          raise-range-error
          raise-type-error
          raise-mismatch-error
          raise-arity-error
          raise-arity-mask-error
          raise-result-arity-error
          raise-syntax-error)
  (import (rnrs)
          (rktp racket base private aliases)
          (rktp racket base private print))

  ;; TODO

  )
