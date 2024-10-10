masm
model small
.stack 256

.data	
	mes	db	'Vyvedete dve shestnaistichni cifri: $'
tabl	db	48 dup (0),0,1,2,3,4,5,6,7,8,9,7 dup (0),0ah,0bh,0ch,0dh,0eh,0fh,26 dup (0),0ah,0bh,0ch,0dh,0eh,0fh, 153 dup (0)

		 
.code
 
main:	
	mov 	ax,@data	
	mov	ds,ax	
	lea	bx,tabl	
	mov	ah,9
	mov	dx,offset mes
	int	21h	
	xor	ax,ax	
	mov	ah,1h	
	int	21h	
	xlat
	xor	dl,dl
	mov	dl,al
	shl	dl,4	
	int	21h	
	xlat	
	add	al,dl	 
		
	mov	ax,4c00h	 
	int	21h	
	 
end	main		

