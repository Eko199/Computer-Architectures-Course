masm		;режим на работа за TASM: masm, за MASM няма нужда
model	small	;модел на паметта
.data		;сегмент за данни
message	db	'Hello World!. $'
.stack	256	;сегмент на стека
.code	;сегмент за кода
main:			;начало с входна точка main
	mov	ax,@data	;зареждаме адреса на сегмента с данни в регистър ax
	mov	ds,ax	;ax в ds
	mov	ah,9
	mov	dx,offset message
	int	21h	;извеждаме съобщението на екрана
	mov	ax,4c00h	;зареждаме 4c00h в регистър ax
	int	21h	;извикване прекъсване с номер 21h
end	main		;край на програмата с входна точка main

