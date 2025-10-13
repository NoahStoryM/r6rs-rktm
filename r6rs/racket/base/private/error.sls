#!r6rs

(library (r6rs racket base private error)
  (export unquoted-printing-string?
          unquoted-printing-string
          make-unquoted-printing-string
          unquoted-printing-string-value
          raise-user-error
          raise-argument-error
          raise-result-error
          raise-arguments-error
          raise-range-error)
  (import (rnrs base (6))
          (rnrs conditions (6))
          (rnrs control (6))
          (rnrs exceptions (6))
          (rnrs lists (6))
          (rnrs records syntactic (6))
          (r6rs racket base private lambda)
          (r6rs racket base private exceptions)
          (r6rs racket base private format)
          (r6rs racket base private math))

  (define (string-split str delim)
    (define len (string-length str))
    (let loop ([i (- len 1)] [end len] [acc '()])
      (cond
        [(= i -1) (cons (substring str 0 end) acc)]
        [(char=? (string-ref str i) delim)
         (loop (- i 1) i (cons (substring str (+ i 1) end) acc))]
        [else (loop (- i 1) end acc)])))

  (define (string-has? str char)
    (define len (string-length str))
    (let loop ([i 0])
      (and (< i len)
           (or (char=? (string-ref str i) char)
               (loop (+ i 1))))))


  (define-record-type unquoted-printing-string
    (fields [immutable value unquoted-printing-string-value]))
  (define (unquoted-printing-string->string v)
    (let ([lines (string-split (unquoted-printing-string-value v) #\newline)])
      (~a (if (= (length lines) 1)
              (car lines)
              (apply string-append
                     (map (λ (line) (string-append "\n   " line))
                          lines))))))

  (define raise-user-error
    (case-λ
      [(message)
       (unless (symbol? message)
         (raise-argument-error 'raise-user-error "symbol?" message))
       (raise-exn make-exn:fail:user (string-append "error: " (symbol->string message)))]
      [(who-or-fmt . v*)
       (cond
         [(symbol? who-or-fmt)
          (raise-exn make-exn:fail:user who-or-fmt (format- (car v*) (cdr v*)))]
         [(string? who-or-fmt)
          (raise-exn make-exn:fail:user (format- who-or-fmt v*))]
         [else
          (raise-argument-error 'raise-user-error "(or/c symbol? string?)" who-or-fmt)])]))

  (define (raise-fact-error who fact)
    (case-λ
      [(name expected v)
       (unless (symbol? name)
         (raise-argument-error who "symbol?" name))
       (unless (string? expected)
         (raise-argument-error who "string?" expected))
       (raise-exn
        make-exn:fail:contract
        name
        (format "contract violation\n  expected: ~a\n  ~a: ~s"
                expected fact v))]
      [(name expected bad-pos . v*)
       (unless (symbol? name)
         (raise-argument-error who "symbol?" name))
       (unless (string? expected)
         (raise-argument-error who "string?" expected))
       (unless (natural? bad-pos)
         (raise-argument-error who "natural?" bad-pos))
       (let ([bad-value (list-ref v* bad-pos)]
             [pos-str
              (string-append
               (number->string (+ bad-pos 1))
               (case (mod bad-pos 10)
                 [(0) "st"]
                 [(1) "nd"]
                 [(2) "rd"]
                 [else "th"]))])
         (let* ([bad-value (list-ref v* bad-pos)]
                [other-args (remq bad-value v*)]
                [other-args-str
                 (if (null? other-args)
                     ""
                     (apply string-append
                            "\n  other arguments...:"
                            (map (λ (arg) (format "\n   ~s" arg))
                                 other-args)))])
           (raise-exn
            make-exn:fail:contract
            name
            (format "contract violation\n  expected: ~a\n  ~a: ~s\n  argument position: ~a~a"
                    expected fact bad-value pos-str other-args-str))))]))
  (define raise-argument-error (raise-fact-error 'raise-argument-error 'given))
  (define raise-result-error (raise-fact-error 'raise-result-error 'result))

  (define (raise-arguments-error name message . field-value-pairs)
    (unless (symbol? name)
      (raise-argument-error 'raise-arguments-error "symbol?" name))
    (unless (string? message)
      (raise-argument-error 'raise-arguments-error "string?" message))
    (raise-exn
     make-exn:fail:contract
     name
     (let loop ([pairs field-value-pairs] [acc '()])
       (if (null? pairs)
           (apply string-append message (reverse acc))
           (let ([field-name (car pairs)] [pairs (cdr pairs)])
             (unless (string? field-name)
               (raise-argument-error 'raise-arguments-error "string?" field-name))
             (let ([field-value (car pairs)] [pairs (cdr pairs)])
               (let* ([value-str
                       (if (unquoted-printing-string? field-value)
                           (unquoted-printing-string->string field-value)
                           (~s field-value))]
                      [field-str
                       (if (string-has? value-str #\newline)
                           (format "\n  ~a:~a" field-name value-str)
                           (format "\n  ~a: ~a" field-name value-str))])
                 (loop pairs (cons field-str acc)))))))))

  (define raise-range-error
    (λ (name
        type-description
        index-prefix
        index
        in-value
        lower-bound
        upper-bound
        [alt-lower-bound #f])
      (unless (symbol? name)
        (raise-argument-error 'raise-range-error "symbol?" name))
      (unless (string? type-description)
        (raise-argument-error 'raise-range-error "string?" type-description))
      (unless (exact-integer? index)
        (raise-argument-error 'raise-range-error "exact-integer?" index))
      (unless (exact-integer? lower-bound)
        (raise-argument-error 'raise-range-error "exact-integer?" lower-bound))
      (unless (exact-integer? upper-bound)
        (raise-argument-error 'raise-range-error "exact-integer?" upper-bound))
      (unless (or (not alt-lower-bound) (exact-integer? alt-lower-bound))
        (raise-argument-error 'raise-range-error "(or/c #f exact-integer?)" alt-lower-bound))
      (let ([index-name (string-append index-prefix "index")])
        (cond
          [(< upper-bound lower-bound)
           (raise-arguments-error
            name
            (format "~a is out of range for empty ~a" index-name type-description)
            index-name index)]
          [(and alt-lower-bound (<= alt-lower-bound index lower-bound))
           (raise-arguments-error
            name
            (format "~a is smaller than starting index" index-name)
            index-name index
            "starting index" lower-bound
            "valid range" (make-unquoted-printing-string
                           (format "[~a, ~a]" alt-lower-bound upper-bound))
            type-description in-value)]
          [else
           (raise-arguments-error
            name
            (format "~a is out of range" index-name)
            index-name index
            "valid range" (make-unquoted-printing-string
                           (format "[~a, ~a]" lower-bound upper-bound))
            type-description in-value)])))))
