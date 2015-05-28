;; Layer Align Helper - Exactly position a layer
;; Copyright (c) 2000 Ingo Ruhnke
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2 of the License, or
;; (at your option) any later version.
;; 
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;; 
;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

;; Set Layer Position
(define (script-fu-layer-set-position image drawable x-pos y-pos center)
  (gimp-image-undo-disable image)
  (cond (center
	 (gimp-layer-set-offsets 
	  drawable 
	  (- x-pos (/ (car (gimp-drawable-width drawable)) 2))
	  (- y-pos (/ (car (gimp-drawable-height drawable)) 2))))
	(else
	 (gimp-layer-set-offsets drawable 
				 x-pos
				 y-pos)))
  (gimp-image-undo-enable image)
  (gimp-displays-flush))

; Register the function with the GIMP:
(script-fu-register "script-fu-layer-set-position"
		    "<Image>/Script-Fu/Layer Align/Set Position"
		    "Move the layer to the given position"  
		    "Ingo Ruhnke"      ;; Author
		    "2000 Ingo Ruhnke" ;; Copyright
		    "2000 Ingo Ruhnke" ;; Date
		    "RGB* INDEXED*"
		    SF-IMAGE    "Image" 0
		    SF-DRAWABLE "Drawable" 0
		    SF-VALUE    "X-Pos" "0"
		    SF-VALUE    "Y-Pos" "0"
		    SF-TOGGLE   "Center at position?" TRUE)


;; Layer Align Top
(define (script-fu-layer-align-top image drawable)
  (gimp-image-undo-disable image)
  
  (gimp-layer-set-offsets drawable 
			  (car (gimp-drawable-offsets drawable))
			  0)
  (gimp-image-undo-enable image)
  (gimp-displays-flush))

; Register the function with the GIMP:
(script-fu-register "script-fu-layer-align-top"
		    "<Image>/Script-Fu/Layer Align/| Top"
		    "Ingo Ruhnke"
		    "Ingo Ruhnke"
		    "2000 Ingo Ruhnke"
		    "2000 Ingo Ruhnke"
		    "RGB* INDEXED*"
		    SF-IMAGE "Image" 0
		    SF-DRAWABLE "Drawable" 0)



;; Layer Align Bottom
(define (script-fu-layer-align-bottom image drawable)
  (gimp-image-undo-disable image)
  (gimp-layer-set-offsets drawable 
			  (car (gimp-drawable-offsets drawable))
			  (- (car (gimp-image-height image) )
			     (car (gimp-drawable-height drawable))))
  (gimp-image-undo-enable image)
  (gimp-displays-flush))

; Register the function with the GIMP:
(script-fu-register "script-fu-layer-align-bottom"
		    "<Image>/Script-Fu/Layer Align/| Bottom"
		    "Ingo Ruhnke"
		    "Ingo Ruhnke"
		    "2000 Ingo Ruhnke"
		    "2000 Ingo Ruhnke"
		    "RGB* INDEXED*"
		    SF-IMAGE "Image" 0
		    SF-DRAWABLE "Drawable" 0)

;; Layer Align Right
(define (script-fu-layer-align-right image drawable)
  (gimp-image-undo-disable image)
  (gimp-layer-set-offsets drawable 
			  (- (car (gimp-image-width image))
			     (car (gimp-drawable-width drawable)))
			  (cadr (gimp-drawable-offsets drawable)))
  (gimp-image-undo-enable image)
  (gimp-displays-flush))

; Register the function with the GIMP:
(script-fu-register "script-fu-layer-align-right"
		    "<Image>/Script-Fu/Layer Align/- Right"
		    "Ingo Ruhnke"
		    "Ingo Ruhnke"
		    "2000 Ingo Ruhnke"
		    "2000 Ingo Ruhnke"
		    "RGB* INDEXED*"
		    SF-IMAGE "Image" 0
		    SF-DRAWABLE "Drawable" 0)

;; Layer Align Left
(define (script-fu-layer-align-left image drawable)
  (gimp-image-undo-disable image)
  
  (gimp-layer-set-offsets drawable 
			  0
			  (cadr (gimp-drawable-offsets drawable)))
  (gimp-image-undo-enable image)
  (gimp-displays-flush))

; Register the function with the GIMP:
(script-fu-register "script-fu-layer-align-left"
		    "<Image>/Script-Fu/Layer Align/- Left"
		    "Ingo Ruhnke"
		    "Ingo Ruhnke"
		    "2000 Ingo Ruhnke"
		    "2000 Ingo Ruhnke"
		    "RGB* INDEXED*"
		    SF-IMAGE "Image" 0
		    SF-DRAWABLE "Drawable" 0)

;; Layer Align Center
(define (script-fu-layer-align-center image drawable)
  (gimp-image-undo-disable image)
  (let* ((center-x (/ (car (gimp-image-width  image)) 2))
	 (center-y (/ (car (gimp-image-height image)) 2)))

    (gimp-layer-set-offsets 
     drawable 
     (- center-x (/ (car (gimp-drawable-width  drawable)) 2))
     (- center-y (/ (car (gimp-drawable-height drawable)) 2))))
  (gimp-image-undo-enable image)
  (gimp-displays-flush))

; Register the function with the GIMP:
(script-fu-register "script-fu-layer-align-center"
		    "<Image>/Script-Fu/Layer Align/x Center"
		    "Ingo Ruhnke"
		    "Ingo Ruhnke"
		    "2000 Ingo Ruhnke"
		    "2000 Ingo Ruhnke"
		    "RGB* INDEXED*"
		    SF-IMAGE "Image" 0
		    SF-DRAWABLE "Drawable" 0)


;; EOF ;;