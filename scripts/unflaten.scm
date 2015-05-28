;; Convert a flattened animation back into a layered image
;; Copyright (C) 2000 Ingo Ruhnke <grumbel@gmx.de>
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

; Register the function with the GIMP:

(define else #t)

(define (copy-area image drawable x y width height)
  (gimp-rect-select image x y width height REPLACE 0 0)
  (gimp-edit-copy drawable)
  (gimp-selection-none image))

(define (create-layers-from-areas image drawable width height x-offsets)
  (print x-offsets)
  (cond ((not (null? x-offsets))
	 (let ((x-offset (car x-offsets))
	       (new-layer (car (gimp-layer-new image width height RGBA-IMAGE "Frame" 100 NORMAL-MODE))))

	   (gimp-edit-clear new-layer)

	   (copy-area image drawable x-offset 0 width height)
	   (gimp-floating-sel-anchor 
	    (car (gimp-edit-paste new-layer 0)))
	   (gimp-image-add-layer image new-layer 0))
	 (create-layers-from-areas image drawable width height (cdr x-offsets)))))

(define (calc-x-offsets start width frames)
  (cond ((> frames 0)
	 (cons start 
	       (calc-x-offsets (+ start width) width (- frames 1))))
	(else 
	 ())))

(define (script-fu-pingus-unflatten image drawable width height)
  (gimp-image-undo-disable image)
  (let ((frames (/ (car (gimp-image-width image)) width)))
    (create-layers-from-areas image drawable width height 
			      (calc-x-offsets 0 width frames)))
  (gimp-image-resize image width height 0 0)
  (gimp-image-remove-layer image drawable)
  (gimp-displays-flush)
  (gimp-image-undo-enable image))


(define (script-fu-pingus-unflatten-frames image drawable frames)
  (gimp-image-undo-disable image)
  (let ((width  (/ (car (gimp-image-width image)) frames))
	(height (car (gimp-image-height image))))
    (create-layers-from-areas image drawable width height 
			      (calc-x-offsets 0 width frames))
    (gimp-image-resize image width height 0 0)
    (gimp-image-remove-layer image drawable)
    (gimp-displays-flush))
  (gimp-image-undo-enable image))

(script-fu-register
    "script-fu-pingus-unflatten"
    "<Image>/Script-Fu/Pingus/Unflatten W-H"
    "foo"
    "Ingo Ruhnke"
    "1999, Ingo Ruhnke"
    "27th March 1999"
    "RGB*"
    SF-IMAGE "Image" 0
    SF-DRAWABLE "Drawable" 0
    SF-VALUE "Width" "32"
    SF-VALUE "Height" "32")

(script-fu-register
    "script-fu-pingus-unflatten-frames"
    "<Image>/Script-Fu/Pingus/Unflatten frames"
    "foo"
    "Ingo Ruhnke"
    "1999, Ingo Ruhnke"
    "27th March 1999"
    "RGB*"
    SF-IMAGE "Image" 0
    SF-DRAWABLE "Drawable" 0
    SF-VALUE "Frames" "10")
