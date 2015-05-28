(define (my-dummy a b)
  (print "Do nothing"))

(script-fu-register "my-dummy"
		    _"<Toolbox>/Xtns/Script-Fu/My Stuff/Dummy..."
		    "Do nothing"
		    "Joey User"
		    "Joey User"
		    "August 2000"
		    ""
		    SF-ADJUSTMENT _"Width" '(400 1 2000 1 10 0 1)
		    SF-ADJUSTMENT _"Height" '(30 1 2000 1 10 0 1))