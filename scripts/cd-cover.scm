(define (make-front-cover2 resolution)
  (let* ((image (car (gimp-image-new (* 2 resolution) resolution RGB)))
	 (layer (car (gimp-layer-new image (* 2 resolution) resolution RGB "Front Cover" 100 0))))

    (gimp-image-add-vguide image resolution)

    (gimp-palette-set-background '(255 255 255))
    (gimp-drawable-fill layer BG-IMAGE-FILL)

    (gimp-image-add-layer image layer 0)
    (gimp-display-new image)))

(define (make-front-cover resolution)
  (let* ((image (car (gimp-image-new resolution resolution RGB)))
	 (layer (car (gimp-layer-new image resolution resolution RGB "Front Cover" 100 0))))

    (gimp-palette-set-background '(255 255 255))
    (gimp-drawable-fill layer BG-IMAGE-FILL)

    (gimp-image-add-layer image layer 0)
    (gimp-display-new image)))

(define (make-back-cover resolution)
  (let* ((width  (back-cover-width resolution))
	 (height (back-cover-height resolution))
	 (image (car (gimp-image-new width height RGB)))
	 (layer (car (gimp-layer-new image width height RGB "Front Cover" 100 0))))

    (let ((pos (* (/ 0.6 12) resolution)))
      (gimp-image-add-vguide image pos)
      (gimp-image-add-vguide image (- width pos)))

    (gimp-palette-set-background '(255 255 255))
    (gimp-drawable-fill layer BG-IMAGE-FILL)

    (gimp-image-add-layer image layer 0)
    (gimp-display-new image)))

(define (back-cover-width resolution)
  (* resolution (/ 15 12)))

(define (back-cover-height resolution)
  (* resolution (/ 11.9 12)))

(define (script-fu-create-cd-cover resolution double-page)
  (if (equal? double-page TRUE)
      (make-front-cover2 resolution)
      (make-front-cover  resolution))
  (make-back-cover  resolution)
  (gimp-displays-flush))

(script-fu-register "script-fu-create-cd-cover"
		    "<Toolbox>/Xtns/Script-Fu/Utils/CD-Cover"
		    "Creates a Template Image which can be used for CD-Covers"
		    "Ingo Ruhnke"
		    "2000, Ingo Ruhnke"
		    "2000"
		    "RGB RGBA"
		    SF-VALUE "Cover Resolution (height) :" "800"
		    SF-TOGGLE "Dopple page booklet" FALSE)

;; EOF ;;