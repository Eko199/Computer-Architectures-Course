masm
model	small
stack	256
.data
b	db	6,7	;неопакованото число 76
c	db	4	;неопакованото число 4
proizv	db	4 dup (0)
.code
main:	
	mov	ax,@data
	mov	ds,ax
	xor	ax,ax
len	equ	2	;размерност на първия множител
	xor	bx,bx
	xor	si,si
	mov	cx,len	;в cx дължината на по-големия множител
m1:
	mov	al,b[si]
	mul	c
	aam		;корекция на умножението
	adc	al,dl	;отчитане на предходния пренос
	aaa	;корекция на резултата от събиране с пренос
	mov	dl,ah	; запомняне на переноса
	mov	proizv[bx],al
	inc	si
	inc	bx
	loop m1
	mov	proizv[bx],dl	;отчитане на последния пренос
	
	mov	ah,02h	
	mov	dl,proizv[bx]
	add	dl,30h	;преобразуване на число в символ
	int	21h	
	dec bx
	loop showmul
	
	mov	ax,4c00h
	int	21h
end	main

