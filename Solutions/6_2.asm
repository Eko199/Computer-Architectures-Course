MASM
MODEL small

.stack 256

.data
message_intro DB "Enter a digit: $"

message_input DB 10, 13, "Enter characters: $"
message_output DB 10, 13, "Reversed characters: $"

.code
main:
	MOV	AX, @data
	MOV	DS, AX

	MOV AH, 09h
	MOV DX, offset message_intro
	INT 21h
	
	MOV AH, 01h
	INT 21h
	
	CMP AL, '0'
	JE exit
	SUB AL, '0'
	
	MOV BL, AL
	
	XOR CX, CX
	MOV CL, AL
	
	MOV AH, 09h
	MOV DX, offset message_input
	INT 21h
	
	MOV AH, 01h
	
input:
	INT 21h
	PUSH AX
	
	LOOP input
	
	MOV AH, 09h
	MOV DX, offset message_output
	INT 21h
	
	MOV AH, 02h
	XOR CX, CX
	MOV CL, BL

output:
	POP DX
	INT 21h
	
	LOOP output
	
exit:
	MOV AX, 4c00h
	INT 21h
end main