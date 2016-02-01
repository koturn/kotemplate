(define (main-function)
  (letrec ((main-loop (lambda ()
                        (let ((a (read)) (b (read)))
                          (if (or (eof-object? a)
                                  (eof-object? b))
                            #f
                            (begin (display a)
                                   (display " ")
                                   (display b)
                                   (newline)
                                   (main-loop)))))))
    (main-loop)))

(main-function)
