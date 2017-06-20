(in-package :cl-user)
(defpackage matplotlib-cl-asd
  (:use #:cl #:asdf))
(in-package :matplotlib-cl-asd)

(defsystem matplotlib-cl
  :version "0.1"
  :author "TANI Kojiro"
  :license "MIT"
  :depends-on (#:cl-ppcre #:alexandria #:burgled-batteries)
  :components ((:file "matplotlib-cl"))
  :description "A 2D Plotting library for Common Lisp using Matplotlib."
  :long-description
  #.(with-open-file (stream (merge-pathnames
                             #p"README.md"
                             (or *load-pathname* *compile-file-pathname*))
                            :if-does-not-exist nil
                            :direction :input)
      (when stream
        (let ((seq (make-array (file-length stream)
                               :element-type 'character
                               :fill-pointer t)))
          (setf (fill-pointer seq) (read-sequence seq stream)) seq))))
