#lang racket
(define (preprocess in)
  (let ((line (read-line in 'any)))
    (unless (eof-object? line)
      (when (or (regexp-match #rx";;[^;]+;;[^;]*$" line)
                (regexp-match #rx";;[^;]+;;[^;]*;;[^;]*;;;;[^;]*$" line))
        (display line out)
        (newline out))
      (preprocess in))))

(define out (open-output-file "data.processed.raw.txt" #:exists 'truncate))
(call-with-input-file "data.raw.txt" preprocess)
(close-output-port out)