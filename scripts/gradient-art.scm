;; Repeat the given function func x times
(define (repeat func x-times)
  (cond ((> x-times 0)
	 (func)
	 (repeat func (1- x-times)))))

(define (script-fu-gradient-art image drawable x-times gradient-type blend-type)
  (gimp-image-undo-disable image)

  (let* ((width  (car (gimp-drawable-width  drawable)))
	 (height (car (gimp-drawable-height drawable))))
    ;; Apply a random gradient x times to the drawable
    (repeat (lambda ()
	      (gimp-blend drawable blend-type DIFFERENCE-MODE gradient-type
			  100 0 REPEAT-NONE FALSE 0 0
			  (rand width) (rand height)
			  (rand width) (rand height)))
	    x-times))

  (gimp-image-undo-enable image)
  (gimp-displays-flush))

; Register the function with the GIMP:
(script-fu-register "script-fu-gradient-art"
		    "<Image>/Script-Fu/Grumbel/Gradient Art"
		    ""  
		    "Ingo Ruhnke"      ;; Author
		    "GPL" ;; Copyright
		    "Thu Aug 24 01:14:11 2000" ;; Date
		    "*"
		    SF-IMAGE    "Image" 0
		    SF-DRAWABLE "Drawable" 0
		    SF-VALUE    "Repeat" "10"
		    SF-OPTION   "Gradient Type" '("linear" "bilinear" "radial" "square")
		    SF-OPTION   "Blend Type" '("foreground-background (rgb)" "foreground-background (hsv)" "foreground trans." "custom"))

;; EOF ;;