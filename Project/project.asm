MASM
MODEL small
.stack 256

.data
paging EQU 16
;text DB "I have something to tell you! Today I am feeling depressed!$", 0
text DB "hello asdf BlEh asdf hello "
text_ptr DD text
str_len EQU text_ptr - text
handle DW 0
helper_handle DW 0
result_file DB "result.txt", 0
result_file_ptr DD result_file
helper_file DB "helper.txt", 0
helper_file_ptr DD helper_file

word_start DW 0
word_size DW 0

token_start_ptr DW ?
token_read_count DW ?

new_word_str DB " 1", 0Dh, 0Ah
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

get_nth_token MACRO n
	PUSHA
	;create_file helper_file_ptr
	open_file result_file_ptr, 2 ; changes AX and DX
	
	;open helper
	; MOV AL, 1
	; LDS DX, helper_file_ptr
	; INT 21h
	; MOV helper_handle, AX
	
	PUSH n
	
loop_search_token:
	; read
	MOV AH, 3Fh
	MOV CX, paging
	MOV BX, handle
	LEA DX, buffer
	INT 21h
	
	POP DX
	
	CMP AX, 0
	JE token_not_found
	
	LEA DI, buffer
	
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
	MOV token_read_count, CX
	MOV token_start_ptr, DI
	
	JMP token_found
no_nl:
	PUSH DX
	JMP loop_search_token
	
first_token:
	MOV token_start_ptr, DI
	MOV token_read_count, AX
	JMP token_found
	
token_not_found:
	XOR DX, DX
	MOV token_read_count, DX

token_found:
	POPA
ENDM

; word end i is after the last character
tokenize MACRO string, word_start_i, word_end_i
	PUSHA
	
	;we have a word from AX to BX - 1
	MOV SI, word_start_i ; current char index
	LEA SI, string[SI] ; current char pointer
	
	MOV word_start, SI
	
	MOV DX, word_end_i
	SUB DX, word_start_i
	
	MOV word_size, DX
	XOR CX, CX

search_word:
	MOV SI, word_start ;start ptr, SI can change in CMPS
	MOV DX, word_size
	CMP CX, 0
	JNE not_first
	close_file

not_first:
	get_nth_token CX
	
	CMP token_read_count, 0
	JE not_found
	PUSH CX
	
	; here we have a token with start token_start_ptr and currently read token_read_count bytes from file (includeing token start)
	CLD
	MOV DI, token_start_ptr
	MOV CX, token_read_count
	
	;CX = min(DX, token read count)
	CMP CX, DX
	JLE smaller
	MOV CX, DX
	
smaller:
	REPE CMPSB
	JNE end_comparison
	CMP DX, token_read_count ; DX = current word size
	JL end_comparison_success
	JE end_comparison_success_equal
	
	SUB DX, token_read_count
	MOV token_read_count, DX
	MOV AH, 3Fh
	MOV CX, DX
	MOV BX, handle
	LEA DX, buffer
	INT 21h
	MOV DI, DX
	JMP smaller
	
end_comparison_success_equal:
	PUSH DX
	
	MOV AH, 3Fh
	MOV CX, 1
	MOV BX, handle
	LEA DX, buffer
	INT 21h
	MOV DI, DX
	
	POP DX
end_comparison_success:
	INC DI
end_comparison:
	POP CX
	INC CX
	
	DEC DI
	MOV AL, [DI]
	CMP AL, ' '
	JNE search_word
	CMP DX, token_read_count
	JG search_word
	
	; token found
	INC DI
	SUB token_read_count, DX
	CMP token_read_count, 0
	JNE read_number
	
	MOV AH, 3Fh
	MOV CX, paging
	MOV BX, handle
	LEA DX, buffer
	INT 21h
	MOV DI, DX
	
read_number:
	MOV AH, 02h
	MOV DL, [DI]
	INT 21h
	close_file
	JMP tokenize_done
	
not_found:
	;write "token 1" in file:
	MOV AH, 40h
	MOV BX, handle
	MOV CX, word_size
	MOV DX, word_start
	INT 21h
	
	MOV AH, 40h
	MOV CX, 4
	LEA DX, new_word_str
	INT 21h
	close_file
	
tokenize_done:
	POPA
ENDM

main:
	MOV AX, @data
	MOV DS, AX
	MOV ES, AX
	
	;create_file result_file_ptr
	
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

exit:
	MOV AX, 4C00h
	INT 21h

END main

;Ideas: error handling