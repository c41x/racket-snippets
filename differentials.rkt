#lang racket

(define (atom? x)
  (and (not (null? x))
       (not (pair? x))))

(define (constant? exp var)
  (and (atom? exp)
       (not (eq? exp var))))

(define (same-var? exp var)
  (and (atom? exp)
       (eq? exp var)))

(define (sum? exp)
  (and (not (atom? exp))
       (eq? (car exp) '+)))

(define (product? exp)
  (and (not (atom? exp))
       (eq? (car exp) '*)))

(define (make-sum a1 a2)
  (list '+ a1 a2))

(define (make-sum-nice a1 a2)
  (cond ((and (number? a1)
	      (number? a2))
	 (+ a1 a2))
	((and (number? a1) (= a2 0)) a2)
	((and (number? a2) (= a1 0)) a1)
	(else (list '+ a1 a2))))

(define (make-product a1 a2)
  (list '* a1 a2))

(define (make-product-nice a1 a2)
  (cond ((and (number? a1)
	      (number? a2))
	 (* a1 a2))
	((and (number? a1) (= a1 0)) 0)
        ((and (number? a1) (= a1 1)) a2)
	((and (number? a2) (= a2 0)) 0)
	((and (number? a2) (= a2 1)) a1)
	(else (list '* a1 a2))))

(define s1 cadr)
(define s2 caddr)

(define p1 cadr)
(define p2 caddr)

(define (deriv exp var)
  (cond ((constant? exp var) 0) ;; derivative of const is 0
	((same-var? exp var) 1) ;; derivative of variable is 1
	((sum? exp) ;; derivative of sum is sum of derivatives of expressions
	 (make-sum-nice (deriv (s1 exp) var)
			(deriv (s2 exp) var)))
	((product? exp) ;; (f*g)' = f'*g + f*g'
	 (make-sum-nice (make-product-nice (p1 exp)
					   (deriv (p2 exp) var))
			(make-product-nice (deriv (p1 exp) var)
					   (p2 exp))))))

(deriv '(* x x) 'x)
