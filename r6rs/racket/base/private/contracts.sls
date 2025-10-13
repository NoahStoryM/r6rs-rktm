#!r6rs

(library (r6rs racket base private contracts)
  (export (rename [not false?])
          and/c
          or/c
          not/c
          any
          any/c
          none/c)
  (import (rnrs base)
          (rnrs lists)
          (r6rs racket base private lambda)
          (r6rs racket base private lists))

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
