MASM
MODEL small
STACK 128

.data
text DB "I have something to tell you! Today I am feeling depressed!", 0
textPtr DD text

.code
ASSUME DS:@data

;sets ZF to 1 if str1 == str2
str_eq MACRO str1, len1, str2, len2
	CMP len1, len2
	JNE mac_exit
	
	;len1 == len2
	MOV CX, len1
	XOR BX, BX
	
check_symbol:
	CMP str1[BX], str2[BX]
	JNE mac_exit
	INC BX
	LOOP check_symbol
	
	CMP 0, 0
	
mac_exit:
ENDM

main:
	MOV AX, @data
	MOV DS, AX
	
exit:
	MOV AX, 4C00h
	INT 21h

end main