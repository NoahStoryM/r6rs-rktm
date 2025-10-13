#!r6rs

(library (r6rs racket undefined)
  (export undefined? (rename [undefined* undefined]))
  (import (rnrs base)
          (rnrs records syntactic))

  (define-record-type undefined (fields))
  (define undefined* (make-undefined)))
