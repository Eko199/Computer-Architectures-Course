masm
model	small
stack	256
.data 
len	equ	2	;разрядност на числото
b	db	1,7	;неопакованото число 71
c	db	4,5	;неопакованото число 54
sum	db	3 dup (0)
.code
main:	
	mov	ax,@data
	mov	ds,ax

	xor	bx,bx
	mov	cx,len
m1:
	mov	al,b[bx]
	adc	al,c[bx]
	aaa
	mov	sum[bx],al
	inc	bx
	loop	m1
	adc	sum[bx],0

	mov	ax,4c00h	
	int	21h
end main		
