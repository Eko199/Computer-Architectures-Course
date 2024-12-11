MASM
MODEL small
STACK 32

.data

handle DW 0
subfile DB "sub.txt", 0
sumfile DB "sum.txt", 0
point_subfile DD subfile
point_sumfile DD sumfile
a DB 0
b DB 0
result DB "00"
point_result DD result

.code
	ASSUME DS:@data
	
print_res_file MACRO file
	;create file
	MOV AH, 3Ch
	LDS DX, file
	INT 21h
	
	;open file
	MOV AH, 3Dh
	MOV AL, 1
	INT 21h
	MOV handle, AX
	
	;write
	MOV AH, 40h
	MOV BX, handle
	LDS DX, point_result
	INT 21h
	
	;close file
	MOV AH, 3Eh
	INT 21h
ENDM
	
main:
	MOV AX, @data
	MOV DS, AX
	XOR CX, CX
	
	;A and B
	MOV AH, 01h
	INT 21h
	MOV a, AL
	INT 21h
	MOV b, AL
	
	;bytes count
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
	print_res_file point_subfile
	
	;bytes count
	MOV CX, 1

	MOV AH, a
	SUB AH, '0'
	ADD AH, b
	SUB AH, '0'
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
	print_res_file point_sumfile
	
exit:
	MOV	AX, 4C00h
	INT	21h
end main