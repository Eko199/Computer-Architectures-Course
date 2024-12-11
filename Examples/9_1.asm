MASM
MODEL	small
STACK	256
.data
source	db	'Test line','$'	
dest	db	10 DUP (' ')
.code
	assume	ds:@data,es:@data
main:	
	mov	ax,@data
	mov	ds,ax 
	mov	es,ax
	cld 
	lea	si,source 
	lea	di,dest 
	mov	cx,11	
rep	movs	dest,source 
	lea	dx,dest
	mov	ah,09h 
	int	21h
exit:
	mov	ax,4c00h
	int	21h
end	main

