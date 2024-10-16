;Week 2

stk segment stack
	db 256 dup ('?')
stk ends

code segment para public 'code'
	assume cs:code, ss:stk
main:
	mov AH, 1h
	int 21h
	push AX
	int 21h
	push AX
	int 21h
	push AX
	
	mov AH, 2h
	
	mov DL, 13
	int 21h
	mov DL, 10
	int 21h
	
	pop DX
	int 21h
	pop DX
	int 21h
	pop DX
	int 21h
	
	mov AX, 4c00h
	int 21h
code ends
end main


	