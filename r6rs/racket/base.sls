#!r6rs

(library (r6rs racket base)
  (export
   ;; TODO box
   ;; box? unbox
   ;; box mutable-box? box-set!
   ;; immutable-box immutable-box?

   ;; contracts
   false?
   true?
   and/c
   or/c
   not/c
   any/c
   none/c
   =/c
   </c
   >/c
   <=/c
   >=/c

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
   call-with-exception-handler
   with-handlers
   with-handlers*
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

   ;; lambda
   λ
   case-λ

   ;; lists
   andmap
   ormap

   ;; math
   add1
   sub1
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

   ;; sequences
   make-do-sequence
   define-sequence
   sequence?
   sequence-generate
   sequence-generate*
   in-values
   in-range
   in-inclusive-range
   in-string
   in-vector
   in-bytevector
   in-list*
   in-hashtable
   in-port

   ;; format
   format ~a ~s

   ;; void
   void
   void?)
  (import (r6rs racket base private contracts)
          (r6rs racket base private control)
          (r6rs racket base private define)
          (r6rs racket base private error)
          (r6rs racket base private exceptions)
          (r6rs racket base private lambda)
          (r6rs racket base private lists)
          (r6rs racket base private math)
          (r6rs racket base private print)
          (r6rs racket base private sequences)
          (r6rs racket base private format)
          (r6rs racket base private void)))
