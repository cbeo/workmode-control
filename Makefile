
ecl = ~/.roswell/impls/x86-64/linux/ecl/20.4.24/bin/ecl
build: workmode.lisp build.lisp
	$(ecl) --load build.lisp
