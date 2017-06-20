(defpackage #:matplotlib-cl
  (:nicknames #:plt)
  (:use #:cl)
  (:shadow #:close #:fill #:get #:step)
  (:export #:*pyplot-functions*))

(in-package :matplotlib-cl)

(eval-when (:compile-toplevel :load-toplevel :execute)
  (burgled-batteries:startup-python)
  (handler-case
    (burgled-batteries:run "import matplotlib.pyplot as plt")
    (error () (error "Failed to import `matplotlib`.")))

  (mapcar
    #'burgled-batteries:run
    '("from string import lowercase as lc"
      "l = filter(lambda _: callable(eval('plt.%s' % _)), tuple(dir(plt)))"
      "list_pyplot_functions = lambda: filter(lambda _: _[0] in lc, l)"
      "call = lambda fn, args, kw: eval(fn)(*args, **kw)"))

  (burgled-batteries:defpyfun ("call" call-pyfun) (name args kwargs))
  (burgled-batteries:defpyfun ("list_pyplot_functions" list-pyplot-functions) nil)

  (defparameter *pyplot-functions* (list-pyplot-functions))

  (defun pyname-lisp-name (name)
    (cl-ppcre:regex-replace-all "\\_" (string-upcase name) "-"))

  (defun make-def (name)
   (let ((plt-name (format nil "plt.~a" name)))
     `(progn
       (defun ,(intern (pyname-lisp-name name)) (&rest args)
        ,(format nil "Call Python's `matplotlib.pyplot.~a`. Return T." name)
        (if args
          (apply #'call-pyfun ,plt-name (parse-args args))
          (burgled-batteries:run (format nil "~a()" ,plt-name))) t)
        (eval-when (:compile-toplevel :load-toplevel :execute)
          (export
            (find-symbol ,(pyname-lisp-name name) 'matplotlib-cl)
             'matplotlib-cl))))))

(defgeneric float-double (value))
(defmethod float-double ((value float))
  (coerce value 'double-float))
(defmethod float-double ((value list))
  (if value (mapcar #'float-double value) nil))
(defmethod float-double ((value vector))
  (mapcar #'float-double (map 'list #'identity value)))
(defmethod float-double ((value string)) value)
(defmethod float-double ((value t)) value)

(defun parse-args (args)
  (let ((normal-args nil) (count 0))
    (loop
      (when (not args) (return))
      (if (not (keywordp (car args)))
        (push (pop args) normal-args)
        (return)))
    (list
      (mapcar #'float-double (reverse normal-args))
      (alexandria:plist-hash-table
        (mapcar #'float-double
          (mapcar #'(lambda (x)
            (if (keywordp x) (string x) x)) args))))))

(defmacro initialize ()
 `(progn ,@(mapcar #'make-def *pyplot-functions*)
    (map-into *pyplot-functions* #'pyname-lisp-name *pyplot-functions*)))

(initialize)
