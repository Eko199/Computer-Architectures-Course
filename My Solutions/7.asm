; Week 4

MASM
MODEL small
.data
input db "Enter a digit: $"
rez db "00$"
output db "0 + 0 = $"

.code
main:
	MOV AX, @data
	MOV DS, AX
	
	MOV AH, 9h
	MOV DX, offset input
	INT 21h

	MOV AH, 1h
	
	INT 21h
	SUB AL, '0'
	ADD output, AL
	
	MOV AH, 2h
	MOV DL, 13
	INT 21h
	MOV DL, 10
	INT 21h
	
	MOV AH, 9h
	MOV DX, offset input
	INT 21h
	
	MOV AH, 1h
	
	INT 21h
	SUB AL, '0'

	ADD output[4], AL
	ADD AL, output
	AAA
	
	ADC rez, 0
	ADD rez[1], AL
	
	MOV AH, 2h
	MOV DL, 13
	INT 21h
	MOV DL, 10
	INT 21h
		
	MOV AH, 9h
	MOV DX, offset output
	INT 21h
	
	CMP rez, '0'
	JNE double
	
	MOV AH, 2h
	MOV DL, rez[1]
	INT 21h
	JMP exit
	
double:
	MOV AH, 9h
	MOV DX, offset rez
	INT 21h

exit:	
	MOV AX, 4c00h
	INT 21h
end main