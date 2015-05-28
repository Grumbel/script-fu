(define (my-demo-box value adj1 adj2 image drawable toggle pattern string font color option gradient)
  (print "Do nothing"))

(script-fu-register "my-demo-box"
		    "<Toolbox>/Xtns/Script-Fu/My Stuff/Demo Box..."
		    "Do nothing"
		    "Joe User"
		    "Joe User"
		    "August 2000"
		    ""
		    SF-ADJUSTMENT "SF-ADJUSTMENT (slider)" '( 30 1 2000 1 10 1 0)
		    SF-ADJUSTMENT "SF-ADJUSTMENT"         '(400 1 2000 1 10 1 1)
		    SF-COLOR      "SF-COLOR" '(255 0 255)
		    SF-DRAWABLE   "SF-DRAWABLE" 0
		    SF-FILENAME   "SF-FILENAME" "/"
		    SF-FONT       "SF-FONT" ""
		    SF-GRADIENT   "SF-GRADIENT"  "Golden"
		    SF-IMAGE      "SF-IMAGE" 0
		    SF-OPTION     "SF-OPTION" '("Option 1" "Option 2" "Option 3")
		    SF-PATTERN    "SF-PATTERN" "Wood"
		    SF-STRING     "SF-STRING" "Test String"
		    SF-TOGGLE     "SF-TOGGLE" TRUE
		    SF-VALUE      "SF-VALUE" "0")

;; EOF ;;