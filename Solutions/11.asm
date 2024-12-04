MASM
MODEL small
STACK 32

.data

handle dw 0
subfile db "sub.txt", 0
sumfile db "sum.txt", 0
point_subfile dd subfile
point_sumfile dd sumfile
a db 0
b db 0
result db "00"
point_result dd result

.code
	ASSUME DS:@data
	
main:
	MOV AX, @data
	MOV DS, AX
	XOR AX, AX
	XOR CX, CX
	
	;create subfile
	MOV AH, 3Ch
	LDS DX, point_subfile
	INT 21h
	
	;A and B
	MOV AH, 01h
	INT 21h
	MOV a, AL
	INT 21h
	MOV b, AL
	
	;open subfile
	MOV AH, 3Dh
	MOV AL, 1
	INT 21h
	MOV handle, AX
	
	MOV CX, 1
	;check negative
	MOV AH, a
	CMP AH, b
	JL negative
	
positive:
	SUB AH, b
	ADD result, AH
	JMP write_sub
	
negative:
	MOV result, '-'

	MOV AH, b
	SUB AH, a
	ADD result[1], AH
	INC CX
	
write_sub:
	MOV AH, 40h
	MOV BX, handle
	LDS DX, point_result
	INT 21h
	
	;create sumfile
	MOV AH, 3Ch
	LDS DX, point_sumfile
	INT 21h
	
	;open sumfile
	MOV AH, 3Dh
	MOV AL, 1
	INT 21h
	MOV handle, AX
	
	MOV CX, 1
	MOV AH, a
	SUB AH, '0'
	MOV AL, b
	SUB AL, '0'
	ADD AH, AL
	;check double digit
	CMP AH, 10
	JL digit
	
double_digit:
	MOV result, '1'
	MOV result[1], '0'
	SUB AH, 10
	ADD result[1], AH
	INC CX
	JMP write_sum
	
digit:
	MOV result, '0'
	ADD result, AH
	
write_sum:
	MOV AH, 40h
	MOV BX, handle
	LDS DX, point_result
	INT 21h
	
exit:
	MOV	AX, 4C00h
	INT	21h
end main