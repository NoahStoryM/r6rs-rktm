#!r6rs

(import (rnrs)
        (rktp racket base))

(define-syntax test
  (syntax-rules ()
    [(_ name expected expr)
     (begin
       (display "Testing: ")
       (displayln name)
       (let ([result expr])
         (if (equal? result expected)
             (displayln "  PASS")
             (begin (display "  FAIL: expected ")
                    (write expected)
                    (display " but got ")
                    (writeln result)))))]))

(define-syntax test-values
  (syntax-rules ()
    [(_ name expected-list expr)
     (begin
       (display "Testing: ")
       (displayln name)
       (let-values ([result expr])
         (if (equal? result expected-list)
             (displayln "  PASS")
             (begin (display "  FAIL: expected ")
                    (write expected-list)
                    (display " but got ")
                    (writeln result)))))]))

(define (collect-sequence seq)
  (let-values ([(more? get) (sequence-generate seq)])
    (let loop ([acc '()])
      (if (more?)
          (loop (cons (get) acc))
          (reverse acc)))))

(define (collect-sequence-n seq n)
  (let-values ([(more? get) (sequence-generate seq)])
    (let loop ([i 0] [acc '()])
      (if (and (< i n) (more?))
          (loop (+ i 1) (cons (get) acc))
          (reverse acc)))))

;; ==================== sequence? tests ====================
(display "\n=== Testing sequence? ===\n")
(test "natural is sequence" #t (sequence? 10))
(test "string is sequence" #t (sequence? "hello"))
(test "vector is sequence" #t (sequence? '#(1 2 3)))
(test "bytevector is sequence" #t (sequence? '#vu8(1 2 3)))
(test "list is sequence" #t (sequence? '(1 2 3)))
(test "do-sequence is sequence" #t (sequence? (in-values 42)))
(test "number is not sequence" #f (sequence? 3.14))
(test "symbol is not sequence" #f (sequence? 'foo))

;; ==================== in-values tests ====================
(display "\n=== Testing in-values ===\n")
(test "in-values single" '(42) (collect-sequence (in-values 42)))
(test "in-values string" '("hello") (collect-sequence (in-values "hello")))
(test "in-values list" '((1 2 3)) (collect-sequence (in-values '(1 2 3))))

;; ==================== in-range tests ====================
(display "\n=== Testing in-range ===\n")
(test "in-range (5)" '(0 1 2 3 4) (collect-sequence (in-range 5)))
(test "in-range (2 7)" '(2 3 4 5 6) (collect-sequence (in-range 2 7)))
(test "in-range (0 10 2)" '(0 2 4 6 8) (collect-sequence (in-range 0 10 2)))
(test "in-range (10 0 -2)" '(10 8 6 4 2) (collect-sequence (in-range 10 0 -2)))
(test "in-range (5 5)" '() (collect-sequence (in-range 5 5)))
(test "in-range (0 -5 -1)" '(0 -1 -2 -3 -4) (collect-sequence (in-range 0 -5 -1)))

;; ==================== in-inclusive-range tests ====================
(display "\n=== Testing in-inclusive-range ===\n")
(test "in-inclusive-range (5)" '(0 1 2 3 4 5)
      (collect-sequence (in-inclusive-range 5)))
(test "in-inclusive-range (2 7)" '(2 3 4 5 6 7)
      (collect-sequence (in-inclusive-range 2 7)))
(test "in-inclusive-range (0 10 2)" '(0 2 4 6 8 10)
      (collect-sequence (in-inclusive-range 0 10 2)))
(test "in-inclusive-range (10 0 -2)" '(10 8 6 4 2 0)
      (collect-sequence (in-inclusive-range 10 0 -2)))

;; ==================== in-string tests ====================
(display "\n=== Testing in-string ===\n")
(test "in-string full" '(#\h #\e #\l #\l #\o)
      (collect-sequence (in-string "hello")))
(test "in-string with start" '(#\l #\l #\o)
      (collect-sequence (in-string "hello" 2)))
(test "in-string with start/stop" '(#\l #\l)
      (collect-sequence (in-string "hello" 2 4)))
(test "in-string with step" '(#\h #\l #\o)
      (collect-sequence (in-string "hello" 0 5 2)))
(test "in-string empty" '() (collect-sequence (in-string "")))

;; ==================== in-vector tests ====================
(display "\n=== Testing in-vector ===\n")
(test "in-vector full" '(1 2 3 4 5)
      (collect-sequence (in-vector '#(1 2 3 4 5))))
(test "in-vector with start" '(3 4 5)
      (collect-sequence (in-vector '#(1 2 3 4 5) 2)))
(test "in-vector with start/stop" '(3 4)
      (collect-sequence (in-vector '#(1 2 3 4 5) 2 4)))
(test "in-vector with step" '(1 3 5)
      (collect-sequence (in-vector '#(1 2 3 4 5) 0 5 2)))
(test "in-vector empty" '() (collect-sequence (in-vector '#())))

;; ==================== in-bytevector tests ====================
(display "\n=== Testing in-bytevector ===\n")
(test "in-bytevector full" '(1 2 3 4 5)
      (collect-sequence (in-bytevector '#vu8(1 2 3 4 5))))
(test "in-bytevector with start" '(3 4 5)
      (collect-sequence (in-bytevector '#vu8(1 2 3 4 5) 2)))
(test "in-bytevector with start/stop" '(3 4)
      (collect-sequence (in-bytevector '#vu8(1 2 3 4 5) 2 4)))
(test "in-bytevector with step" '(1 3 5)
      (collect-sequence (in-bytevector '#vu8(1 2 3 4 5) 0 5 2)))

;; ==================== in-list* tests ====================
(display "\n=== Testing in-list* ===\n")
(test "in-list* simple" '(1 2 3 4 5)
      (collect-sequence (in-list* '(1 2 3 4 5))))
(test "in-list* single" '(42) (collect-sequence (in-list* '(42))))
(test "in-list* empty" '() (collect-sequence (in-list* '())))

;; ==================== sequence-generate tests ====================
(display "\n=== Testing sequence-generate ===\n")
(let-values ([(more? get) (sequence-generate (in-range 3))])
  (test "generate more? before" #t (more?))
  (test "generate first get" 0 (get))
  (test "generate more? after first" #t (more?))
  (test "generate second get" 1 (get))
  (test "generate third get" 2 (get))
  (test "generate more? at end" #f (more?)))

;; ==================== sequence-generate* tests ====================
(display "\n=== Testing sequence-generate* ===\n")
(let-values ([(vals next) (sequence-generate* (in-range 2 5))])
  (test "generate* first value" '(2) vals)
  (let-values ([(vals next) (next)])
    (test "generate* second value" '(3) vals)
    (let-values ([(vals next) (next)])
      (test "generate* third value" '(4) vals)
      (let-values ([(vals next) (next)])
        (test "generate* end" #f vals)))))

;; ==================== implicit sequence conversion tests ====================
(display "\n=== Testing implicit sequence conversion ===\n")
(test "natural as sequence" '(0 1 2 3 4) (collect-sequence 5))
(test "string as sequence" '(#\a #\b #\c) (collect-sequence "abc"))
(test "vector as sequence" '(10 20 30) (collect-sequence '#(10 20 30)))
(test "bytevector as sequence" '(255 128 0)
      (collect-sequence '#vu8(255 128 0)))
(test "list as sequence" '(a b c) (collect-sequence '(a b c)))

;; ==================== edge cases tests ====================
(display "\n=== Testing edge cases ===\n")
(test "negative step in range" '(5 4 3 2 1)
      (collect-sequence (in-range 5 0 -1)))
(test "large step" '(0 10 20) (collect-sequence (in-range 0 25 10)))
(test "partial collection" '(0 1 2)
      (collect-sequence-n (in-range 100) 3))

(display "\n=== All tests completed ===\n")
