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

(define (looper image drawable x-pos y-pos)
  (gimp-rect-select image x-pos y-pos 6 13 REPLACE 0 0)
  (gimp-edit-copy drawable)
  (gimp-selection-none image)
  
  (let ((new-layer 
	 (car (gimp-layer-new image 6 13
			      RGBA-IMAGE "Frame" 100 NORMAL-MODE))))
    (gimp-image-add-layer image new-layer 0)
    (gimp-floating-sel-anchor 
     (car (gimp-edit-paste new-layer 0)))
    (gimp-layer-set-offsets new-layer (* (/ x-pos 6) 7) 0))

  (cond ((< (+ x-pos 6) (car (gimp-image-width image)))
	 (looper image drawable (+ x-pos 6) y-pos))))

(define (script-fu-pingus-font-enlarger image drawable)
  (gimp-image-undo-disable image)
  (let ((width  (car (gimp-image-width image)))
	(height (car (gimp-image-width image)) frames))
    (looper image drawable 0 0))
  (gimp-image-undo-enable image))

(script-fu-register
    "script-fu-pingus-font-enlarger"
    "<Image>/Script-Fu/Pingus/Font enlarger"
    "foo"
    "Ingo Ruhnke"
    "1999, Ingo Ruhnke"
    "27th March 1999"
    "RGBA"
    SF-IMAGE "Image" 0
    SF-DRAWABLE "Drawable" 0)
;; EOF
