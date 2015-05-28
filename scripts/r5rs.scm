;; R5rs implementation for SIOD
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
(define (1+ n) (+ n 1))
(define (1- n) (- n 1))

(define (string-ref str i)
  (substring str i (+ i 1)))

(define (string->list str)
  (cond ((> (string-length str) 0)
	 (cons (string-ref str 0)
	       (string->list (substring str 1 (string-length str)))))
	(else
	 ())))

(define (list->string lst)
  (apply string-append lst))

(define display print)
(define (newline) (print "\n"))

(define (pathname filename)
  (let ((liste (reverse (string->list filename))))
    (list->string (reverse (pathname-helper liste)))))

(define (pathname-helper filename)
;;  (display filename)
  (cond ((not (null? filename))
	 (cond ((equal? (car filename) "/")
		filename)
	       (else
		(pathname-helper (cdr filename)))))
	(else
	 ())))

;; EOF ;;