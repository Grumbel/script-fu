
(define (script-fu-grumbel-bw2trans image drawable)
  (gimp-undo-push-group-start image)
;;(gimp-image-undo-disable image)
  (gimp-layer-add-alpha drawable)
  (let* ((layer-mask (car (gimp-layer-create-mask drawable WHITE-MASK))))
    (gimp-image-add-layer-mask image drawable layer-mask)
    (gimp-edit-copy  drawable)
    (gimp-floating-sel-anchor (car (gimp-edit-paste layer-mask 1)))
    (gimp-invert layer-mask)
    (gimp-palette-set-foreground '(0 0 0))
    (gimp-edit-fill drawable FG-IMAGE-FILL)
    (gimp-image-remove-layer-mask image drawable APPLY)
    )

  (let ((layer (car
		(gimp-layer-new image 
				(car (gimp-image-width image))
				(car (gimp-image-height image))
				RGB-IMAGE
				"White"
				100
				NORMAL))))
    (gimp-layer-add-alpha layer)
    (gimp-palette-set-foreground '(255 255 255))
    (gimp-edit-fill layer FG-IMAGE-FILL)
    (gimp-image-add-layer image layer 1))


  (gimp-undo-push-group-end image)
;; (gimp-image-undo-enable image)
  (gimp-displays-flush))

(script-fu-register "script-fu-grumbel-bw2trans"
		    "<Image>/Script-Fu/Grumbel/BW2Trans"
		    "Seperate a black/white sketch into a black/transparent layer and a white layer which can be used for colorrization"
		    "Ingo Ruhnke"
		    "2000, Ingo Ruhnke"
		    "2000"
		    "RGB RGBA"
		    SF-IMAGE "Image" 0
		    SF-DRAWABLE "Drawable" 0)
;; EOF ;;
