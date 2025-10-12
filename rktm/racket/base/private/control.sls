#!r6rs

(library (rktm racket base private control)
  (export let/cc
          current-continuation
          (rename [current-continuation cc]))
  (import (rnrs)
          (rktm racket base private aliases)
          (rktm racket base private define)
          (rktm racket base private error))

  (define-syntax-rule (let/cc k b ...)
    (call/cc (λ (k) b ...)))
  (define current-continuation
    (case-λ
      [() (call/cc current-continuation)]
      [(k) (raise-result-error 'current-contination "none/c" (k k))])))
