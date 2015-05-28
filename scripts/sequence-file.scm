;; sequence-file.scm -*-scheme-*-
;; Load Sequence (script-fu-sequence-load) - Load numbered sequence of images 
;;   from disk and  possibly combine them into one image
;;
;; Save Sequence (script-fu-sequence-save) - Save all layers to numbered 
;;   sequence of images on disk
;;
;; This is a version compatible with GIMP v1.1
;;
;; Copyright (C) 1999 by Jaroslav Benkovsky <pvt.benkovsk@pha.pvtnet.cz>
;; Released under General Public License (GPL)
;; 
;; $Id: sequence-file.scm,v 1.6 1999/03/21 03:59:33 benkovsk Exp $
;;
;; Requires:
;;   script-fu
;;
;; Notes:
;;   - loaded images should have one layer only, the rest is ignored
;;   - if any source image or layer doesn't exist, script aborts. Should be 
;;     changed?
;;
;; TODO:
;;   sequence-split --  split loaded image into one image for each layer
;;   sequence-merge -- merge loaded images into one image
;;   iterate -- apply user defined SIOD to each Image/Layer matching regexp
;;   specify image format

;; Example:
;;   (script-fu-sequence-load "worx/atomix/pov/m_intro%%.tga" "Layer % (replace)" 1 10 TRUE)
;;

;; split template into list

(define (string-template-split str first_number)
    (let* (
	   (tplchar "%")
	   (digits "0123456789")

	   (len (string-length str))
	   (f1 (strcspn str tplchar))
	   )

      (if (= f1 len)
	  (begin
	      (set! f1 (strcspn str digits))
	      (if (= f1 len) 
		  (error "Can't insert number to template" str)
		  (set! fs digits)))
	  (set! fs tplchar))

      (set! hdr (substring str 0 f1))
      (set! str (substring str f1 len))
      (set! len (- len f1))

      (set! f2 (strspn str fs))
      (set! body (substring str 0 f2))
      (set! ftr (substring str f2 len))

      (set! fill (string-length body))
      (if (eq? fs tplchar)
	  (set! body 0)
	  (set! body (- (string->number body 10) first_number)))

      (set! return (list hdr body ftr fill))
))

;; build string from template & param

(define (string-template-expand seq tpl)
    (begin
      (set! body (number->string (+ seq (cadr tpl)) 
			    10
			    (car (last tpl))))
      (set! str (string-append (car tpl) 
			       body 
			       (caddr tpl)))
))

;; Load Sequence

(define (script-fu-sequence-load filetpl layertpl 
				 first_frame last_frame 
				 make_one_image?)
    (let* (
	   (f_tpl (string-template-split filetpl first_frame))
	   (l_tpl (if (= make_one_image? TRUE)
			  (string-template-split layertpl first_frame)))
	   )

      (set! seq first_frame)
      (while (<= seq last_frame)
	     (set! f_name (string-template-expand seq f_tpl))

	     (set! src_img (car (gimp-file-load 1 f_name filetpl)))

	     (if (= make_one_image? TRUE)
		 (begin
		     (set! l_name (string-template-expand seq l_tpl))
		     (set! layers (gimp-image-get-layers src_img))
;		     (set! layer_cnt (car layers))
		     (set! src_layer (aref (cadr layers) 0))
		     (set! type (car (gimp-drawable-type src_layer)))

;;(eval (read-from-string "(file-jpg-load ...)"))

		     (if (= seq first_frame)
			 (begin
			     (set! main_img src_img)
			     (set! width (car (gimp-drawable-width src_layer)))
			     (set! height (car (gimp-drawable-height src_layer)))
			     (gimp-image-disable-undo main_img))
			 (begin
			     (gimp-edit-copy src_layer)
			     (set! tgt_layer (car (gimp-layer-new main_img width height type l_name 100 NORMAL)))
			     (gimp-image-add-layer main_img tgt_layer -1)
			     (gimp-edit-clear tgt_layer)
;			     (set! tgt_layer (car (gimp-edit-paste tgt_layer 0)))
;			     (gimp-floating-sel-anchor tgt_layer)

			     (let ((floating-sel (car (gimp-edit-paste tgt_layer FALSE))))
			       (gimp-floating-sel-anchor floating-sel))


			     (gimp-image-delete src_img))))
		 (begin
		     (gimp-image-clean-all src_img)
		     (gimp-display-new src_img)))
	     
	     (set! seq (+ seq 1))
	   )

      ; cleanup
      (if (= make_one_image? TRUE)
	  (begin 
	      (gimp-image-clean-all main_img)
	      (gimp-image-enable-undo main_img)
	      (gimp-display-new main_img)))
))

