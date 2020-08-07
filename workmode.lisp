
(defparameter +worktime-file+ #p"/etc/hosts_worktime")
(defparameter +playtime-file+ #p"/etc/hosts_worktime_off")
(defparameter +hosts+ #p"/etc/hosts")
(defparameter +work-starts-hour+ 7)
(defparameter +work-stops-hour+ 14)

(defun files-differ-p (f1 f2)
  (with-open-file (file1 f1)
    (with-open-file (file2 f2)
      (loop
         :for c1 = (read-char file1 nil nil)
         :for c2 = (read-char file2 nil nil)
         :while (or c1 c2)
         :unless (eql c1 c2) :do (return t))))) 

(defun copy-if-different (source target)
  (when (files-differ-p source target)
    (with-open-file (output target :direction :output :if-exists :supersede)
      (with-open-file (input source)
        (loop
           :for char = (read-char input nil nil)
           :while char :do (write-char char output))))))

(defun hour-in-range-p (hour)
  (and (<= +work-starts-hour+ hour)
       (< hour +work-stops-hour+)))

(defun main ()
  (let ((hour  (nth-value 2 (get-decoded-time))))
    (if (hour-in-range-p hour)
        (copy-if-different +worktime-file+ +hosts+)
        (copy-if-different +playtime-file+ +hosts+))))

(handler-case (main)
  (error (c) (ext:quit 1)))
(ext:quit 0)
