; Week 3 Problem 1

MASM
MODEL small

.stack 256

.data
message_intro DB "Enter a symbol or \ to exit: $"

message_letter DB "This is a letter.", 13, 10, '$'
message_digit DB "This is a digit.", 13, 10, '$'
message_special DB "This is a special character.", 13, 10, '$'

.code
main:
	MOV	AX, @data
	MOV	DS, AX

program:
	MOV AH, 09h
	MOV DX, offset message_intro
	INT 21h
	
	MOV AH, 01h
	INT 21h
	
	CMP AL, '\'
	JE true_exit
	
	CMP AL, '0'
	JL special
	
	CMP AL, '9'
	JLE digit
	
	CMP AL, 'A'
	JL special
	
	CMP AL, 'Z'
	JLE letter
	
	CMP AL, 'a'
	JL special
	
	CMP AL, 'z'
	JLE letter
	
special:
	MOV BX, offset message_special
	JMP exit
	
digit:
	MOV BX, offset message_digit
	JMP exit
	
letter:
	MOV BX, offset message_letter
	
exit:
	MOV AH, 02h
	
	MOV DL, 13
	INT 21h
	MOV DL, 10
	INT 21h
	
	MOV DX, BX
	MOV AH, 09h
	INT 21h
	
	INC CX
	LOOP program
	
true_exit:
	MOV AX, 4c00h
	INT 21h
end main