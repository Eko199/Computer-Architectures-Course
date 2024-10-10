masm
model	small
stack	256
.data
a	db	254
.code	 
main:
	mov	ax,@data
	mov	ds,ax

	xor	ax,ax
	add	al,17
	add	al,a
	jnc	m1	
	adc	ah,0	 
m1: 
	exit:
	mov	ax,4c00h	
	int	21h
end main			

