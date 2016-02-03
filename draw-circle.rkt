#lang racket
(require racket/draw)
(define target (make-bitmap 500 500))
(define dc (new bitmap-dc% [bitmap target]))

(define (draw-circle x y precision steps)
  (send dc draw-ellipse (+ 250.0 x) (+ 250.0 y) 1 1)
  (when (> steps 0)
    (draw-circle (- x (* y precision)) ;; derivative: dx/dt = -y
                 (+ y (* x precision)) ;; derivative: dy/dt = x
                 precision
                 (- steps 1))))

(draw-circle 100.0 0.0 0.001 10000)
(send target save-file "test.png" 'png) ;; writes to user directory