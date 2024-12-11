.model tiny
.code
	org 100h
		
start:	mov ah, 9
	mov dx, offset Message
	int 21h
	ret
Message db 'Hello World!', 0Dh, 0Ah, '$'        
	end start
