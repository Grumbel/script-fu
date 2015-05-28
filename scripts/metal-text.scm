
(define (my-image-to-layer-size image layer)
  (gimp-layer-set-offsets layer 0 0)
  (gimp-image-resize image 
		     (car (gimp-drawable-width layer))
		     (car (gimp-drawable-height layer))
		     0 0))

(define (my-layer-add-border layer border)
	(let* ((width  (car (gimp-drawable-width  layer)))
	       (height (car (gimp-drawable-height layer))))
	       (gimp-layer-resize layer
				  (+ width border) (+ height border)
				  (/ border 2) (/ border 2))))

(define (my-duplicate-layer image layer)
	(let* ((dup-layer (car (gimp-layer-copy layer 1))))
              (gimp-image-add-layer image dup-layer 0)
	      dup-layer))

(define (my-make-metal-font text font font-size)
 (let* ((image (car (gimp-image-new 256 256 RGB)))
	(bottom-font-layer (car (gimp-text-fontname image -1 0 0 text 0 TRUE font-size PIXELS
					     font))))

   (let* ((top-font-layer (my-duplicate-layer image bottom-font-layer)))
     
     (my-layer-add-border bottom-font-layer 20)

     (gimp-layer-set-preserve-trans bottom-font-layer 0)
     (gimp-gradients-set-active "Four_bars")

     (gimp-selection-layer-alpha bottom-font-layer)
     (gimp-selection-grow image 3)
     (gimp-blend bottom-font-layer CUSTOM NORMAL LINEAR 100 0 REPEAT-NONE FALSE 0 0 0 0 200 50)


     (gimp-selection-layer-alpha top-font-layer)
     (gimp-blend top-font-layer    CUSTOM NORMAL LINEAR 100 0 REPEAT-NONE FALSE 0 0 0 50 200 0)
     (gimp-selection-clear image)
     
     (let* ((new-layer (car (gimp-image-merge-visible-layers 
			     image EXPAND-AS-NECESSARY))))
       (my-image-to-layer-size image new-layer))

     (gimp-display-new image))
   ))

(script-fu-register "my-make-metal-font"
		    "<Toolbox>/Xtns/Script-Fu/Logos/Metal Font..."
		    "Create an example image of a custom gradient"
		    "Federico Mena Quintero"
		    "Federico Mena Quintero"
		    "June 1997"
		    ""
		    SF-STRING     "Text" "The GIMP"
		    SF-FONT       "Font" "-*-blippo-*-r-*-*-24-*-*-*-p-*-*-*"
		    SF-VALUE      "Font Size" "50" )
;; EOF ;;


