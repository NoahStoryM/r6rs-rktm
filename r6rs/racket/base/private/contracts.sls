#!r6rs

(library (r6rs racket base private contracts)
  (export (rename [not false?])
          true?
          and/c
          or/c
          not/c
          any
          any/c
          none/c
          =/c
          </c
          >/c
          <=/c
          >=/c)
  (import (rnrs base (6))
          (rnrs control (6))
          (rnrs lists (6))
          (r6rs racket base private lambda)
          (r6rs racket base private error)
          (r6rs racket base private lists))

  (define (true? v) (eq? v #t))

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
      [else (λ v* (not (apply p v*)))]))

  (define (=/c  n) (unless (real? n) (raise-argument-error '=/c  "real?" n)) (λ (v) (=  v n)))
  (define (</c  n) (unless (real? n) (raise-argument-error '</c  "real?" n)) (λ (v) (<  v n)))
  (define (>/c  n) (unless (real? n) (raise-argument-error '>/c  "real?" n)) (λ (v) (>  v n)))
  (define (<=/c n) (unless (real? n) (raise-argument-error '<=/c "real?" n)) (λ (v) (<= v n)))
  (define (>=/c n) (unless (real? n) (raise-argument-error '>=/c "real?" n)) (λ (v) (>= v n))))
