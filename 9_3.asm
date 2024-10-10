MASM
MODEL	small
STACK	256
.data
fnd	db	0ah,0dh,'find','$'
nochar	db	0ah,0dh,'nochar','$'
string	db	'find char',0ah,0dh,'$'
.code
ASSUME ds:@data,es:@data
main:
	mov	ax,@data
	mov	ds,ax
	mov	es,ax 
	mov	ah,09h
	lea	dx,string
	int	21h 
	mov	al,'a'
	cld 
	lea	di,string 
	mov	cx,10	
repne	scas	string
	je	found	
failed: 
	mov	ah,09h
	lea	dx,nochar
	int	21h 
	jmp	exit 
found: 
	mov	ah,09h
	lea	dx,fnd
	int	21h 
exit:	
	mov	ax,4c00h
	int	21h
end	main
