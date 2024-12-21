MASM
MODEL small
STACK 128

.data
;text DB "I have something to tell you! Today I am feeling depressed!$", 0
text DB "I have A$"
textPtr DW text
strLen EQU textPtr - text - 1

.code
ASSUME DS:@data

is_upper MACRO char
	;DL == not upper
	MOV DL, char LT 'A'
	OR DL, char GT 'Z'
	CMP DL, 0
ENDM

;sets ZF to 1 if str1 == str2
str_eq MACRO str1, len1, str2, len2
	CMP len1, len2
	JNE str_eq_exit
	
	;len1 == len2
	MOV CX, len1
	XOR BX, BX
	
check_symbol:
	CMP str1[BX], str2[BX]
	JNE str_eq_exit
	INC BX
	LOOP check_symbol
	
	CMP 0, 0
	
str_eq_exit:
ENDM

;makes letter string in lower case
to_lower MACRO string, len
	MOV CX, len
	XOR BX, BX
	
to_lower_char:
	CMP string[BX], 'Z'
	JG lower
	ADD string[BX], 32
	
lower:
	INC BX
	LOOP to_lower_char
ENDM

main:
	MOV AX, @data
	MOV DS, AX
	
	MOV CX, strLen
	XOR BX, BX
	XOR AX, AX
	
split_words:
	is_upper text[BX]
	JNE not_upper
	ADD text[BX], 32
	JMP not_space
	
not_upper:
	CMP text[BX], ' '
	JNE not_space
	CMP BX, AX
	JE multiple_spaces
	
	;MOV DX, CX
	;MOV CX, BX
	;SUB CX, AX
	;XOR SI, SI
	
	;MOV CX, DX

multiple_spaces:
	MOV AX, BX
	INC AX
not_space:
	INC BX
	LOOP split_words
	
right:
	MOV AH, 02h
	INT 21h
	
exit:
	MOV AX, 4C00h
	INT 21h

end main