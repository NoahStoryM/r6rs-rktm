#!r6rs

(library (r6rs racket base private lists)
  (export andmap
          ormap)
  (import (rnrs (6))
          (r6rs racket base private error))

  (define (check-lst* who lst lst*)
    (let loop ([len-1st (length lst)]
               [lst* lst*])
      (unless (null? lst*)
        (let ([len-oth (length (car lst*))]
              [lst* (cdr lst*)])
          (unless (= len-1st len-oth)
            (raise-arguments-error
             who
             "all lists must have same size"
             "first list length" len-1st
             "other list length" len-oth))
          (loop len-1st lst*)))))
  (define (andmap proc lst . lst*)
    (check-lst* 'andmap lst lst*)
    (or (null? lst)
        (let loop ([lst lst] [lst* lst*])
          (let-values ([v* (apply proc (car lst) (map car lst*))]
                       [(lst) (cdr lst)])
            (or (and (null? lst)
                     (apply values v*))
                (and (not (equal? v* '(#f)))
                     (loop lst (map cdr lst*))))))))
  (define (ormap proc lst . lst*)
    (check-lst* 'ormap lst lst*)
    (and (pair? lst)
         (let loop ([lst lst] [lst* lst*])
           (let-values ([v* (apply proc (car lst) (map car lst*))]
                        [(lst) (cdr lst)])
             (or (and (not (equal? v* '(#f)))
                      (apply values v*))
                 (and (pair? lst)
                      (loop lst (map cdr lst*)))))))))
