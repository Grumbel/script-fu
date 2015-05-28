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

(define else #t)
(define pi 3.1415927)

(define (my-duplicate-layer image layer)
	(let* ((dup-layer (car (gimp-layer-copy layer 1))))
              (gimp-image-add-layer image dup-layer 0)
	      dup-layer))

(define (repeat func times)
  (cond ((> times 0)
	 (cons (func)
	       (repeat func (- times 1))))
	(else '())))

(define (script-fu-firepower-rotate-image image drawable frames)
  (let ((angle 0)
	(step (/ (/ pi 2) frames))
	(layers (repeat (lambda () (my-duplicate-layer image drawable))
			(- frames 1))))
    (for-each (lambda (x)
		(set! angle (+ angle step))
		(gimp-rotate x TRUE angle))
	      layers)
;;    (plug-in-rotate 2 image drawable 1 FALSE)
    (gimp-displays-flush)))

(script-fu-register
    "script-fu-firepower-rotate-image"
    "<Image>/Script-Fu/Pingus/Macro Rotate"
    "foo"
    "Ingo Ruhnke"
    "2000, Ingo Ruhnke"
    "Sun Feb 11 12:38:29 2001"
    "RGB*"
    SF-IMAGE "Image" 0
    SF-DRAWABLE "Drawable" 0
    SF-VALUE "Frames" "4")
