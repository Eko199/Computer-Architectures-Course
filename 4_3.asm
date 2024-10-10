masm
model small
.data
	num1	dw	'91'
	s1	db	"string 1 $"
	s2	db	"string 2 $"
.code
main:
	mov AX, @data
	mov DS, AX
	push DS:num1
	lea SI,s2
	push SI
	lea DX,s1
	mov AH,9h
	int 21h
	pop DX
	int 21h
	pop DX
	xchg DH, DL
	mov AH, 2h
	int 21h
	xchg DH, DL
	int 21h
	
	mov AX, 4c00h
	int 21h
end main


	