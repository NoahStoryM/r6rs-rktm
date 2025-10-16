#!r6rs

(library (r6rs racket base private sequences)
  (export :init-pos
          :continue-with-pos?
          :pos->element
          :continue-with-val?
          :early-next-pos
          :continue-after-pos+val?
          :next-pos
          make-do-sequence
          do-sequence?
          initiate-do-sequence
          define-sequence
          sequence?
          sequence-generate
          sequence-generate*
          in-naturals
          in-values
          in-range
          in-inclusive-range
          in-string
          in-vector
          in-bytevector
          in-list*
          in-hashtable
          in-port)
  (import (rnrs base (6))
          (rnrs bytevectors (6))
          (rnrs conditions (6))
          (rnrs control (6))
          (rnrs exceptions (6))
          (rnrs hashtables (6))
          (rnrs io ports (6))
          (rnrs io simple (6))
          (rnrs mutable-pairs (6))
          (rnrs records syntactic (6))
          (r6rs racket base private contracts)
          (r6rs racket base private error)
          (r6rs racket base private exceptions)
          (r6rs racket base private lambda)
          (r6rs racket base private math)
          (r6rs racket undefined))

  (define :init-pos undefined)
  (define :continue-with-pos? undefined)
  (define :pos->element undefined)
  (define :continue-with-val? undefined)
  (define :early-next-pos undefined)
  (define :continue-after-pos+val? undefined)
  (define :next-pos undefined)

  (define (list->values v*) (apply values v*))
  (define (list*? l) (or (null? l) (pair? l)))
  (define (raise-sequence-empty-error)
    (raise-exn make-exn:fail:contract "sequence has no more values"))

  (define-record-type do-sequence (fields thunk))
  (define-syntax initiate-do-sequence
    (syntax-rules (:init-pos
                   :continue-with-pos?
                   :pos->element
                   :continue-with-val?
                   :early-next-pos
                   :continue-after-pos+val?
                   :next-pos)
      [(_ :init-pos init-pos
          :continue-with-pos? continue-with-pos?
          :pos->element pos->element
          :continue-with-val? continue-with-val?
          :early-next-pos early-next-pos
          :continue-after-pos+val? continue-after-pos+val?
          :next-pos next-pos)
       (make-do-sequence
        (λ ()
          (values pos->element
                  early-next-pos
                  next-pos
                  init-pos
                  continue-with-pos?
                  continue-with-val?
                  continue-after-pos+val?)))]

      [(_ :init-pos init-pos
          :pos->element pos->element
          :next-pos next-pos)
       (initiate-do-sequence
        :init-pos init-pos
        :continue-with-pos? #f
        :pos->element pos->element
        :continue-with-val? #f
        :early-next-pos #f
        :continue-after-pos+val? #f
        :next-pos next-pos)]

      [(_ :init-pos init-pos
          :continue-with-pos? continue-with-pos?
          :pos->element pos->element
          :next-pos next-pos)
       (initiate-do-sequence
        :init-pos init-pos
        :continue-with-pos? continue-with-pos?
        :pos->element pos->element
        :continue-with-val? #f
        :early-next-pos #f
        :continue-after-pos+val? #f
        :next-pos next-pos)]
      [(_ :init-pos init-pos
          :pos->element pos->element
          :continue-with-val? continue-with-val?
          :next-pos next-pos)
       (initiate-do-sequence
        :init-pos init-pos
        :continue-with-pos? #f
        :pos->element pos->element
        :continue-with-val? continue-with-val?
        :early-next-pos #f
        :continue-after-pos+val? #f
        :next-pos next-pos)]
      [(_ :init-pos init-pos
          :pos->element pos->element
          :early-next-pos early-next-pos
          :next-pos next-pos)
       (initiate-do-sequence
        :init-pos init-pos
        :continue-with-pos? #f
        :pos->element pos->element
        :continue-with-val? #f
        :early-next-pos early-next-pos
        :continue-after-pos+val? #f
        :next-pos next-pos)]
      [(_ :init-pos init-pos
          :pos->element pos->element
          :continue-after-pos+val? continue-after-pos+val?
          :next-pos next-pos)
       (initiate-do-sequence
        :init-pos init-pos
        :continue-with-pos? #f
        :pos->element pos->element
        :continue-with-val? #f
        :early-next-pos #f
        :continue-after-pos+val? continue-after-pos+val?
        :next-pos next-pos)]

      [(_ :init-pos init-pos
          :pos->element pos->element
          :early-next-pos early-next-pos
          :continue-after-pos+val? continue-after-pos+val?
          :next-pos next-pos)
       (initiate-do-sequence
        :init-pos init-pos
        :continue-with-pos? #f
        :pos->element pos->element
        :continue-with-val? #f
        :early-next-pos early-next-pos
        :continue-after-pos+val? continue-after-pos+val?
        :next-pos next-pos)]
      [(_ :init-pos init-pos
          :pos->element pos->element
          :continue-with-val? continue-with-val?
          :continue-after-pos+val? continue-after-pos+val?
          :next-pos next-pos)
       (initiate-do-sequence
        :init-pos init-pos
        :continue-with-pos? #f
        :pos->element pos->element
        :continue-with-val? continue-with-val?
        :early-next-pos #f
        :continue-after-pos+val? continue-after-pos+val?
        :next-pos next-pos)]
      [(_ :init-pos init-pos
          :pos->element pos->element
          :continue-with-val? continue-with-val?
          :early-next-pos early-next-pos
          :next-pos next-pos)
       (initiate-do-sequence
        :init-pos init-pos
        :continue-with-pos? #f
        :pos->element pos->element
        :continue-with-val? continue-with-val?
        :early-next-pos early-next-pos
        :continue-after-pos+val? #f
        :next-pos next-pos)]
      [(_ :init-pos init-pos
          :continue-with-pos? continue-with-pos?
          :pos->element pos->element
          :continue-after-pos+val? continue-after-pos+val?
          :next-pos next-pos)
       (initiate-do-sequence
        :init-pos init-pos
        :continue-with-pos? continue-with-pos?
        :pos->element pos->element
        :continue-with-val? #f
        :early-next-pos #f
        :continue-after-pos+val? continue-after-pos+val?
        :next-pos next-pos)]
      [(_ :init-pos init-pos
          :continue-with-pos? continue-with-pos?
          :pos->element pos->element
          :early-next-pos early-next-pos
          :next-pos next-pos)
       (initiate-do-sequence
        :init-pos init-pos
        :continue-with-pos? continue-with-pos?
        :pos->element pos->element
        :continue-with-val? #f
        :early-next-pos early-next-pos
        :continue-after-pos+val? #f
        :next-pos next-pos)]
      [(_ :init-pos init-pos
          :continue-with-pos? continue-with-pos?
          :pos->element pos->element
          :continue-with-val? continue-with-val?
          :next-pos next-pos)
       (initiate-do-sequence
        :init-pos init-pos
        :continue-with-pos? continue-with-pos?
        :pos->element pos->element
        :continue-with-val? continue-with-val?
        :early-next-pos #f
        :continue-after-pos+val? #f
        :next-pos next-pos)]

      [(_ :init-pos init-pos
          :pos->element pos->element
          :continue-with-val? continue-with-val?
          :early-next-pos early-next-pos
          :continue-after-pos+val? continue-after-pos+val?
          :next-pos next-pos)
       (initiate-do-sequence
        :init-pos init-pos
        :continue-with-pos? #f
        :pos->element pos->element
        :continue-with-val? continue-with-val?
        :early-next-pos early-next-pos
        :continue-after-pos+val? continue-after-pos+val?
        :next-pos next-pos)]
      [(_ :init-pos init-pos
          :continue-with-pos? continue-with-pos?
          :pos->element pos->element
          :early-next-pos early-next-pos
          :continue-after-pos+val? continue-after-pos+val?
          :next-pos next-pos)
       (initiate-do-sequence
        :init-pos init-pos
        :continue-with-pos? continue-with-pos?
        :pos->element pos->element
        :continue-with-val? #f
        :early-next-pos early-next-pos
        :continue-after-pos+val? continue-after-pos+val?
        :next-pos next-pos)]
      [(_ :init-pos init-pos
          :continue-with-pos? continue-with-pos?
          :pos->element pos->element
          :continue-with-val? continue-with-val?
          :continue-after-pos+val? continue-after-pos+val?
          :next-pos next-pos)
       (initiate-do-sequence
        :init-pos init-pos
        :continue-with-pos? continue-with-pos?
        :pos->element pos->element
        :continue-with-val? continue-with-val?
        :early-next-pos #f
        :continue-after-pos+val? continue-after-pos+val?
        :next-pos next-pos)]
      [(_ :init-pos init-pos
          :continue-with-pos? continue-with-pos?
          :pos->element pos->element
          :continue-with-val? continue-with-val?
          :early-next-pos early-next-pos
          :next-pos next-pos)
       (initiate-do-sequence
        :init-pos init-pos
        :continue-with-pos? continue-with-pos?
        :pos->element pos->element
        :continue-with-val? continue-with-val?
        :early-next-pos early-next-pos
        :continue-after-pos+val? #f
        :next-pos next-pos)]))

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
    (unless (sequence? seq)
      (raise-argument-error 'sequence-generate "sequence?" seq))
    (let ([vals #f] [next (λ () (sequence-generate* (sequence->do-sequence seq)))])
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
    (unless (sequence? seq)
      (raise-argument-error 'sequence-generate "sequence?" seq))
    (let*-values ([(do-seq) (sequence->do-sequence seq)]
                  [(pos->element
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
                            (values val* (λ () (loop pos))))
                          (values #f raise-sequence-empty-error)))
                    (values #f raise-sequence-empty-error)))
              (values #f raise-sequence-empty-error))))))

  (define in-naturals
    (λ ([start 0])
      (initiate-do-sequence
       :init-pos start
       :pos->element values
       :next-pos add1)))
  (define (in-values . v*)
    (make-do-sequence
     (λ ()
       (define first? #t)
       (define (continue-with-pos? _)
         (and first? (begin (set! first? #f) #t)))
       (values list->values #f values v* continue-with-pos? #f #f))))

  (define (make-in-range who >? <?)
    (define (in-range start end step)
      (unless (real? start)
        (raise-argument-error who "real?" start))
      (unless (real? end)
        (raise-argument-error who "real?" end))
      (unless (real? step)
        (raise-argument-error who "real?" step))
      (let ([next-pos (λ (pos) (+ pos step))]
            [continue-with-pos?
             (if (< step 0)
                 (λ (pos) (>? pos end))
                 (λ (pos) (<? pos end)))])
        (initiate-do-sequence
         :init-pos start
         :continue-with-pos? continue-with-pos?
         :pos->element values
         :next-pos next-pos)))
    (case-λ
      [(end) (in-range 0 end 1)]
      [(start end) (in-range start end 1)]
      [(start end step) (in-range start end step)]))
  (define in-range (make-in-range 'in-range > <))
  (define in-inclusive-range (make-in-range 'in-inclusive-range >= <=))

  (define (in-list* l)
    (initiate-do-sequence
     :init-pos l
     :continue-with-pos? pair?
     :pos->element car
     :next-pos cdr))

  (define (make-in-vec who expected vec? vec-ref vec-length)
    (define (in-vec vec start stop step)
      (unless (vec? vec)
        (raise-argument-error who expected vec))
      (unless (real? start)
        (raise-argument-error who "real?" start))
      (unless (real? stop)
        (raise-argument-error who "real?" stop))
      (unless (real? step)
        (raise-argument-error who "real?" step))
      (let ([stop (or stop (vec-length vec))])
        (initiate-do-sequence
         :init-pos start
         :continue-with-pos?
         (if (< step 0)
             (λ (pos) (> pos stop))
             (λ (pos) (< pos stop)))
         :pos->element (λ (pos) (vec-ref vec pos))
         :next-pos (λ (pos) (+ pos step)))))
    (case-λ
      [(vec) (in-vec vec 0 (vec-length vec) 1)]
      [(vec start) (in-vec vec start (vec-length vec) 1)]
      [(vec start stop) (in-vec vec start stop 1)]
      [(vec start stop step) (in-vec vec start stop step)]))
  (define in-string (make-in-vec 'in-string "string?" string? string-ref string-length))
  (define in-vector (make-in-vec 'in-vector "vector?" vector? vector-ref vector-length))
  (define in-bytevector (make-in-vec 'in-bytevector "bytevector?" bytevector? bytevector-u8-ref bytevector-length))

  (define (in-hashtable ht)
    (unless (hashtable? ht)
      (raise-argument-error 'in-hashtable "hashtable?" ht))
    (let-values ([(k* v*) (hashtable-entries ht)])
      (initiate-do-sequence
       :init-pos 0
       :continue-with-pos? (</c (vector-length k*))
       :pos->element (λ (pos) (values (vector-ref k* pos) (vector-ref v* pos)))
       :next-pos add1)))

  (define in-port
    (λ ([r read] [in (current-input-port)])
      (unless (procedure? r)
        (raise-argument-error 'in-port "procedure?" r))
      (unless (input-port? in)
        (raise-argument-error 'in-port "input-port?" in))
      (initiate-do-sequence
       :init-pos in
       :continue-with-pos? (not/c port-eof?)
       :pos->element r
       :next-pos values)))
  (define (port->sequence in) (in-port read in))

  (define-sequence natural? in-range)
  (define-sequence string? in-string)
  (define-sequence vector? in-vector)
  (define-sequence bytevector? in-bytevector)
  (define-sequence list*? in-list*)
  (define-sequence hashtable? in-hashtable)
  (define-sequence input-port? port->sequence))
