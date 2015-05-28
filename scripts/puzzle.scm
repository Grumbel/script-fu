(define (seq start stop step)
  (cond ((>= start stop)
	 '())
	(else
	 (cons start
	       (seq (+ start step)
		    stop step)))))

(define (my-edit-paste-to-new-layer drawable)
  (gimp-floating-sel-to-layer (car (gimp-edit-paste drawable 1))))

(define (my-region-to-layer image drawable x y width height)
  (gimp-rect-select image x y width height REPLACE 0 0)
  (gimp-edit-copy drawable)
  (my-edit-paste-to-new-layer drawable)
  (gimp-selection-none image))

(define (my-swap-layer-pos drawable1 drawable2)
  (let ((offsets1 (gimp-drawable-offsets drawable1))
	(offsets2 (gimp-drawable-offsets drawable2)))

    (gimp-layer-set-offsets drawable1 (car offsets2) (cadr offsets2))
    (gimp-layer-set-offsets drawable2 (car offsets1) (cadr offsets1))))

(define (my-script-fu-create-puzzle-helper image drawable width height)
  (gimp-image-undo-disable image)
  (let* ((tile-width  (/ (car (gimp-image-width image)) width))
	 (tile-height (/ (car (gimp-image-height image)) height)))
    ;; Split the image into pieces
    (for-each (lambda (y)
		(for-each (lambda (x)
			    (my-region-to-layer image drawable x y tile-width tile-height))
			  (seq 0 (car (gimp-image-width image))
			       tile-width)))
	      (seq 0 (car (gimp-image-height image))
		   tile-height))
    ;; Mix the pieces
    (let* ((num-layers (- (car (gimp-image-get-layers image)) 1))
	   (layers     (cadr (gimp-image-get-layers image))))
      ;; Repeat the mix up to the number of layers
      (for-each (lambda (x)
		  (my-swap-layer-pos (aref layers (rand num-layers))
				     (aref layers (rand num-layers))))
		(seq 1 (* width height) 1))))
  (gimp-image-undo-enable image)
  (gimp-displays-flush))

(define (my-script-fu-create-puzzle image drawable width height new-image)
  (set! drawable (car (gimp-image-flatten image)))

  (cond ((eq? new-image TRUE)
	 ;; dup image
	 (my-script-fu-create-puzzle-helper image drawable width height))
	(else
	 (my-script-fu-create-puzzle-helper image drawable width height)
	 )))

(script-fu-register "my-script-fu-create-puzzle"
		    "<Image>/Script-Fu/Games/Puzzle"
		    "Do nothing"
		    "Joey User"
		    "Joey User"
		    "August 2000"
		    ""
		    SF-IMAGE _"Image" 0
		    SF-DRAWABLE _"Drawable" 0
		    SF-VALUE _"Width"  "3"
		    SF-VALUE _"Height" "3"
		    SF-TOGGLE _"New Image" TRUE)