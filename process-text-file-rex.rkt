#lang racket
(define (preprocess in)
  (let ((line (read-line in 'any)))
    (unless (eof-object? line)
      (let ((match (regexp-match #rx"^([^;]*);;([^;]*);;[^;]*;;([^;]*);;([^;]*);;([^;]*);;([^;]*);;([^;]*);;([^;]*);;" line)))
        (when match
          (display "(ctags-set \"" out)
          (display (string-replace (string-append
                                    (list-ref match 2)
                                    (list-ref match 1)
                                    (list-ref match 4)
                                    (if (not (string=? (list-ref match 3) ""))
                                        (if (char=? (string-ref (list-ref match 3) 0) #\0) ;; remove filling 0's
                                            (substring (list-ref match 3) 1)
                                            (list-ref match 3))
                                        ""))
                                   "\"" "\\\"")
                   out)
          (display "\" 0 " out)
          (display (if (string=? (list-ref match 8) "") "0" (list-ref match 8)) out)
          (display ")" out)
          (newline out)))
      (preprocess in))))

(define out (open-output-file "data.processed.lisp" #:exists 'truncate))
(call-with-input-file "data.processed.raw.txt" preprocess)
(close-output-port out)