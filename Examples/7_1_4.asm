masm
model	small
stack	256
.data
del_b	label	byte
del	dw	29876; please change value 29876 on 298 after the experiment 
delt	db	45
.code	 
main:	
	mov	ax,@data
	mov	ds,ax

	xor	ax,ax

	mov	ah,del_b	
	mov	al,del_b+1	
	div	delt	

 	
	mov	ax,4c00h	
	int	21h
end	main		

