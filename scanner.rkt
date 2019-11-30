#lang racket
(require racket/gui/base)
(require racket/system)

(define frame (new frame%
                   [label "Scanner"]
                   [min-width 300]
                   [min-height 300]))

(define text-field (new text-field%
                        (label "Working directory")
                        (parent frame)
                        (init-value "")))

(define button
  (new button%
       (parent frame)
       (label "Choose working directory")
       (callback (lambda (a b)
                   (send text-field set-value
                         (path->string (get-directory)))))))

(define message (new message%
                     (parent frame)
                     (label "Scanned: 0")))

(define count 0)

(define button-scan
  (new button%
       (parent frame)
       (label "Scan")
       (callback (lambda (a b)
                   (set! count (+ count 1))
                   (system (string-append
                            "scanimage --mode Color --resolution 300 --format=png > "
                            (send text-field get-value)
                            "/img-"
                            (number->string count)
                            ".png"))
                   (send message set-label
                         (string-append "Scanned: "
                                        (number->string count)))))))

(send frame show #t)