(define (cout . list)
  (print (cout-helper list)))

(define (cout-helper list)
  (cond ((null? list) "")
	(else
	 (let ((element (car list)))
	   (cond ((number? element)
		  (number->string element))
		 ((string? (element))
		  element)
		 (
	 (string-append 
	 )))