;; Save Sequence

(define (script-fu-sequence-save src_img drawable filetpl
				 first_frame last_frame 
				 preserve_size? preserve_bg?)

    (let* ((f_tpl (string-template-split filetpl first_frame))
	   (type (car (gimp-drawable-type drawable)))
	   (img_width (car (gimp-image-width src_img)))
	   (img_height (car (gimp-image-height src_img)))
	   (img_type (cond ((= type RGB_IMAGE) RGB)
			   ((= type RGBA_IMAGE) RGB)
			   ((= type GRAY_IMAGE) GRAY)
			   ((= type GRAYA_IMAGE) GRAY)
			   ((= type INDEXED_IMAGE) INDEXED)
			   ((= type INDEXEDA_IMAGE) INDEXED))))


      (set! layers (gimp-image-get-layers src_img))
      (set! layer_cnt (car layers))

      (if (or (> last_frame layer_cnt) (= last_frame 0))
	  (set! last_frame layer_cnt))

      ; FIXME: more checks for first_frame; but tpl's are already set!

      (set! seq first_frame)
      (while (<= seq last_frame)
	     (set! src_layer (aref (cadr layers) (- layer_cnt seq)))

	     (set! f_name (string-template-expand seq f_tpl))

	     (set! width (car (gimp-drawable-width src_layer)))
	     (set! height (car (gimp-drawable-height src_layer)))
	     (set! type (car (gimp-drawable-type src_layer)))


	     (gimp-edit-copy src_layer)

	     (set! tgt_img (car (gimp-image-new width height img_type)))
	     (set! tgt_layer (car (gimp-layer-new tgt_img width height type "layer" 100 NORMAL)))
	     (gimp-image-add-layer tgt_img tgt_layer 0)

	     (if (= preserve_bg? TRUE)
		 (begin
		   (gimp-edit-clear tgt_layer))
		 (begin
		   (gimp-drawable-fill tgt_layer BG-IMAGE-FILL)))

	     (let ((floating-sel (car (gimp-edit-paste tgt_layer FALSE))))
	       (gimp-floating-sel-anchor floating-sel))

	     (if (= preserve_size? TRUE)
		 (begin
		   (set! offset (gimp-drawable-offsets src_layer))
		   (gimp-image-resize tgt_img img_width img_height (car offset) (cadr offset))))

             (gimp-file-save 1 tgt_img tgt_layer f_name f_name)
	     (gimp-image-clean-all tgt_img)
	     (gimp-image-delete tgt_img)
	     (set! seq (+ seq 1))
	     )

))


(script-fu-register "script-fu-sequence-load"
		    "<Toolbox>/Xtns/Script-Fu/Utils/Load Sequence"
		    "Load numbered sequence of images from disk, possibly combining them into single image."
		    "Jaroslav Benkovsky <pvt.benkovsk@pha.pvtnet.cz>"
		    "Jaroslav Benkovsky"
		    "February 1999"
		    ""

		    SF-FILENAME   "File Name Template"  "pict%%.tga"
		    SF-STRING     "Layer Name Template" "Layer % (replace)"
		    SF-ADJUSTMENT "First Frame"         '(1 0 100000 1 10 0 1)
		    SF-ADJUSTMENT "Last Frame"          '(10 0 100000 1 10 0 1)
		    SF-TOGGLE     "Make One Image"      TRUE
)

(script-fu-register "script-fu-sequence-save"
		    "<Image>/File/Save Sequence"
		    "Save all layers to numbered sequence of images on disk."
		    "Jaroslav Benkovsky <pvt.benkovsk@pha.pvtnet.cz>"
		    "Jaroslav Benkovsky"
		    "February 1999"
		    ""

		    SF-IMAGE      "Image"               0
		    SF-DRAWABLE   "Drawable"            0
		    SF-FILENAME   "File Name Template"  "pict%%.tga"
		    SF-ADJUSTMENT "First Frame"         '(1 1 100000 1 10 0 1)
		    SF-ADJUSTMENT "Last Frame (0: all)" '(0 0 100000 1 10 0 1)
		    SF-TOGGLE     "Preserve size (unimplemented)"  FALSE
		    SF-TOGGLE     "Preserve background" TRUE
)

;; End of file sequence-file.scm


