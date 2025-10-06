#!r6rs

(library (rktp racket undefined)
  (export undefined? (rename [undefined* undefined]))
  (import (rnrs))

  (define-record-type undefined (fields))
  (define undefined* (make-undefined)))
