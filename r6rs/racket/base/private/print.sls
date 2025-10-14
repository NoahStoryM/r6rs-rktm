#!r6rs

(library (r6rs racket base private print)
  (export displayln
          writeln
          fprintf-
          fprintf
          printf
          eprintf)
  (import (rnrs base (6))
          (rnrs conditions (6))
          (rnrs control (6))
          (rnrs exceptions (6))
          (rnrs io ports (6))
          (rnrs io simple (6))
          (r6rs racket base private exceptions)
          (r6rs racket base private lambda))

  (define displayln
    (case-λ
      [(datum) (displayln datum (current-output-port))]
      [(datum out) (display datum out) (newline out)]))
  (define writeln
    (case-λ
      [(datum) (writeln datum (current-output-port))]
      [(datum out) (write datum out) (newline out)]))

  (define (fprintf- out form v*)
    (define len (string-length form))
    (let loop ([i 0] [vals v*])
      (if (< i len)
          (let ([ch (string-ref form i)]
                [i (+ i 1)])
            (if (and (char=? ch #\~) (< i len))
                (let ([directive (string-ref form i)])
                  (case directive
                    [(#\a #\A)
                     (when (null? vals)
                       (raise-exn make-exn:fail:contract 'fprintf "too few arguments"))
                     (display (car vals) out)
                     (loop (+ i 1) (cdr vals))]
                    [(#\s #\S)
                     (when (null? vals)
                       (raise-exn make-exn:fail:contract 'fprintf "too few arguments"))
                     (write (car vals) out)
                     (loop (+ i 1) (cdr vals))]
                    [(#\n #\%)
                     (newline out)
                     (loop (+ i 1) vals)]
                    [(#\~)
                     (write-char #\~ out)
                     (loop (+ i 1) vals)]
                    [else
                     (display ch out)
                     (loop i vals)]))
                (begin
                  (display ch out)
                  (loop i vals))))
          (unless (null? vals)
            (raise-exn make-exn:fail:contract 'fprintf "too many arguments")))))
  (define (fprintf out form . v*) (fprintf- out form v*))
  (define (printf  form . v*) (fprintf- (current-output-port) form v*))
  (define (eprintf form . v*) (fprintf- (current-error-port)  form v*)))
