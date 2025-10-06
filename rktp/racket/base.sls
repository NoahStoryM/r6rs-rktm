#!r6rs

(library (rktp racket base)
  (export
   ;; aliases
   λ case-λ
   false?

   ;; begin
   begin0

   ;; TODO box
   ;; box? unbox
   ;; box mutable-box? box-set!
   ;; immutable-box immutable-box?

   ;; control
   ;; let/cc
   ;; current-continuation cc

   ;; define
   define-syntax-rule

   ;; TODO error
   ;; raise-user-error
   ;; raise-argument-error
   ;; raise-result-error
   ;; raise-arguments-error
   ;; raise-range-error
   ;; raise-type-error
   ;; raise-mismatch-error
   ;; raise-arity-error
   ;; raise-arity-mask-error
   ;; raise-result-arity-error
   ;; raise-syntax-error

   ;; TODO for
   ;; for/fold
   ;; for*/fold
   ;; for/void  for
   ;; for*/void for*
   ;; for/list
   ;; for*/list
   ;; for/vector
   ;; for*/vector
   ;; for/hash
   ;; for*/hash
   ;; for/and
   ;; for*/and
   ;; for/or
   ;; for*/or
   ;; for/first
   ;; for*/first
   ;; for/last
   ;; for*/last
   ;; for/sum
   ;; for*/sum
   ;; for/product
   ;; for*/product

   ;; TODO function
   ;; compose ∘

   ;; print
   displayln
   writeln
   fprintf
   printf
   eprintf

   ;; TODO parameter
   ;; parameter?
   ;; make-parameter
   ;; parameterize

   ;; TODO sequence
   make-do-sequence
   define-sequence
   sequence?
   ;; empty-sequence
   sequence-generate
   sequence-generate*
   in-values
   in-range
   in-inclusive-range
   in-string
   in-vector
   in-bytevector
   in-list*
   ;; TODO
   ;; in-hash
   ;; in-port

   ;; format
   format ~a ~s

   ;; void
   void
   void?)
  (import (rktp racket base private aliases)
          (rktp racket base private begin)
          ;; (rktp racket base private control)
          (rktp racket base private define)
          ;; (rktp racket base private error)
          (rktp racket base private print)
          (rktp racket base private sequence)
          (rktp racket base private format)
          (rktp racket base private void)))
