(define (my-image-to-layer-size image layer)
  (gimp-layer-set-offsets layer 0 0)
  (gimp-image-resize image 
		     (car (gimp-drawable-width layer))
		     (car (gimp-drawable-height layer))
		     0 0))

(define (script-fu-pingus-center-image image drawable x-pos y-pos)
  (let ((left-border  x-pos)
	(right-border (- (car (gimp-drawable-width drawable)) x-pos))
	(top-border y-pos)
	(bottom-border (- (car (gimp-drawable-height drawable)) y-pos))
	)
    (gimp-layer-resize drawable 
		       (* 2 (max left-border right-border))
		       (* 2 (max top-border  bottom-border))
		       (- (max left-border right-border) x-pos)
		       (- (max top-border  bottom-border) y-pos))
    (my-image-to-layer-size image drawable)))

; Register the function with the GIMP:
(script-fu-register
 "script-fu-pingus-center-image"
    "<Image>/Script-Fu/Pingus/Center Image"
    "x-pos, y-pos are the position of a point which you want to have
centered relative to the image borders.  The script-fu enlarges the
image and moves the layer so that the given point is centered."
    "Ingo Ruhnke"
    "1999, Ingo Ruhnke"
    "29th Dec 1999"
    "RGBA RGB INDEXED*"
    SF-IMAGE "Image" 0
    SF-DRAWABLE "Drawable" 0
    SF-VALUE "X-Pos" "0"
    SF-VALUE "Y-Pos" "0")

;; EOF ;;

