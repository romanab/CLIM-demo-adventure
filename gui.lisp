(cl:in-package #:clim-demo-adventure-gui)

(define-application-frame adventure ()
  ((%visited-places :initarg :visited-places :accessor visited-places))
  (:panes
   (text :application
	 :width 800 :height 400
	 :display-function 'display-application
	 :scrollbars t)
   (inter :interactor :width 800 :height 100))
  (:layouts
   (:default (vertically () text inter))))

(defun display-application (frame pane)
  (loop for place in (reverse (visited-places frame))
	do (clim-demo-adventure::show place pane)
	   (format pane "-----~%"))
  (finish-output pane))

(defun clim-demo-adventure:adventure ()
  (run-frame-top-level
   (make-application-frame
    'adventure
    :visited-places (list (clim-demo-adventure:make-world)))))

(define-adventure-command (com-quit :name t) ()
  (frame-exit *application-frame*))

(define-presentation-type direction ()
  :inherit-from 'string)

(defun new-place (name directions)
  (cdr (assoc name directions :test #'equal)))

(define-adventure-command (com-go :name t)
    ((direction 'direction))
  (let* ((current-place (first (visited-places *application-frame*)))
	 (possible-directions (clim-demo-adventure:directions current-place))
	 (new-place (new-place direction possible-directions)))
    (if (null new-place)
	(progn (format *standard-input* "You can not go that way!~%")
	       (finish-output))
	(push new-place (visited-places *application-frame*)))))
