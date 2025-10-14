#!r6rs

(library (r6rs racket base private boxes)
  (export box? unbox
          box mutable-box? box-set!
          immutable-box immutable-box?)
  (import (rnrs base (6))
          (rnrs records syntactic (6))
          (r6rs racket base private error))

  (define-record-type (mbox box mutable-box?)
    (fields (mutable value unmbox box-set!)))

  (define-record-type (immbox immutable-box immutable-box?)
    (fields (immutable value unimmbox)))

  (define (box? v) (or (mutable-box? v) (immutable-box? v)))
  (define (unbox b)
    (cond
      [(mutable-box? b) (unmbox b)]
      [(immutable-box? b) (unimmbox b)]
      [else (raise-argument-error 'unbox "box?" b)])))
