(in-package :cl-user)
(defpackage matplotlib-cl-test
  (:use :cl :prove))
(in-package :matplotlib-cl-test)

(defvar *t* (loop for x from 0 below 2 by 0.01 collect x))
(defvar *s* (mapcar (lambda (x) (1+ (sin (* 2 PI x)))) *t*))

(plan 6)

(is (plt::pyname-lisp-name "test") "TEST")
(is (plt::pyname-lisp-name "test_test") "TEST-TEST")
(is (plt::pyname-lisp-name "test_test_test") "TEST-TEST-TEST")
(is (plt::call-pyfun "range" '(1 9 2) (make-hash-table)) #(1 3 5 7) :test #'equalp)
(ok (plt:plot *t* *s*))
(ok (plt:xlabel "time (s)"))
(ok (plt:ylabel "voltage (mV)"))
(ok (plt:title "About as simple as it gets, folks"))
(ok (plt:grid t))
(ok (plt:savefig "test.png"))
(ok (if (probe-file #p"test.png") (progn (delete-file #p"test.png") t)))

(finalize)
