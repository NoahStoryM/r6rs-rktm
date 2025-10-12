#!r6rs

(library (rktm racket base private format)
  (export format-
          format
          ~a ~s)
  (import (rnrs)
          (rktm racket base private aliases)
          (rktm racket base private print))

  (define (format- form v*)
    (let-values ([(o get) (open-string-output-port)])
      (fprintf- o form v*)
      (get)))
  (define (format form . v*) (format- form v*))
  (define (make-~ form)
    (define (~ v) (format form v))
    (case-λ
      [() ""]
      [(v) (~ v)]
      [v* (apply string-append (map ~ v*))]))
  (define ~a (make-~ "~a"))
  (define ~s (make-~ "~s")))
