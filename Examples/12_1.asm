;---------12_1.asm----------------------------------
;Програма за преобразуване на двузначно шестнадесетично число
;(в символен вид) в двоично представяне.
;Вход: шестнадeсетично число от две цифри, въвежда се от клавиатурата.
;Изход: резултатът от преобразуванието в регистър dl.
;------------------------------------------------------
data	segment	para public 'data'
message	db	0ah,0dh,'Въведете две шестнадесетични цифри','$'
data	ends
stk	segment	stack
	db	256 dup ('?')
stk	ends
code	segment	para public 'code'
main	proc	
	assume cs:code,ds:data,ss:stk
	mov	ax,data	
	mov	ds,ax	;ax в ds
	mov	ah,9
	lea	dx,message
	int	21h
	xor	ax,ax	;зануляване на регистър ax
	mov	ah,1h	;1h в регистър ah
	int	21h	;генерация на прекъсване с номер 21h
	mov	dl,al	;съдържимото на регистър al в регистър dl
	sub	dl,30h;изваждане: (dl)=(dl)-30h
	cmp	dl,9h	;да се сравни (dl) с 9h
	jle	M1	;преход към етикет M1, при dl<9h или dl=9h
	sub	dl,7h	;изваждане: (dl)=(dl)-7h
M1:		
	mov	cl,4h	;прехвърляне на 4h в регистър cl
	shl	dl,cl	;изместване съдържимото на dl с 4 разряда вляво
	int	21h	;извикване на прекъсване с номер 21h
	sub	al,30h;изваждане: (dl)=(dl)-30h
	cmp	al,9h	;да се сравни (al) с 9h
	jle	M2	;преход към етикет M2, при al<9h или al=9h
	sub	al,7h	;изваждане: (al)=(al)-7h
M2:			
	add	dl,al	;събиране: (dl)=(dl)+(al)
	mov	ax,4c00h	
	int	21h	
main	endp		;край на процедурата main
code	ends		;край на кодовия сегмент
end	main		;край на програмата с входна точка main

