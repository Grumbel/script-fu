;; Load a sequenze of images
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
(define have-eof #f)

(define (vector->list vector)
  (define (vector->list-helper vector index)
    (cond ((< index (length vector))
	   (cons (aref vector index)
		 (vector->list-helper vector (+ index 1))))
	  (else
	   ())))
  (vector->list-helper vector 0))

(define (my-getline filehandle)
  (let ((character (fread 1 filehandle)))
    (cond ((equal? character "\n")
	   "")
	  ((equal? character ())
	   (set! have-eof #t)
	   "")
	  (else
	   (string-append character (my-getline filehandle))))))

(define (my-readfile filehandle)
  (cond ((not have-eof)
	 (let ((line (my-getline filehandle)))
	   (cond ((> (string-length line) 0)
		  (cons line
			(my-readfile filehandle)))
		 (else
		  (my-readfile filehandle)))))
	(else
	 ())))

(define (load-images images)
  (map (lambda (filename) (car (gimp-file-load 0 filename filename)))
       images))

(define (copy-drawables-to new-image drawables)
  (cond ((not (null? drawables))
	 (let* ((drawable (car drawables))
		(width (car (gimp-drawable-width drawable)))
		(height (car (gimp-drawable-height drawable))))
	   (gimp-edit-copy drawable)
	   (let ((new-layer (car (gimp-layer-new new-image width height RGB 
						 (car (gimp-image-get-filename 
						       (car (gimp-drawable-image drawable))))
						 100 0))))
	     (gimp-layer-add-alpha new-layer)
	     (gimp-floating-sel-anchor (car (gimp-edit-paste new-layer 0)))
	     (gimp-image-add-layer new-image new-layer 0))))))
	
(define (copy-image-to new-image other-image)
  (copy-drawables-to new-image
		     (vector->list (cadr (gimp-image-get-layers other-image)))))

(define (copy-all-images-to new-image images)
  (cond ((not (null? images))
	 (copy-image-to new-image (car images))
	 (copy-all-images-to new-image (cdr images)))))

(define (script-fu-load-sequenze filename)
  (let* ((filehandle (fopen filename))
	 (filecontent (reverse (my-readfile filehandle)))
	 (images (load-images filecontent))
	 (width  (apply max (map (lambda (x) (car (gimp-image-width x)))
				 images)))
	 (height (apply max (map (lambda (x) (car (gimp-image-height x)))
				 images))))
    (print width)
    (print height)
    (let ((new-image (car (gimp-image-new width height RGB))))
      (copy-all-images-to new-image images)
      (gimp-display-new new-image))))

(script-fu-register "script-fu-load-sequenze"
		    "<Toolbox>/Xtns/Script-Fu/Misc/Load sequenze."
		    "Load a sequenze of images"
		    "Ingo Ruhnke"
		    "1999, Ingo Ruhnke"
		    "Fri Mar  3 16:00:13 2000"
		    "RGB RGBA"
		    SF-FILENAME "Directory:" "")
