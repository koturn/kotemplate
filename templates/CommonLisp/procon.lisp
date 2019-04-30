(defun main ()
  "Main function"
  (declare (optimize (safety 0) (space 0) (debug 0) (speed 3)))
  (loop for a = nil then b
        and b = nil then
        (progn (format t "~A ~A ~%" a b)
               <+CURSOR+>)
        until (or (null (setq a (read)))
                  (null (setq b (read))))))

(main)
