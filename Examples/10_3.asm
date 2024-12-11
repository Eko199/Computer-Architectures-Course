MASM
MODEL	small
STACK	256
.code
main 		proc
		mov ax,8
		push ax
		call Factorial
		mov ax, 4c00h
		int 21h
main		endp

Factorial 	proc
		push bp
		mov bp, sp
		mov ax,[bp+4]	
		cmp ax,1
		ja L1
		mov ax,1
		jmp L2
L1:		dec ax
		push ax
		call Factorial 	; Factorial(n–1)
		mov bx,[bp+4]		
		mul bx		; ax=ax*bx
L2:		pop bp
		ret 2			
Factorial 	endp
end main