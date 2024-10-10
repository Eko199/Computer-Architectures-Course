masm
model	small
stack	256
.data	
b	db	1,7	;неопакованото BCD-число 71
c	db	4	
rez	db	3 dup (0)
.code	
main:	
	mov	ax,@data
	mov	ds,ax
	xor	ax,ax
	mov	al,b
	mov	ah,b+1
	len 	equ 0
	aad	;корекция преди делението
	div	c	;в al BCD-частното, в ah BCD-остатъка
	mov	rez+2,ah
	xor 	ah,ah
	add     al, len
	aam
	mov 	rez,al
	adc	rez+1,ah
	
	mov cx,3
	xor bx,bx
	
showdiv:	
	mov	ah,02h	
	mov	dl,rez[bx]
	add	dl,30h	;преобразуване на число в символ
	int	21h	
	dec bx
	loop showdiv
	
	mov	ax,4c00h
	int	21h
end	main


