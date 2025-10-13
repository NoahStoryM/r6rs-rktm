#!r6rs

(library (r6rs racket base private control)
  (export let/cc
          current-continuation
          (rename [current-continuation cc]))
  (import (rnrs base (6))
          (r6rs racket base private lambda)
          (r6rs racket base private define)
          (r6rs racket base private error))

  (define-syntax-rule (let/cc k b ...)
    (call/cc (λ (k) b ...)))
  (define current-continuation
    (case-λ
      [() (call/cc current-continuation)]
      [(k) (raise-result-error 'current-contination "none/c" (k k))])))
