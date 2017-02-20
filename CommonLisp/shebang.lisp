#!/bin/sh -eu

#|
run_if_exists() {
  command -v $1 > /dev/null 2>&1 && exec "$@"
}
run_if_exists sbcl --noinform --no-sysinit --no-userinit --script "$0" -- "$@"
run_if_exists clisp -norc --quiet --silent -on-error exit  "$0" -- "$@"
run_if_exists ecl -norc -q -shell "$0" -- "$@"
run_if_exists mkcl -norc -q -shell "$0" -- "$@"
run_if_exists alisp -qq -#! "$0" -- "$@"
echo 'No available Common Lisp processor was not found.' 2>&1
exit 1
|#

(defun main (args)
  "Main function"
  <+CURSOR+>
  (prin1 args)
  (princ args)
  (print args)
  (pprint args))

(main (progn
        #+allegro (cdr (system:command-line-arguments))
        #+sbcl (do* ((var sb-ext:*posix-argv* (cdr list))
                     (list var var))
                 ((string= (car list) "--") (return (cdr list))))
        #+clisp ext:*args*
        #+ecl (do* ((var (si:command-args) (cdr list))
                    (list var var))
                ((string= (car list) "--") (return (cdr list))))
        #+abcl extensions:*command-line-argument-list*
        #+gcl (do* ((var si::*command-args* (cdr list))
                    (list var var))
                ((string= (car list) "--") (return (cdr list))))
        #+cmu ext:*command-line-words*
        #+ccl ccl:*unprocessed-command-line-arguments*
        #+mkcl (do* ((var (si:command-args) (cdr list))
                     (list var var))
                 ((string= (car list) "--") (return (cdr list))))
        #+lispworks system:*line-arguments-list*))
