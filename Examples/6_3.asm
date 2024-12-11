masm
model small
.data
str_1 db 'Assembler is a low-level language.$'
str_2 db 50 dup (' ')
full_pnt dd str_1
.code
	assume	ds:@data,es:@data
start:
	mov	ax,@data
	mov	ds,ax
	mov	es,ax
	xor	ax,ax
	lea	si,str_1
	lea	di,str_2
	les	bx,full_pnt	; es:bx
	mov	cx,34	
m1:
	mov	al,[si]
	mov	[di],al
	inc	si
	inc	di

loop	m1

	mov	ax,4c00h
	int	21h
end start

