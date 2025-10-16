#lang info

(define license 'MIT)
(define collection 'multi)
(define version "0.0")

(define pkg-desc "Scheme versions of Racket-inspired libraries")

(define deps '("base" "r6rs-lib"))
(define build-deps '("r6rs-doc"))
#;
(define scribblings '(("scribblings/rnrr.scrbl")))

(define clean '("compiled" "private/compiled"))
(define test-omit-paths '("test.ss"))
