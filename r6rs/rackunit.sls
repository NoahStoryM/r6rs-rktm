#!r6rs

(library (r6rs rackunit)
  (export
   ;; Basic Checks
   check-eq?
   check-not-eq?
   check-eqv?
   check-not-eqv?
   check-equal?
   check-not-equal?
   check-pred
   check-=
   check-within
   check-true
   check-false
   check-not-false
   check-exn
   check-not-exn
   check-regexp-match
   check-match
   check
   fail

   ;; Augmenting Information on Check Failure
   ;; check-info
   ;; string-info
   ;; nested-info
   ;; dynamic-info
   ;; make-check-name
   ;; make-check-params
   ;; make-check-location
   ;; make-check-expression
   ;; make-check-message
   ;; make-check-actual
   ;; make-check-expected
   ;; with-check-info*
   ;; with-check-info
   ;; with-default-check-info*

   ;; Custom Checks
   define-simple-check
   define-binary-check
   define-check
   fail-check

   ;; TODO Test Cases
   ;; test-begin
   ;; test-case
   ;; test-case?

   ;; TODO Shortcuts for Defining Test Cases
   ;; test-check
   ;; test-pred
   ;; test-equal?
   ;; test-eq?
   ;; test-eqv?
   ;; test-=
   ;; test-true
   ;; test-false
   ;; test-not-false
   ;; test-exn
   ;; test-not-exn
   )
  (import (rnrs base))

  )
