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
  
(define (find element vector start-index)
  (cond ((< start-index (length vector))
	 (cond ((equal? (aref vector start-index) 
			element)
		start-index)
	       (else
		(find element vector (+ start-index 1)))))
	(else
	 ())))

(define (get-index-of drawable layers)
  (find drawable layers 0))


(define (script-fu-pingus-goto-previous-frame-transparent image drawable)
  (let* ((layers (cadr (gimp-image-get-layers image)))
	 (current-layer-index (get-index-of drawable layers))
	 (previous-layer-index  (+ current-layer-index 1)))
    (cond ((< previous-layer-index (length layers))
	   (script-fu-pingus-hide-all image drawable)
	   (gimp-image-set-active-layer image (aref layers previous-layer-index))
	   (gimp-layer-set-visible (aref layers previous-layer-index) 1)
	   (gimp-layer-set-visible drawable 1)
	   (gimp-layer-set-opacity drawable 60)
	   (let ((current-layer  (aref layers previous-layer-index)))
	     (gimp-drawable-update current-layer 0 0 
				   (car (gimp-drawable-width current-layer))
				   (car (gimp-drawable-height current-layer))))))
    (gimp-displays-flush)))

(define (script-fu-pingus-goto-previous-frame image drawable)
  (let* ((layers (cadr (gimp-image-get-layers image)))
	 (current-layer-index (get-index-of drawable layers))
	 (previous-layer-index  (+ current-layer-index 1)))
    (cond ((< previous-layer-index (length layers))
	   (gimp-image-set-active-layer image (aref layers previous-layer-index))
	   (gimp-layer-set-visible (aref layers previous-layer-index) 1)
	   (gimp-layer-set-visible drawable 0)
	   (let ((current-layer  (aref layers previous-layer-index)))
	     (gimp-drawable-update current-layer 0 0 
				   (car (gimp-drawable-width current-layer))
				   (car (gimp-drawable-height current-layer))))))
    (gimp-displays-flush)))

(define (script-fu-pingus-goto-next-frame image drawable)
  (let* ((layers (cadr (gimp-image-get-layers image)))
	 (current-layer-index (get-index-of drawable layers))
	 (next-layer-index  (- current-layer-index 1)))
    (cond ((>= next-layer-index 0)
	   (gimp-image-set-active-layer image (aref layers next-layer-index))
	   (gimp-layer-set-visible (aref layers next-layer-index) 1)
	   (gimp-layer-set-visible drawable 0)
	   (let ((current-layer  (aref layers next-layer-index)))
	     (gimp-drawable-update current-layer 0 0 
				   (car (gimp-drawable-width current-layer))
				   (car (gimp-drawable-height current-layer))))))
  (gimp-displays-flush)))

(define (script-fu-pingus-goto-next-frame-transparent image drawable)
  (let* ((layers (cadr (gimp-image-get-layers image)))
	 (current-layer-index (get-index-of drawable layers))
	 (next-layer-index  (- current-layer-index 1)))
    (cond ((>= next-layer-index 0)
	   (script-fu-pingus-hide-all image drawable)
	   (gimp-image-set-active-layer image (aref layers next-layer-index))
	   (gimp-layer-set-visible (aref layers next-layer-index) 1)
	   (gimp-layer-set-visible drawable 1)
	   (gimp-layer-set-opacity drawable 60)
	   (let ((current-layer  (aref layers next-layer-index)))
	     (gimp-drawable-update current-layer 0 0 
				   (car (gimp-drawable-width current-layer))
				   (car (gimp-drawable-height current-layer))))))
    (gimp-displays-flush)))

(define (script-fu-pingus-hide-all image drawable)
  (let* ((layers (vector->list (cadr (gimp-image-get-layers image)))))
    (map (lambda (x) (gimp-layer-set-visible x 0)) layers)
    (gimp-drawable-update drawable 0 0 
			  (car (gimp-drawable-width drawable))
			  (car (gimp-drawable-height drawable)))
    (gimp-displays-flush)))

(define (script-fu-pingus-show-all image drawable)
  (let* ((layers (vector->list (cadr (gimp-image-get-layers image)))))
    (map (lambda (x) (gimp-layer-set-visible x 1)
		 	   (gimp-layer-set-opacity x 100)) 
	 layers)
    (gimp-drawable-update drawable 0 0 
			  (car (gimp-drawable-width drawable))
			  (car (gimp-drawable-height drawable)))
    (gimp-displays-flush)))

; Register the function with the GIMP:
(script-fu-register
    "script-fu-pingus-goto-previous-frame"
    "<Image>/Script-Fu/Pingus/Animations/Previous Frame"
    "foo"
    "Ingo Ruhnke"
    "1999, Ingo Ruhnke"
    "Sun Apr  2 16:48:26 2000"
    "RGBA RGB INDEXED*"
    SF-IMAGE "Image" 0
    SF-DRAWABLE "Drawable" 0)

(script-fu-register
    "script-fu-pingus-goto-previous-frame-transparent"
    "<Image>/Script-Fu/Pingus/Animations/Transparent Previous Frame (broken)"
    "foo"
    "Ingo Ruhnke"
    "1999, Ingo Ruhnke"
    "Sun Apr  2 16:48:26 2000"
    "RGBA RGB INDEXED*"
    SF-IMAGE "Image" 0
    SF-DRAWABLE "Drawable" 0)


; Register the function with the GIMP:
(script-fu-register
    "script-fu-pingus-goto-next-frame"
    "<Image>/Script-Fu/Pingus/Animations/Next Frame"
    "foo"
    "Ingo Ruhnke"
    "1999, Ingo Ruhnke"
    "Sun Apr  2 16:48:26 2000"
    "RGBA RGB INDEXED*"
    SF-IMAGE "Image" 0
    SF-DRAWABLE "Drawable" 0)

(script-fu-register
    "script-fu-pingus-goto-next-frame-transparent"
    "<Image>/Script-Fu/Pingus/Animations/Transparent Next Frame (broken)"
    "foo"
    "Ingo Ruhnke"
    "1999, Ingo Ruhnke"
    "Sun Apr  2 16:48:26 2000"
    "RGBA RGB INDEXED*"
    SF-IMAGE "Image" 0
    SF-DRAWABLE "Drawable" 0)

; Register the function with the GIMP:
(script-fu-register
    "script-fu-pingus-hide-all"
    "<Image>/Script-Fu/Pingus/Animations/Hide all"
    "foo"
    "Ingo Ruhnke"
    "1999, Ingo Ruhnke"
    "Sun Apr  2 16:48:26 2000"
    "RGBA RGB INDEXED*"
    SF-IMAGE "Image" 0
    SF-DRAWABLE "Drawable" 0)

; Register the function with the GIMP:
(script-fu-register
    "script-fu-pingus-show-all"
    "<Image>/Script-Fu/Pingus/Animations/Show All"
    "foo"
    "Ingo Ruhnke"
    "1999, Ingo Ruhnke"
    "Sun Apr  2 16:48:26 2000"
    "RGBA RGB INDEXED*"
    SF-IMAGE "Image" 0
    SF-DRAWABLE "Drawable" 0)

