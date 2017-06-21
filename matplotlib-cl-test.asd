(in-package :cl-user)
(defpackage matplotlib-cl-test-asd
  (:use #:cl #:asdf))
(in-package :matplotlib-cl-test-asd)

(defsystem matplotlib-cl-test
  :depends-on (#:matplotlib-cl #:prove)
  :defsystem-depends-on (#:prove-asdf)
  :components ((:module "t"
                :components
		((:test-file "matplotlib-cl"))))
  :perform (test-op :after (op c)
                    (funcall (intern #.(string :run) :prove) c)))
