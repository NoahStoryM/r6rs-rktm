#!r6rs

(library (rktm racket base private contracts)
  (export (rename [not false?])
          and/c
          or/c
          not/c
          any
          any/c
          none/c)
  (import (rnrs base)
          (rnrs lists)
          (rktm racket base private lambda)
          (rktm racket base private lists))

  (define (any . _) #t)
  (define (any/c _) #t)
  (define (none/c . _) #f)

  (define (and/c p*)
    (let ([p* (remq any p*)])
      (cond
        [(null? p*) any]
        [(null? (cdr p*)) (car p*)]
        [else
         (λ v* (andmap (λ (p) (apply p v*)) p*))])))
  (define (or/c p*)
    (let ([p* (remq none/c p*)])
      (cond
        [(null? p*) none/c]
        [(null? (cdr p*)) (car p*)]
        [else
         (λ v* (ormap (λ (p) (apply p v*)) p*))])))
  (define (not/c p)
    (cond
      [(eq? p any) none/c]
      [(eq? p none/c) any]
      [else (λ v* (not (apply p v*)))])))
