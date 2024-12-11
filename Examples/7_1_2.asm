masm
model	small
stack	256
.data
.code	 
main:	
	mov	ax,@data
	mov	ds,ax

	xor	ax,ax
	mov	al,5
	sub	al,10
	jnc	m1
	neg al	 
m1: 
	exit:
	mov	ax,4c00h	
	int	21h
end main		

