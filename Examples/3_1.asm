data	segment	para public 'data'
message	db	'Hello World! $'
data	ends

stk	segment	stack
	db	256 dup ('?')	;сегмент на стека
stk	ends

code	segment	para public 'code';начало на кодовия сегмент
		
	assume cs:code,ds:data,ss:stk
main:	mov	ax,data	;адреса на сегмента данни в регистър ax
	mov	ds,ax		;ax в ds
	mov	ah,9
	mov	dx,offset message
	int	21h	;извеждане съобщението на екрана
	
mov	ax,4c00h	; 4c00h в ax
	int	21h	;стандартен изход от програмата

code	ends		;край на кодовия сегмент

end	main		;край на програмата с входна точка main


