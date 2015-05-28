;; Transform a selection into a layer
;; Copyright (c) 2000 Ingo Ruhnke
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

(define (my-pair->string pair)
  (cons ((pair? (cdr pair))
	 (my-list->string pair))
	(else
	 (print "aoeuo")
	 (string-append "("   (to-string (car pair))
			" . " (to-string (cdr pair)) ")"))))

(define (flatten-string-list str lst)
  (cond ((not (null? lst))
	 (flatten-string-list (string-append str (car lst) " ")
			      (cdr lst)))
	(else
	 str)))

(define (my-list->string pair)
  (let ((string-list (flatten-string-list ""
		      (map (lambda (x) (to-string x)) pair))))
    (string-append "(" string-list ")")))

(define (to-string arg)
  (cond ((number? arg)
	 (number->string arg))
	((string? arg)
	 arg)
	((symbol? arg)
	 " <symbol is unhandeld> ")
	((pair? arg)
	 (my-pair->string arg))
	(else
	 " <unhandeled> ")))

(define (message-box . args)
  (gimp-message (apply string-append (map to-string args))))

(define (script-fu-selection-to-layer image drawable)
  (gimp-image-undo-disable image)
  
  (cond ((eq? (car (gimp-selection-is-empty image)) TRUE)
	 (message-box "The current image doesn't have a selection"))
	(else
	 (gimp-edit-copy drawable)
	 (gimp-floating-sel-to-layer (car (gimp-edit-paste drawable 1)))
	 (gimp-image-set-active-layer image drawable)
	 ))
  
  (gimp-image-undo-enable image)
  (gimp-displays-flush))

; Register the function with the GIMP:
(script-fu-register "script-fu-selection-to-layer"
		    "<Image>/Script-Fu/Grumbel/Selection2Layer"
		    "Transform a selection into a layer"  
		    "Ingo Ruhnke"      ;; Author
		    "GPL" ;; Copyright
		    "Tue Aug 22 12:31:30 2000" ;; Date
		    "RGB* INDEXED*"
		    SF-IMAGE    "Image" 0
		    SF-DRAWABLE "Drawable" 0)

;; EOF ;;