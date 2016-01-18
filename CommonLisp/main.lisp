(defun main (args)
  "Main function"
  <+CURSOR+>
  (prin1 args)
  (princ args)
  (print args)
  (pprint args))

(main ((lambda ()
         #+allegro (system:command-line-arguments)
         #+sbcl sb-ext:*posix-argv*
         #+clisp ext:*args*
         #+ecl (si:command-args)
         #+cmu ext:*command-line-words*
         #+ccl ccl:*command-line-argument-list*
         #+lispworks system:*line-arguments-list*)))
