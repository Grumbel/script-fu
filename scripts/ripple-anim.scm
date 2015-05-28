(define (my-duplicate-layer image layer)
	(let* ((dup-layer (car (gimp-layer-copy layer 1))))
              (gimp-image-add-layer image dup-layer 0)
	      dup-layer))

(define (script-fu-ripple-animation image drawable frames period amplitude
				    orientation edges waveform antialias tile)
  (gimp-image-undo-disable image)
  ;; Convert the options to the correct values
  (let* ((orientation (cond ((equal? orientation "horizontal") 0)
			    ((equal? orientation "vertical")   1)))
	 (edges       (cond ((equal? edges       "swear") 0)
			    ((equal? edges       "wrap")  1)
			    ((equal? edges       "black") 2)))
	 (waveform    (cond ((equal? waveform    "sawtooth")  0)
			    ((equal? waveform    "sine wave") 1))))

    (for-each (lambda (i) 
		(let* ((dup-layer (my-duplicate-layer image drawable)))
		;;  (gimp-message (to-string (* amplitude (sin (* (* 2 3.1415927) (/ i frames))))))
		  (plug-in-ripple 1 image dup-layer
				  period (* amplitude (sin (* (* 2 3.1415927) (/ i frames))))
				  orientation 
				  edges waveform antialias tile)))
	      (seq 1 (+ frames 1) 1)))
  (gimp-image-undo-enable image)
  (gimp-displays-flush))

; Register the function with the GIMP:
(script-fu-register "script-fu-ripple-animation"
		    "<Image>/Script-Fu/Grumbel/Ripple Animation"
		    "Move the layer to the given position"  
		    "Ingo Ruhnke"      ;; Author
		    "2000 Ingo Ruhnke" ;; Copyright
		    "2000 Ingo Ruhnke" ;; Date
		    "RGB* INDEXED*"
		    SF-IMAGE    "Image" 0
		    SF-DRAWABLE "Drawable" 0
		    SF-VALUE    "Frames" "5"
		    SF-VALUE    "Period" "50"
		    SF-VALUE    "Amplitude" "20"
		    SF-OPTION   "Orientation" '("horizontal" "vertical")
		    SF-OPTION   "Edges" '("swear" "wrap" "black")
		    SF-OPTION   "Waveform" '("sawtooth" "sine wave")
		    SF-TOGGLE   "Antialias" TRUE
		    SF-TOGGLE   "Tileable"  TRUE)

;; EOF ;;