
(defparameter +worktime-file+ #p"/etc/hosts_worktime")
(defparameter +playtime-file+ #p"/etc/hosts_worktime_off")
(defparameter +hosts+ #p"/etc/hosts")
(defparameter +work-starts-hour+ 7)
(defparameter +work-starts-min+ 30)
(defparameter +work-stops-hour+ 12)
(defparameter +work-stops-min+ 01)

(defun files-differ-p (f1 f2)
  (with-open-file (file1 f1)
    (with-open-file (file2 f2)
      (loop
         :for c1 = (read-char file1 nil nil)
         :for c2 = (read-char file2 nil nil)
         :while (or c1 c2)
         :unless (eql c1 c2) :do (return t))))) 

(defun copy-if-different (source target)
  (format t "copying ~a to ~a~%" source target)
  (when (files-differ-p source target)
    (with-open-file (output target :direction :output :if-exists :supersede)
      (with-open-file (input source)
        (loop
          :for char = (read-char input nil nil)
          :while char :do (write-char char output))))))

(defun hour-min-lt (h0 m0 h1 m1)
  (or (< h0 h1)
      (and (= h0 h1) (< m0 m1))))

(defun time-in-range-p (h m)
  (and (hour-min-lt +work-starts-hour+ +work-starts-min+ h m)
       (hour-min-lt h m +work-stops-hour+ +work-stops-min+)))


(defun main ()
  (multiple-value-bind (sec min hour) (get-decoded-time)
    (declare (ignore sec))
    (if (time-in-range-p hour min)
        (copy-if-different +worktime-file+ +hosts+)
        (copy-if-different +playtime-file+ +hosts+))))

(handler-case (main)
  (error (c) (ext:quit 1)))
(ext:quit 0)
