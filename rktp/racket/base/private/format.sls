#!r6rs

(library (rktp racket base private format)
  (export format-
          format
          ~a ~s)
  (import (rnrs)
          (rktp racket base private print))

  (define (format- form v*)
    (let-values ([(o get) (open-string-output-port)])
      (fprintf- o form v*)
      (get)))
  (define (format form . v*) (format- form v*))
  (define (~a . v*) (format- "~a" v*))
  (define (~s . v*) (format- "~s" v*)))
