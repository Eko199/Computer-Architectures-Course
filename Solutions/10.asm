MASM
MODEL small
.data
last DB ' '
.code
	ASSUME DS:@data
	
printNumber MACRO x
	XOR AX, AX

	MOV AL, x
	MOV BX, 10
	DIV BX
	MOV BX, DX
	
	MOV AH, 02h
	MOV DL, AL
	ADD DL, '0'
	INT 21h
	
	MOV DL, BL
	ADD DL, '0'
	INT 21h
ENDM
	
main:
	MOV AX, @data
	MOV DS, AX
	
	MOV CX, 30
	MOV AH, 01h
	XOR BX, BX
	XOR DX, DX
	
input_cycle:
	INT 21h
	CMP AL, 0Dh
	JE print
	
	CMP AL, 'A'
	JL count_words
	
	CMP AL, 'Z'
	JLE letter
	
	CMP AL, 'a'
	JL count_words
	
	CMP AL, 'z'
	JG count_words
	
letter:
	INC DH
	
count_words:
	;check if whitespace
	CMP AL, 20h
	JNE counted
	CMP last, 20h
	JE counted
	INC DL
	
counted:
	MOV last, AL
	INC BX
	LOOP input_cycle
	
print:
	CMP last, 20h
	JE no_remain
	INC DL

no_remain:
	MOV CX, DX
	printNumber CH
	printNumber CL
	
exit:
	MOV	AX, 4C00h
	INT	21h
	
end main