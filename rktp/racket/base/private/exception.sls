#!r6rs

(library (rktp racket base private exception)
  (export &exn make-exn exn?
          exn-message
          &exn:fail make-exn:fail exn:fail?
          &exn:fail:contract make-exn:fail:contract exn:fail:contract?
          &exn:fail:user make-exn:fail:user exn:fail:user?)
  (import (rnrs)
          (rktp racket base private aliases))

  (define-condition-type &exn &error
    make-exn exn?
    [message exn-message])
  (define-condition-type &exn:fail &exn
    make-exn:fail exn:fail?)
  (define-condition-type &exn:fail:contract &exn:fail
    make-exn:fail:contract exn:fail:contract?)
  (define-condition-type &exn:fail:user &exn:fail
    make-exn:fail:user exn:fail:user?))
