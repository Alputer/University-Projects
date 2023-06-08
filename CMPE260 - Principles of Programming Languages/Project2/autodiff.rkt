; alp tuna
; 2019400288
; compiling: yes
; complete: yes

#lang racket ; Specifies the language version which we are using.
(provide (all-defined-out))

(struct num (value grad)
  #:property prop:custom-write
  (lambda (num port write?)
    (fprintf port (if write? "(num ~s ~s)" "(num ~a ~a)")
             (num-value num) (num-grad num))))



;; Below definitions are given to us.
(define relu (lambda (x) (if (> (num-value x) 0) x (num 0.0 0.0))))
(define mse (lambda (x y) (mul (sub x y) (sub x y))))



;num-list is the parameter. get-value is the name of the function.
(define (get-value numlist) ;num-list can either be a list of num structs or a num struct !!
  (if (list? numlist) 
      (if (equal? 1 (length numlist)) (list (cadar numlist)) ; return 2nd element.
          (cons (cadar numlist)  (get-value (cdr numlist)))  ;inner else part
          )
      (num-value numlist)  ;outer else part
      )
  )

(define (get-grad numlist) ;num-list can either be a list of num structs or a num struct !!
  (if (list? numlist) 
      (if (equal? 1 (length numlist))  (cddar numlist) ; return 3rd element.
          (cons (caddar numlist)  (get-grad (cdr numlist)))  ;inner else part
          )
      (num-grad numlist)  ;outer else part
      )
  )


(define (add_values numlist)
  (if (equal? 1 (length numlist))
      (num-value (car numlist))
      (+ (num-value (car numlist)) (add_values (cdr numlist)))   ;else part.

      )
  )

(define (add_grads numlist)
  (if (equal? 1 (length numlist))
      (num-grad (car numlist))
      (+ (num-grad (car numlist)) (add_grads (cdr numlist)))   ;else part.

      )
  )

(define (mul_values numlist)
  (if (equal? 1 (length numlist))
      (num-value (car numlist))
      (* (num-value (car numlist)) (mul_values (cdr numlist)))   ;else part.

      )
  )

(define (mul_grads numlist curr_val)
  (if (equal? 1 (length numlist))
      (* (num-grad (car numlist)) curr_val)
      (+ (* (num-grad (car numlist)) curr_val (mul_values (cdr numlist))) (mul_grads (cdr numlist) (* curr_val (num-value (car numlist)))))
     )
  )

(define (add . parameters) ; I am fantastic!!!
  (num (add_values parameters) (add_grads parameters))
  )

(define (mul . parameters) ; I am fantastic!!!
  (num (mul_values parameters) (mul_grads parameters 1))
  )

(define (sub num1 num2) ; I am fantastic!!!
  (num (- (num-value num1) (num-value num2)) (- (num-grad num1) (num-grad num2)))

  )

;;;; Hash Part 5.1 Beginning ;;;;;;;

(define (create-hash names values var )
  (if (equal? 1 (length names))
      (hash  (car names) (num (car values) (if (equal? var (car names)) 1.0 0.0)))
      (hash-set (create-hash (cdr names) (cdr values) var) (car names) (num (car values) (if (equal? var (car names)) 1.0 0.0)))
      )
)

;;;; Hash Part 5.1 End ;;;;;;;

;;;; Hash Part 5.2 Beginning ;;;;;;;

(define (parse hash expr )
(cond
 ((null? expr) '())
 ((list? expr) (cons (parse hash (car expr)) (parse hash (cdr expr))))
 ((equal? expr '+) 'add)
 ((equal? expr '-) 'sub)
 ((equal? expr '*) 'mul)
 ((equal? expr 'mse) 'mse)
 ((equal? expr 'relu) 'relu)
 ((number? expr) (num expr 0.0))
 (else (hash-ref hash expr))
)
)

;;;; Hash Part 5.2 End ;;;;;;;

;;;; Hash Part 5.3 Beginning;;;;;;;
(define (grad names values var expr)
  (num-grad (eval (parse (create-hash names values var) expr)))
)

;;;; Hash Part 5.3 End;;;;;;;

;;;; Hash Part 5.4 Beginning;;;;;;;
(define (partial-grad-helper all_names remaining_names values vars expr)
  (if (equal? 1 (length remaining_names))
      (if (member (car remaining_names) vars) (list(grad all_names values (car remaining_names) expr)) '(0.0))
      
      (cons (if (member (car remaining_names) vars) (grad all_names values (car remaining_names) expr) 0.0)
                                                    (partial-grad-helper all_names (cdr remaining_names) values vars expr))
  )
 )
(define (partial-grad names values vars expr)

(partial-grad-helper names names values vars expr)
 
)
;;;; Hash Part 5.4 End ;;;;;;;

;;;; Hash Part 5.5 Beginning;;;;;;;
(define (lr_list lr size) ; Returns list of size(size) of lr's. (e.g '(0.1 0.1 0.1 0.1))
 (if (equal? 1 size)
 (list lr)
 (cons lr (lr_list lr (- size 1)))
 )
)
(define (gradient-descent names values vars lr expr )
  (map - values (map * (partial-grad names values vars expr) (lr_list lr (length values))))
)  

;;;; Hash Part 5.5 End ;;;;;;;

;;;; Hash Part 5.6 Beginning ;;;;;;;
(define (gradient-descent-helper names values vars lr k expr )
  (if (equal? k 0)
   values ; no iteration.
  (gradient-descent-helper names (map - values (map * (partial-grad names values vars expr) (lr_list lr (length values)))) vars lr (- k 1) expr ) 
  )
)  
(define (optimize names values vars lr k expr)
  (gradient-descent-helper names values vars lr k expr)
)
;;;; Hash Part 5.6 End ;;;;;;;
