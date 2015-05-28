
(define (script-fu-grumbel-black2trans image drawable)
  (gimp-image-undo-disable image)
  (gimp-layer-add-alpha drawable)
  (let* ((layer-mask (car (gimp-layer-create-mask drawable WHITE-MASK))))
    (gimp-image-add-layer-mask image drawable layer-mask)
    (gimp-edit-copy  drawable)
    (gimp-floating-sel-anchor (car (gimp-edit-paste layer-mask 1)))
;;    (gimp-invert layer-mask)
;;    (gimp-image-remove-layer-mask image drawable APPLY)
    )
  (gimp-image-undo-enable image)
  (gimp-displays-flush))

(script-fu-register "script-fu-grumbel-black2trans"
		    "<Image>/Script-Fu/Grumbel/black2trans"
		    "Make all black areas transparent"
		    "Ingo Ruhnke"
		    "2000, Ingo Ruhnke"
		    "2000"
		    "RGB RGBA"
		    SF-IMAGE "Image" 0
		    SF-DRAWABLE "Drawable" 0)
;; EOF ;;
