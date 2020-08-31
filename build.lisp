(compile-file "workmode.lisp" :output-file "workmode.o" :system-p t)
(c::build-program "workmode" :lisp-files '("workmode.o"))
(ext:quit 0)
