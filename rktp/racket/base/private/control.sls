#!r6rs

(library (rktp racket base private control)
  (export let/cc
          current-continuation
          (rename [current-continuation cc]))
  (import (rnrs)
          (rktp racket base private aliases)
          (rktp racket base private define)
          (rktp racket base private error))

  (define-syntax-rule (let/cc k b ...)
    (call/cc (λ (k) b ...)))
  (define current-continuation
    (case-λ
      [() (call/cc current-continuation)]
      [(k) (raise-result-error 'current-contination "none/c" (k k))])))
