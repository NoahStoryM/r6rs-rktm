#!r6rs

(library (rktm racket base private sequences)
  (export make-do-sequence
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
          )
  (import (rnrs base)
          (rnrs bytevectors)
          (rnrs conditions)
          (rnrs control)
          (rnrs exceptions)
          (rnrs mutable-pairs)
          (rnrs records syntactic)
          (rktm racket base private lambda)
          (rktm racket base private contracts)
          (rktm racket base private error)
          (rktm racket base private exceptions)
          (rktm racket base private math))

  (define (list->values v*) (apply values v*))
  (define (list*? l) (or (null? l) (pair? l)))
  (define raise-sequence-empty-error
    (let* ([msg "sequence has no more values"]
           [next (λ () (raise (condition (make-exn:fail:contract msg) msg)))])
      next))

  (define-record-type do-sequence (fields thunk))
  (define table `([,do-sequence? . ,values]))
  (define sequence-queue (cons table table))
  (define (define-sequence seq? in-seq)
    (let ([end (cdr sequence-queue)]
          [table `([,seq? . ,in-seq])])
      (set-cdr! end table)
      (set-cdr! sequence-queue table)))

  (define (sequence? seq)
    (let loop ([table table])
      (and (pair? table)
           (or ((caar table) seq)
               (loop (cdr table))))))
  (define (sequence->do-sequence seq)
    (let loop ([table table])
      (when (null? table)
        (raise-argument-error 'sequence->do-sequence "sequence?" seq))
      (let ([p (car table)])
        (or (and ((car p) seq)
                 ((cdr p) seq))
            (loop (cdr table))))))

  (define (sequence-generate seq)
    (let ([vals #f] [next (λ () (sequence-generate* seq))])
      (define (more?)
        (or (not (not vals))
            (let-values ([(vals1 next1) (next)])
              (set! vals vals1)
              (set! next next1)
              (not (not vals1)))))
      (define (get)
        (unless (more?)
          (raise-sequence-empty-error))
        (let ([val* vals])
          (set! vals #f)
          (apply values val*)))
      (values more? get)))
  (define (sequence-generate* seq)
    (define do-seq (sequence->do-sequence seq))
    (let-values ([(pos->element
                   early-next-pos
                   next-pos
                   init-pos
                   continue-with-pos?
                   continue-with-val?
                   continue-after-pos+val?)
                  ((do-sequence-thunk do-seq))])
      (let ([early-next-pos (or early-next-pos values)]
            [continue-with-pos? (or continue-with-pos? any)]
            [continue-with-val? (or continue-with-val? any)]
            [continue-after-pos+val? (or continue-after-pos+val? any)])
        (let loop ([pos init-pos])
          (if (continue-with-pos? pos)
              (let-values ([val* (pos->element pos)])
                (if (apply continue-with-val? val*)
                    (let ([pos (early-next-pos pos)])
                      (if (apply continue-after-pos+val? pos val*)
                          (let ([pos (next-pos pos)])
                            (define (next) (loop pos))
                            (values val* next))
                          (values #f raise-sequence-empty-error)))
                    (values #f raise-sequence-empty-error)))
              (values #f raise-sequence-empty-error))))))

  (define (in-values . v*)
    (make-do-sequence
     (λ ()
       (define first? #t)
       (define (continue-with-pos? _)
         (and first? (begin (set! first? #f) #t)))
       (values list->values #f values v* continue-with-pos? #f #f))))

  (define (make-in-range >? <?)
    (define (in-range start end step)
      (define (next-pos pos) (+ pos step))
      (define continue-with-pos?
        (if (< step 0)
            (λ (pos) (>? pos end))
            (λ (pos) (<? pos end))))
      (make-do-sequence
       (λ () (values values #f next-pos start continue-with-pos? #f #f))))
    (case-λ
      [(end) (in-range 0 end 1)]
      [(start end) (in-range start end 1)]
      [(start end step) (in-range start end step)]))
  (define in-range (make-in-range > <))
  (define in-inclusive-range (make-in-range >= <=))

  (define (in-list* l)
    (make-do-sequence
     (λ () (values car #f cdr l pair? #f #f))))

  (define (make-in-vec vec? vec-ref vec-length)
    (define (in-vec vec start stop step)
      (let ([stop (or stop (vec-length vec))])
        (define (pos->element pos) (vec-ref vec pos))
        (define (next-pos pos) (+ pos step))
        (define continue-with-pos?
          (if (< step 0)
              (λ (pos) (> pos stop))
              (λ (pos) (< pos stop))))
        (make-do-sequence
         (λ ()
           (values pos->element #f next-pos start continue-with-pos? #f #f)))))
    (case-λ
      [(vec) (in-vec vec 0 (vec-length vec) 1)]
      [(vec start) (in-vec vec start (vec-length vec) 1)]
      [(vec start stop) (in-vec vec start stop 1)]
      [(vec start stop step) (in-vec vec start stop step)]))
  (define in-string (make-in-vec string? string-ref string-length))
  (define in-vector (make-in-vec vector? vector-ref vector-length))
  (define in-bytevector (make-in-vec bytevector? bytevector-u8-ref bytevector-length))

  (define-sequence natural? in-range)
  (define-sequence string? in-string)
  (define-sequence vector? in-vector)
  (define-sequence bytevector? in-bytevector)
  (define-sequence list*? in-list*))
