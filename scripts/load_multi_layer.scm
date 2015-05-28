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

(define (script-load-multible-images inImage inDraw)
  (let* ((file-name "/home/ingo/projects/pingus/unsorted/traps/hammer/hammer0024.tga")
	 (image (car (gimp-file-load 1 file-name file-name)))
	 (layer 0))

    (gimp-display-new image)
;;    (gimp-image-delete image)
    (gimp-edit-copy image (car ( gimp-image-active-drawable image)))
    (gimp-edit-paste inImage (car (gimp-image-active-drawable inImage)) 0)
    (gimp-displays-flush)))
  
; Register the function with the GIMP:
(script-fu-register
    "script-fu-load-multible-images"
    "<Image>/Script-Fu/Pingus/Load Multible"
    "foo"
    "Ingo Ruhnke"
    "1999, Ingo Ruhnke"
    "28th October 1999"
    "RGBA RGB INDEXED*"
    SF-IMAGE "Image" 0
    SF-DRAWABLE "Drawable" 0)
