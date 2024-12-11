masm
model	small
stack	256
.data	
rez	label	word
rez_l	db	45 
rez_h	db	0
.code	 
main:	
	mov	ax,@data
	mov	ds,ax

	xor	ax,ax
	mov	al,25
	mul	rez_l
	jnc	m1	
	mov	rez_h,ah	
m1:
	mov	rez_l,al	

	exit:
	mov	ax,4c00h	
	int	21h
end	main		

