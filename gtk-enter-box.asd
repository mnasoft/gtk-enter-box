;;;; gtk-enter-box.asd

(asdf:defsystem "gtk-enter-box"
  :description "Describe gtk-enter-box here"
  :author "Your Name <your.name@example.com>"
  :license  "Specify license here"
  :version "0.0.1"
  :depends-on ("cl-cffi-gtk")
  :serial t
  :components ((:module "src"
		:serial nil
                :components ((:file "gtk-enter-box")))))
