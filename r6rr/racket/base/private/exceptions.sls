#!r6rs

(library (r6rr racket base private exceptions)
  (export (rename [with-exception-handler call-with-exception-handler])
          with-handlers
          with-handlers*
          raise-exn
          &exn make-exn exn?
          exn-message
          &exn:fail make-exn:fail exn:fail?
          &exn:fail:contract make-exn:fail:contract exn:fail:contract?
          &exn:fail:user make-exn:fail:user exn:fail:user?)
  (import (rnrs base (6))
          (rnrs conditions (6))
          (rnrs exceptions (6))
          (r6rr racket base private lambda))

  (define-syntax with-handlers
    (syntax-rules ()
      [(_ () body1 body2 ...)
       (let () body1 body2 ...)]
      [(_ ([pred handler] ...) body1 body2 ...)
       (guard (ex [(pred ex) (handler ex)] ...) body1 body2 ...)]))
  (define-syntax with-handlers*
    (syntax-rules ()
      [(_ () body1 body2 ...)
       (let () body1 body2 ...)]
      [(_ ([pred1 handler1] [pred2 handler2] ...) body1 body2 ...)
       (with-handlers ([pred1 handler1]) (with-handlers* ([pred2 handlers] ...) body1 body2 ...))]))

  (define raise-exn
    (case-λ
      [(make-ex msg)
       (raise
        (condition
         (make-ex msg)
         (make-message-condition msg)))]
      [(make-ex who msg)
       (raise
        (condition
         (make-ex msg)
         (make-who-condition who)
         (make-message-condition msg)))]))
  (define-condition-type &exn &condition
    make-exn exn?
    [message exn-message])
  (define-condition-type &exn:fail &exn
    make-exn:fail exn:fail?)
  (define-condition-type &exn:fail:contract &exn:fail
    make-exn:fail:contract exn:fail:contract?)
  (define-condition-type &exn:fail:user &exn:fail
    make-exn:fail:user exn:fail:user?))
