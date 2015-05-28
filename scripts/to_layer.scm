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

(define (script-fu-make-to-layer inImage inDraw)
  
  (let* ((image))
    (set! image
	  (file-pcx-load "0" (string-append "/tmp/hammer0000.pcx") "Bla"))

    (gimp-edit-copy image 0)
    (gimp-edit-paste inImage 0 0)

    (gimp-displays-flush)
    ))
  
; Register the function with the GIMP:
(script-fu-register
    "script-fu-make-to-layer"
    "<Image>/Script-Fu/Pingus/To Layer"
    "foo"
    "Ingo Ruhnke"
    "1999, Ingo Ruhnke"
    "27th March 1999"
    "RGBA RGB INDEXED*"
    SF-IMAGE "Image" 0
    SF-DRAWABLE "Drawable" 0)
