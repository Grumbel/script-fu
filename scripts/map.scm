;; Maps a scheme function to all layers
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

(define (my-map-to-all-layers func image)
  (let ((layers (vector->list (cadr (gimp-image-get-layers image)))))
    (map func
	 layers)))

(define (script-fu-transform-offset image drawable x-offset y-offset wrap)
  (my-map-to-all-layers 
   (lambda (layer)
     (gimp-channel-ops-offset layer wrap OFFSET-TRANSPARENT 
			      x-offset y-offset))
   image)
  (gimp-displays-flush))

(script-fu-register "script-fu-transform-offset"
		    "<Image>/Script-Fu/Grumbel/Offset All"
		    ""
		    "Ingo Ruhnke"
		    "2000, Ingo Ruhnke"
		    "2000"
		    "RGB RGBA INDEXED* "
		    SF-IMAGE "Image" 0
		    SF-DRAWABLE "Drawable" 0
		    SF-VALUE    "X-Offset:" "0"
		    SF-VALUE    "Y-Offset" "0"
		    SF-TOGGLE   "Wrap around" TRUE)

;; EOF ;;
