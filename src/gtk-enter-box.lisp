;;;; ./src/gtk-enter-box.lisp
;;;; gtk-enter-box.lisp

(defpackage :gtk-enter-box
  (:use #:cl))

(in-package :gtk-enter-box)

;;;; Example Text Entry (2021-6-11)

#+nil
(defun example-text-entry ()
  (within-main-loop
    (let* ((window (make-instance 'gtk-window
                                  :type :toplevel
                                  :title "Example Text Entry"
                                  :default-width 250
                                  :default-height 120))
           (vbox (make-instance 'gtk-box :orientation :vertical))
           (hbox (make-instance 'gtk-box :orientation :horizontal))
           (entry (make-instance 'gtk-entry
                                 :text "Hello"
                                 :max-length 50))
           (pos (gtk-entry-text-length entry)))
      (g-signal-connect window "destroy"
                        (lambda (widget)
                          (declare (ignore widget))
                          (leave-gtk-main)))
      (g-signal-connect entry "activate"
                        (lambda (widget)
                          (declare (ignore widget))
                          (format t "Entry contents: ~A"
                                  (gtk-entry-text entry))))
      (gtk-editable-insert-text entry " world" pos)
      (gtk-editable-select-region entry 0 (gtk-entry-text-length entry))
      (gtk-box-pack-start vbox entry :expand t :fill t :padding 0)
      (let ((check (gtk-check-button-new-with-label "Editable")))
        (g-signal-connect check "toggled"
           (lambda (widget)
             (declare (ignore widget))
             (setf (gtk-editable-editable entry)
                   (gtk-toggle-button-active check))))
        (gtk-box-pack-start hbox check))
      (let ((check (gtk-check-button-new-with-label "Visible")))
        (setf (gtk-toggle-button-active check) t)
        (g-signal-connect check "toggled"
           (lambda (widget)
             (declare (ignore widget))
             (setf (gtk-entry-visibility entry)
                   (gtk-toggle-button-active check))))
        (gtk-box-pack-start hbox check))
      (gtk-box-pack-start vbox hbox)
      (gtk-container-add window vbox)
      (gtk-widget-show-all window))))

(defun example-combo-box-text ()
  (gtk:within-main-loop
    (let ((window (make-instance 'gtk:gtk-window :border-width 12 :title "Example Combo Box Text"))
          (vbox1 (make-instance  'gtk:gtk-box    :orientation :vertical :spacing 6))
          (vbox2 (make-instance  'gtk:gtk-box    :orientation :vertical :spacing 6))
          (hbox  (make-instance  'gtk:gtk-box    :orientation :horizontal :spacing 24))
          (label (make-instance  'gtk:gtk-label  :label "Label"))
          (combo (make-instance  'gtk:gtk-combo-box-text :has-entry t)))
      ;; Setup the combo box
      (gtk:gtk-combo-box-text-append-text combo "First entry")
      (gtk:gtk-combo-box-text-append-text combo "Second entry")
      (gtk:gtk-combo-box-text-append-text combo "Third entry")
      ;; Combo box selection has changed
      (g:g-signal-connect combo "changed"
          (lambda (object)
            (let ((value (gtk:gtk-combo-box-text-get-active-text object)))
              (gtk:gtk-label-set-markup label
                                    (format nil "<tt>~a</tt>" value)))))
      ;; Select the first entry of the combo box
      (setf (gtk:gtk-combo-box-active combo) 0)
      ;; Setup the entry for the combo box
      (let ((entry (gtk:gtk-bin-get-child combo)))
        (setf (gtk:gtk-entry-primary-icon-name entry) "list-add")
        (setf (gtk:gtk-entry-primary-icon-tooltip-text entry) "Add to Combo Box")
        (setf (gtk:gtk-entry-secondary-icon-name entry) "list-remove")
        (setf (gtk:gtk-entry-secondary-icon-tooltip-text entry)
              "Remove from Combo Box")
        ;; Toggle the primary and secondary icons of the entry
        (g:g-signal-connect entry "focus-in-event"
            (lambda (widget event)
              (declare (ignore event))
              (setf (gtk:gtk-entry-primary-icon-sensitive widget) t)
              (setf (gtk:gtk-entry-secondary-icon-sensitive widget) nil)))
        (g:g-signal-connect entry "focus-out-event"
            (lambda (widget event)
              (declare (ignore event))
              (setf (gtk:gtk-entry-primary-icon-sensitive widget) nil)
              (setf (gtk:gtk-entry-secondary-icon-sensitive widget) t)))
        ;; One of the icons of the entry has been pressed
        (g:g-signal-connect entry "icon-press"
            (lambda (object pos event)
              (declare (ignore event))
              (if (eq :primary pos)
                  (let ((text (gtk:gtk-entry-text object)))
                    (gtk:gtk-combo-box-text-append-text combo text))
                  (let ((active (gtk:gtk-combo-box-active combo)))
                    (gtk:gtk-combo-box-text-remove combo active)
                    (setf (gtk:gtk-combo-box-active combo) active))))))
      ;; Pack and show widgets
      (gtk:gtk-box-pack-start
       vbox1 (make-instance 'gtk:gtk-label :xalign 0 :use-markup t :label "<b>Select item</b>")
       :expand nil)
      (gtk:gtk-box-pack-start vbox1 combo)
      (gtk:gtk-box-pack-start hbox vbox1)
      (gtk:gtk-box-pack-start
       vbox2 (make-instance
              'gtk:gtk-label :xalign 0 :use-markup t :label "<b>Activated item</b>")
                                 :expand nil)
      (gtk:gtk-box-pack-start vbox2 label)
      (gtk:gtk-box-pack-start hbox vbox2)
      (gtk:gtk-container-add window hbox)
      (gtk:gtk-widget-show-all window))))

(defun example-combo-box-text-1 ()
  (gtk:within-main-loop
    (let ((window (make-instance 'gtk:gtk-window :border-width 12 :title "Example Combo Box Text"))
          (vbox1 (make-instance  'gtk:gtk-box    :orientation :vertical   :spacing 6))
          (vbox2 (make-instance  'gtk:gtk-box    :orientation :vertical   :spacing 6))
          (hbox  (make-instance  'gtk:gtk-box    :orientation :horizontal :spacing 24))
          (label (make-instance  'gtk:gtk-label  :label "Label"))
          (combo (make-instance  'gtk:gtk-combo-box-text :has-entry nil)))
      ;; Setup the combo box
      (gtk:gtk-combo-box-text-append-text combo "First entry")
      (gtk:gtk-combo-box-text-append-text combo "Second entry")
      (gtk:gtk-combo-box-text-append-text combo "Third entry")
      ;; Combo box selection has changed
      #+nil
      (g:g-signal-connect combo "changed"
          (lambda (object)
            (let ((value (gtk:gtk-combo-box-text-get-active-text object)))
              (gtk:gtk-label-set-markup label
                                    (format nil "<tt>~a</tt>" value)))))
      ;; Select the first entry of the combo box
      (setf (gtk:gtk-combo-box-active combo) 0)
      (break "~A" (gtk:gtk-combo-box-active-id combo))
      (break "~A" (::GTK-BIN-GET-CHILD combo))
        (g:g-signal-connect combo "changed"
            (lambda (object pos event)
              (declare (ignore event))
              (if (eq :primary pos)
                  (let ((text (gtk:gtk-entry-text object)))
                    (gtk:gtk-combo-box-text-append-text combo text))
                  (let ((active (gtk:gtk-combo-box-active combo)))
                    (gtk:gtk-combo-box-text-remove combo active)
                    (setf (gtk:gtk-combo-box-active combo) active)))))
      ;; Setup the entry for the combo box
      #+nil
      (let ((entry (gtk:gtk-bin-get-child combo)))
        (setf (gtk:gtk-entry-primary-icon-name entry) "list-add")
        (setf (gtk:gtk-entry-primary-icon-tooltip-text entry) "Add to Combo Box")
        (setf (gtk:gtk-entry-secondary-icon-name entry) "list-remove")
        (setf (gtk:gtk-entry-secondary-icon-tooltip-text entry)
              "Remove from Combo Box")
        ;; Toggle the primary and secondary icons of the entry
        (g:g-signal-connect entry "focus-in-event"
            (lambda (widget event)
              (declare (ignore event))
              (setf (gtk:gtk-entry-primary-icon-sensitive widget) t)
              (setf (gtk:gtk-entry-secondary-icon-sensitive widget) nil)))
        (g:g-signal-connect entry "focus-out-event"
            (lambda (widget event)
              (declare (ignore event))
              (setf (gtk:gtk-entry-primary-icon-sensitive widget) nil)
              (setf (gtk:gtk-entry-secondary-icon-sensitive widget) t)))
        ;; One of the icons of the entry has been pressed
        (g:g-signal-connect entry "icon-press"
            (lambda (object pos event)
              (declare (ignore event))
              (if (eq :primary pos)
                  (let ((text (gtk:gtk-entry-text object)))
                    (gtk:gtk-combo-box-text-append-text combo text))
                  (let ((active (gtk:gtk-combo-box-active combo)))
                    (gtk:gtk-combo-box-text-remove combo active)
                    (setf (gtk:gtk-combo-box-active combo) active))))))
      ;; Pack and show widgets
      (gtk:gtk-box-pack-start
       vbox1 (make-instance 'gtk:gtk-label :xalign 0 :use-markup t :label "<b>Select item</b>")
       :expand nil)
      (gtk:gtk-box-pack-start vbox1 combo)
      (gtk:gtk-box-pack-start hbox vbox1)
      (gtk:gtk-box-pack-start
       vbox2 (make-instance
              'gtk:gtk-label :xalign 0 :use-markup t :label "<b>Activated item</b>")
                                 :expand nil)
      (gtk:gtk-box-pack-start vbox2 label)
      (gtk:gtk-box-pack-start hbox vbox2)
      (gtk:gtk-container-add window hbox)
      (gtk:gtk-widget-show-all window))))

;;(example-combo-box-text-1)

(defun example-text-entry-1 ()
  (gtk:within-main-loop
    (let* ((window (make-instance 'gtk:gtk-window
                                  :type :toplevel
                                  :title "Example Text Entry"
                                  :default-width 250
                                  :default-height 120))
           (vbox (make-instance 'gtk:gtk-box :orientation :vertical))
           (hbox (make-instance 'gtk:gtk-box :orientation :horizontal))
           (entry (make-instance 'gtk:gtk-entry
                                 :text "Hello"
                                 :max-length 50))
           #+nil
           (pos (gtk:gtk-entry-text-length entry)))
      (g:g-signal-connect window "destroy"
                        (lambda (widget)
                          (declare (ignore widget))
                          (gtk:leave-gtk-main)))
      (g:g-signal-connect entry "activate"
                        (lambda (widget)
                          (declare (ignore widget))
                          (format t "Entry contents: ~A"
                                  (gtk:gtk-entry-text entry))))
      
      
      (gtk:gtk-box-pack-start vbox entry :expand t :fill t :padding 0)
      (let ((check (gtk:gtk-check-button-new-with-label "Editable")))
        #+nil
        (g:g-signal-connect check "toggled"
           (lambda (widget)
             (declare (ignore widget))
             (setf (gtk:gtk-entry-set-ed editable-set-editable entry)
                   (gtk:gtk-toggle-button-active check))))
        (gtk:gtk-box-pack-start hbox check))
      (let ((check (gtk:gtk-check-button-new-with-label "Visible")))
        (setf (gtk:gtk-toggle-button-active check) t)
        (g:g-signal-connect check "toggled"
           (lambda (widget)
             (declare (ignore widget))
             (setf (gtk:gtk-entry-visibility entry)
                   (gtk:gtk-toggle-button-active check))))
        (gtk:gtk-box-pack-start hbox check))
      (gtk:gtk-box-pack-start vbox hbox)
      (gtk:gtk-container-add window vbox)
      (gtk:gtk-widget-show-all window))))

;;(example-text-entry-1)

