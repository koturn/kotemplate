(defun split-by-one-space (string)
  (loop for i = 0 then (1+ j)
        as j = (position #\Space string :start i)
        collect (subseq string i j)
        while j))

(defun main ()
  (print (mapcar #'parse-integer
                 (split-by-one-space (read-line))))
  <+CURSOR+>)

(main)
