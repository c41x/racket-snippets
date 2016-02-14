#lang racket
(require (prefix-in s. srfi/19))
(require racket/date)

(define (string-date->int str)
  (date->seconds (s.string->date str "~Y-~m-~d ~H:~M:~S")))

(define (preprocess in)
  (let ((line (read-line in 'any)))
    (unless (eof-object? line)
      (let ((match (regexp-match #rx"^([^;]*);;([^;]*);;[^;]*;;([^;]*);;([^;]*);;([^;]*);;([^;]*);;([^;]*);;([^;]*);;" line)))
        (when (and match (not (string=? (list-ref match 7) ""))) ;; date is not empty
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
          (display "\" 3 " out)
          (display (string-date->int (list-ref match 7)) out)
          (display ")" out)
          (newline out)))
      (preprocess in))))

(define out (open-output-file "data.processed.date.last.lisp" #:exists 'truncate))
(call-with-input-file "data.processed.raw.txt" preprocess)
(close-output-port out)