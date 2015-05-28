; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 2 of the License, or
; (at your option) any later version.
; 
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
; 
; You should have received a copy of the GNU General Public License
; along with this program; if not, write to the Free Software
; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

(define (lower-layer-x-times image layer steps)
  (print "lower layer")
  (print steps)
  (cond ((> steps 1)
	 (gimp-image-lower-layer image layer)
	 (lower-layer-x-times image layer (- steps 1)))))

(define (script-fu-pingus-reverse-layers inImage inDraw)
  (let ((num-layers (car (gimp-image-get-layers inImage)))
	(layers (cadr (gimp-image-get-layers inImage)))
	(layer-count 0))
    
    (while (< layer-count num-layers)
	   (print "Do ing layer")
	   (lower-layer-x-times inImage (aref layers layer-count)
				(- num-layers layer-count))
	   (set! layer-count (+ layer-count 1)))
    (gimp-displays-flush)))
  
; Register the function with the GIMP:
(script-fu-register "script-fu-pingus-reverse-layers"
		    "<Image>/Script-Fu/Pingus/Reverse Layers"
		    "foo"
		    "Ingo Ruhnke"
		    "2000, Ingo Ruhnke"
		    "Mon Mar  6 22:08:22 2000"
		    "RGBA RGB INDEXED*"
		    SF-IMAGE "Image" 0
		    SF-DRAWABLE "Drawable" 0)
		    

