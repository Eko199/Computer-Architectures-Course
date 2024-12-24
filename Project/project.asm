MASM
MODEL small
STACK 128

.data
paging EQU 16
;text DB "I have something to tell you! Today I am feeling depressed!$", 0
text DB "World "
text_ptr DD text
str_len EQU text_ptr - text
handle DW 0
helper_file DB "helper.txt", 0
helper_file_ptr DD helper_file


word_start DW 0
word_size DW 0

current_word_start DW 0
current_word_size DW 0

token_start_ptr DW ?
token_read_count DW ?

buffer DW paging DUP(?)

.code
.386
ASSUME DS:@data
ASSUME ES:@data

;changes DL!
is_upper MACRO char
	;DL == not upper
	CMP char, 'A'
	JL is_not_upper
	CMP char, 'Z'
	JG is_not_upper
	XOR DL, DL ; sets ZF = 1
is_not_upper:
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

create_file MACRO file_ptr
	MOV AH, 3Ch
	LDS DX, file_ptr
	INT 21h
ENDM

open_file MACRO file_ptr, mode
	MOV AH, 3Dh
	MOV AL, mode
	LDS DX, file_ptr
	INT 21h
	MOV handle, AX
ENDM

; read_file MACRO file_ptr, count
	; MOV AH, 3Fh
	; MOV BX, handle
	; MOV CX, count
	; INT 21h
; ENDM

write_file MACRO string, len
	MOV AH, 40h
	MOV BX, handle
	MOV CX, len
	LDS DX, string
	
	INT 21h
ENDM

close_file MACRO
	MOV AH, 3Eh
	MOV BX, handle
	INT 21h
ENDM

; get_next_word MACRO prefix_start, prefix_end
	; PUSHA

	; ;read file
	; MOV AH, 3Fh
	; MOV CX, paging
	; MOV BX, handle
	; INT 21h
	
	; POPA
; ENDM 

get_nth_token MACRO n
	open_file helper_file_ptr, 0 ; changes AX and DX
	PUSH n
	
loop_search_token:
	; read
	MOV AH, 3Fh
	MOV CX, paging
	MOV BX, handle
	LEA DX, buffer
	INT 21h
	
	CMP AX, 0
	JE token_not_found
	
	MOV DI, DX
	POP DX
	
	CMP DX, 0
	JE first_token
	
	MOV CX, AX
	MOV AL, 0Ah
	CLD
	
count_nl:
	REPNE SCASB
	JNE no_nl
	DEC DX
	CMP DX, 0
	JNE count_nl
	
	;DX == 0 => next characters until space are the token
	DEC CX
	MOV token_read_count, CX
	INC DI
	CMP CX, 0 ; we ran out of buffer bytes
	JNE bytes_remain
	
	MOV AH, 3Fh
	MOV CX, paging
	LEA DX, buffer
	INT 21h
	MOV DI, DX
	
	MOV token_read_count, AX
	
bytes_remain:
	MOV token_start_ptr, DI
	
	JMP token_found
no_nl:
	JMP loop_search_token
	
first_token:
	MOV token_start_ptr, DI
	MOV token_read_count, AX
	JMP token_found
	
token_not_found:
	XOR DX, DX
	MOV token_read_count, DX

token_found:
	;close_file
ENDM

; word end i is after the last character
tokenize MACRO string, word_start_i, word_end_i
	PUSHA
	
	;we have a word from AX to BX - 1
	MOV SI, word_start_i ; current char index
	LEA SI, string[SI] ; maybe not needed? - current char pointer
	
	MOV word_start, SI ;start ptr
	;MOV current_word_start, SI
	
	MOV DX, word_end_i
	SUB DX, word_start_i
	
	MOV word_size, DX
	;MOV current_word_size, DX
	XOR CX, CX

search_word:
	get_nth_token CX
	PUSH CX
	CMP token_read_count, 0
	JE not_found
	
	; here we have a token with start token_start_ptr and currently read token_read_count bytes from file
	CLD
	MOV DI, token_start_ptr
	MOV CX, token_read_count
	CMPSB
	JNE currently_not_found
	
	
	
	close_file
	POP CX
	JMP tokenize_done
	
currently_not_found:
	close_file
	POP CX
	INC CX
	JMP search_word
	
	
	; ;check if insufficient characters
	; CMP AX, current_word_size
	; JL not_found
	
	; MOV DI, DX
	; MOV CX, AX ; = bytes read count
	
	; XOR BX, BX
	; CLD
	
; loop_current_page:
	; REPE CMPSB
	; JE were_equal
	; CMP CX, 1
	; JE last_difference
	
	; ;incorrect word

; last_difference:
	; ;reached character
	; MOV DL, [DI]
	; CMP DL, ' '
	; ;JNE not_
	
; were_equal:

; finish_comparison:
	
	; MOV DX, BX
	; INC BX
	; LOOP loop_current_page
	
not_found:
	;write word 1 in file here:
	
tokenize_done:
	POPA
ENDM

main:
	MOV AX, @data
	MOV DS, AX
	
	;create_file helper_file_ptr
	
	MOV CX, str_len
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
	
	tokenize text, AX, BX

multiple_spaces:
	MOV AX, BX
	INC AX
not_space:
	INC BX
	
	DEC CX
	JNZ split_words ; LOOP is out of range
	
	; MOV DL, strLen
	; ADD dl, '0'
	; MOV AH, 02h
	; INT 21h

exit:
	MOV AX, 4C00h
	INT 21h

END main

;Ideas: error handling