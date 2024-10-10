masm
model small
.stack	256
.data
string	db	"String", 13, 10,"$"
adr_string	dd	string
.code
main:
	mov	ax,@data
	mov	ds,ax

	lds	dx,adr_string	; DS:DX
	mov	ah,09h
	int	21h

	mov	ax,4c00h	
	int	21h	
end	main		
