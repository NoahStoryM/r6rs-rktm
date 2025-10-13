#!r6rs

(library (r6rs racket undefined)
  (export undefined? (rename [undefined* undefined]))
  (import (rnrs base (6))
          (rnrs records syntactic (6)))

  (define-record-type undefined (fields))
  (define undefined* (make-undefined)))
