#!r6rs

(library (rktm racket base)
  (export
   ;; aliases
   λ case-λ
   false?

   ;; TODO box
   ;; box? unbox
   ;; box mutable-box? box-set!
   ;; immutable-box immutable-box?

   ;; contracts
   and/c
   or/c
   not/c
   any/c
   none/c

   ;; control
   let/cc
   current-continuation cc

   ;; define
   define-syntax-rule

   ;; error
   unquoted-printing-string?
   unquoted-printing-string
   make-unquoted-printing-string
   unquoted-printing-string-value
   raise-user-error
   raise-argument-error
   raise-result-error
   raise-arguments-error
   raise-range-error

   ;; exceptions
   &exn make-exn exn?
   exn-message
   &exn:fail make-exn:fail exn:fail?
   &exn:fail:contract make-exn:fail:contract exn:fail:contract?
   &exn:fail:user make-exn:fail:user exn:fail:user?

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

   ;; lists
   andmap
   ormap

   ;; math
   exact-integer?
   exact-nonnegative-integer?
   natural?

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

   ;; TODO sequences
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
  (import (rktm racket base private aliases)
          (rktm racket base private contracts)
          (rktm racket base private control)
          (rktm racket base private define)
          (rktm racket base private error)
          (rktm racket base private exceptions)
          (rktm racket base private lists)
          (rktm racket base private math)
          (rktm racket base private print)
          (rktm racket base private sequences)
          (rktm racket base private format)
          (rktm racket base private void)))
