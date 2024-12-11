masm
model	small
stack	256
.data		
b	db	1,7	;неопакованото число 71
c	db	4,5	;неопакованото число 54
subs	db	2 dup (0)
.code
main:		
	mov	ax,@data	
	mov	ds,ax	
 	xor	ax,ax	
len	equ	2	;разрядност на числата
	xor	bx,bx
	mov	cx,len	;в cx брояча на цикъла
m1:
	mov	al,b[bx]
	sbb	al,c[bx]
	aas
	mov	subs[bx],al
	inc	bx
	loop	m1
	jc	m2	;анализ на флага за заем
	jmp	exit
m2:	sbb	subs[bx],0
exit:	mov	ax,4c00h	
	int	21h
end	main	

