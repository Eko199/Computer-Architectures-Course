model small
stack 256
.data
a DB
b DB
.code
main:
	MOV AX, @data
	MOV DS, AX
	
	MOV AH, 1
	INT 21h
	MOV a, AL
	
	INT 21h
	MOV b, AL
	
	MOV AH, a
	NOT AH
	OR AH, b
	NOT AH
	XOR AH, b
	OR AH, a
	MOV AL, b
	AND AL, a
	XOR AH, AL
	
exit:
	MOV AX, 4c00h
	INT 21h
end	main
