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

(define (script-fu-grumbel-wonderful inImage inDrawable blurfactor flatten brightness contrast)
  (gimp-image-undo-disable inImage)
  (let ((new-layer (car (gimp-layer-copy inDrawable 1))))
    (gimp-image-add-layer inImage  new-layer 0)
    (plug-in-gauss-iir 1 inImage new-layer blurfactor 1 1)
;; Replace this with some level stuff
;;    (gimp-brightness-contrast new-layer brightness contrast)

    (let ((layer-mask (car (gimp-layer-create-mask inDrawable WHITE-MASK))))
      (gimp-image-add-layer-mask inImage new-layer layer-mask)
      (gimp-edit-copy new-layer)
      (gimp-floating-sel-anchor (car (gimp-edit-paste layer-mask 0)))
      (gimp-layer-set-mode new-layer  ADDITION)))

  (if (= flatten TRUE)
      (gimp-image-flatten inImage))

  (gimp-displays-flush)
  (gimp-image-undo-enable inImage))

(script-fu-register "script-fu-grumbel-wonderful"
		    "<Image>/Script-Fu/Grumbel/Make wonderful"
		    "Creates a new tuxracer level"
		    "Ingo Ruhnke"
		    "1999, Ingo Ruhnke"
		    "2000"
		    "RGB RGBA"
		    SF-IMAGE "Image" 0
		    SF-DRAWABLE "Drawable" 0
		    SF-VALUE "Blur:" "35"
		    SF-VALUE "Brightness" "20"
		    SF-VALUE "Contrast" "100"
		    SF-TOGGLE "Flatten image" FALSE)

;; EOF ;;