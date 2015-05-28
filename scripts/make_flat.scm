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

(define (script-fu-make-pingus-pcx inImage inDraw)
  (let* ((layers (gimp-image-get-layers inImage))
	 (num-layers (car layers))
	 (num-visi-layers 0)
	 (layer-array (cadr layers))
	 (width  153)
	 (height 168)
	 )

    (set! height (car (gimp-image-height inImage)))
    (set! width  (car (gimp-image-width  inImage)))

    (set! layer-count 1)
    (gimp-image-resize inImage (* width num-layers) height 0 0)

;    (gimp-convert-rgb inImage)

    (gimp-palette-set-background '(255 0 255))

    (while (<= layer-count num-layers)
	   (set! layer (aref layer-array (- num-layers layer-count)))
	   (gimp-layer-translate layer (* (- layer-count 1) width) 0)
	   (set! layer-count (+ layer-count 1)))

    (gimp-image-flatten inImage)
;    (gimp-convert-indexed inImage FALSE 255)
    (gimp-displays-flush)))
  
; Register the function with the GIMP:
(script-fu-register
    "script-fu-make-pingus-pcx"
    "<Image>/Script-Fu/Pingus/Flat Anim"
    "foo"
    "Ingo Ruhnke"
    "1999, Ingo Ruhnke"
    "27th March 1999"
    "RGBA RGB INDEXED*"
    SF-IMAGE "Image" 0
    SF-DRAWABLE "Drawable" 0)

