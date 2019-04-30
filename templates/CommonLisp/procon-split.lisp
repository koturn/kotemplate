(defun split-by-one-space (string)
  "Split string by one space"
  (declare (optimize (safety 0) (space 0) (debug 0) (speed 3)))
  (loop for i = 0 then (1+ j)
        as j = (position #\Space string :start i)
        collect (subseq string i j)
        while j))

(defun main ()
  "Main function"
  (declare (optimize (safety 0) (space 0) (debug 0) (speed 3)))
  (loop for line = nil then
        (let ((tokens (mapcar #'parse-integer
                              (split-by-one-space line))))
          (princ tokens)
          <+CURSOR+>)
        until (null (setq line (read-line)))))

(main)
