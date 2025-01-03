MASM
MODEL small
.stack 256

.data
paging EQU 16
file_size EQU 1000
text DB 1001 DUP(' ')
handle DW 0

input_message DB "Enter file name to open (must be at most 8 characters with max 3 characters extension): $"
file_name_limit EQU 12
input_file DB 13 DUP(0)
input_file_ptr DD input_file

tokens_message DB 0Dh, 0Ah, "Tokens count: $"
commons_message DB 0Dh, 0Ah, "Enter N (<= 300) to show the N most common tokens (or 0 or enter to exit): $"
file_error_message DB 0Dh, 0Ah, "Failed to open file. Check for valid name.$"
n_error_message DB 0Dh, 0Ah, "N is too large! Must be <= 300.$"

result_file DB "result.txt", 0
result_file_ptr DD result_file

word_start DW 0
word_size DW 0

token_start_ptr DW ?
token_read_count DW ?

new_word_str DB " 1   ", 0Dh, 0Ah
buffer DB paging DUP(?)

number DW 0
token_count DW 0
commons_count DW 0
max_commons EQU 300
best_common_count DW 0
best_common_row DW 0
commons_row_read DW max_commons DUP(?)

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
	JC error_file
	MOV handle, AX
ENDM

read_file MACRO count, result
	MOV AH, 3Fh
	MOV BX, handle
	MOV CX, count
	LEA DX, result
	INT 21h
ENDM

write_file MACRO string, len
	MOV AH, 40h
	MOV BX, handle
	MOV CX, len
	LEA DX, string
	
	INT 21h
ENDM

close_file MACRO
	MOV AH, 3Eh
	MOV BX, handle
	INT 21h
ENDM

;expects argument in CX
get_nth_token PROC
	PUSHA
	PUSH CX
	
	open_file result_file_ptr, 2 ; changes AX and DX
	
loop_search_token:
	read_file paging, buffer
	
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
	
	CMP CX, 0 ; we ran out of buffer bytes
	JNE bytes_remain
	
	read_file paging, buffer
	MOV DI, DX
	
	MOV token_read_count, AX
	
bytes_remain:
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
	MOV token_read_count, 0

token_found:
	POPA
	RET
ENDP

read_file_number PROC
	read_file 4, buffer ;number can be at most 1000
	MOV DI, DX

	MOV number, 0
	XOR BH, BH

read_number:
	MOV BL, [DI]
	CMP BL, '0'
	JL read_number_done
	CMP BL, '9'
	JG read_number_done
	
	MOV AX, number
	MOV DX, 10
	MUL DX
	ADD AX, BX
	SUB AX, '0'
	MOV number, AX
	
	INC DI
	LOOP read_number
	
read_number_done:
	RET
ENDP
	

;expects SI = token start char index
;DX = token end index exclusive
tokenize PROC
	PUSHA
	INC token_count
	
	SUB DX, SI ; DX = token length
	LEA SI, text[SI] ; current char pointer
	
	MOV word_start, SI
	MOV word_size, DX
	XOR CX, CX

search_word:
	MOV SI, word_start ;start ptr, SI can change in CMPS
	MOV DX, word_size
	CMP CX, 0
	JE first
	close_file

first:
	CALL get_nth_token
	
	CMP token_read_count, 0
	JE not_found
	PUSH CX
	
	; here we have a token with start token_start_ptr and currently read token_read_count bytes from file (includeing token start)
	CLD
	MOV DI, token_start_ptr
	MOV CX, token_read_count
	
	; CX = min(DX, token read count)
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
	PUSH DX
	
	; CX = min(DX, paging)
	MOV CX, paging
	CMP CX, DX
	JLE smaller2
	MOV CX, DX

smaller2:
	read_file CX, buffer
	MOV DI, DX
	
	POP DX ; DX = current word size
	
	MOV token_read_count, AX
	JMP smaller
	
end_comparison_success_equal:
	PUSH DX
	
	read_file 1, buffer
	MOV DI, DX
	
	INC token_read_count
	
	POP DX
end_comparison_success:
	INC DI
	INC SI
end_comparison:
	POP CX
	INC CX
	
	MOV AL, [DI-1]
	CMP AL, ' '
	JNE search_word
	
	;check if word in SI is finished
	DEC SI ;cmp moves SI after wrong check
	SUB SI, word_start
	CMP SI, word_size
	JNE search_word
	
	CMP DX, token_read_count
	JG search_word
	
	; token found
	SUB token_read_count, DX
	CMP token_read_count, 1 ; i think it can't be zero
	JE no_move_back ; because we would NEG 0
	
	;move back file pointer
	MOV AX, 4201h
	MOV BX, handle
	MOV CX, 0FFFFh
	MOV DX, token_read_count
	DEC DX
	NEG DX
	INT 21h
	
no_move_back:
	CALL read_file_number
	
write_number:
	INC number
	MOV AX, 4201h
	MOV BX, handle
	MOV CX, 0FFFFh
	MOV DX, -4h
	INT 21h
	
	XOR DX, DX
	MOV AX, number
	MOV BX, 1000
	DIV BX
	
	MOV number, DX
	CMP AX, 0
	JE write_triple_digit
	
	ADD AL, '0' ; not ax because ax is a digit
	MOV buffer, AL
	write_file buffer, 1
	
	CMP number, 100
	JGE write_triple_digit
	
	MOV buffer, '0'
	write_file buffer, 1
	
	CMP number, 100
	JL write_double_digit_zero
	
write_triple_digit:
	XOR DX, DX
	MOV AX, number
	MOV BX, 100
	DIV BX
	
	MOV number, DX
	CMP AX, 0
	JE write_double_digit
	
	ADD AL, '0'
	MOV buffer, AL
	write_file buffer, 1
	
write_double_digit_zero:
	CMP number, 10
	JGE write_double_digit
	
	MOV buffer, '0'
	write_file buffer, 1
	JMP write_single_digit
	
write_double_digit:
	XOR DX, DX
	MOV AX, number
	MOV BX, 10
	DIV BX
	
	MOV number, DX
	CMP AX, 0
	JE write_single_digit
	
	ADD AL, '0'
	MOV buffer, AL
	write_file buffer, 1

write_single_digit:
	ADD number, '0'
	write_file number, 1

	JMP tokenize_done
	
not_found:
	;write "token 1   \r\n" in file:
	MOV AH, 40h
	MOV BX, handle
	MOV CX, word_size
	MOV DX, word_start
	INT 21h
	
	MOV AH, 40h
	MOV CX, 7
	LEA DX, new_word_str
	INT 21h
	
tokenize_done:
	close_file
	POPA
	RET
ENDP

print_commons MACRO
	MOV CX, commons_count
	LEA SI, commons_row_read
	
print_next_common:
	PUSH CX
	XOR CX, CX
	MOV best_common_count, 0
	
find_next_common:
	CALL get_nth_token
	CMP token_read_count, 0
	JE found_token
	
	PUSH CX
	
	CLD
	MOV DI, token_start_ptr
	MOV CX, token_read_count
	
search_number:
	MOV AL, ' '
	REPNE SCASB
	JE found_number
	
	read_file paging, buffer
	MOV CX, AX
	MOV DI, DX
	INC CX
	LOOP search_number
	
found_number:
	;move back file pointer
	MOV AX, 4201h
	MOV BX, handle
	MOV DX, CX
	NEG DX
	MOV CX, 0FFFFh
	INT 21h
	
	CALL read_file_number
	close_file
	POP CX
	
	MOV DX, number
	
	MOV AX, CX
	
	CMP DX, best_common_count
	JLE continue_find_next_common
	
	POP BX ; first it is commons count then -1, -2, ..., 0
	PUSH BX
	MOV CX, commons_count
	SUB CX, BX ; current common token (first, second, ...)
	
	CMP CX, 0
	JE skip_check
	
	LEA DI, commons_row_read
	REPNE SCASW
	JE continue_find_next_common
	
skip_check:
	; new best
	MOV best_common_count, DX
	MOV best_common_row, AX

continue_find_next_common:
	MOV CX, AX
	INC CX
	JMP find_next_common

found_token:
	CMP best_common_count, 0
	JE end_commons
	
	MOV CX, best_common_row
	CALL get_nth_token
	
	MOV DI, token_start_ptr
	MOV CX, token_read_count
	
	; print nl
	MOV AH, 02h
	MOV DL, 0Dh
	INT 21h
	MOV DL, 0Ah
	INT 21h
	
print_token:
	MOV DL, [DI]
	CMP DL, ' '
	JE print_complete

	MOV AH, 02h
	INT 21h
	
	INC DI
	LOOP print_token
	
	; read if ran out of buffer
	read_file paging, buffer
	MOV DI, DX
	MOV CX, AX
	INC CX
	LOOP print_token
	
print_complete:
	close_file
	
	; save used row
	MOV DI, SI
	MOV AX, best_common_row
	STOSW
	
	MOV SI, DI
	POP CX
	DEC CX
	JNZ print_next_common
	
end_commons:
ENDM

main:
	MOV AX, @data
	MOV DS, AX
	MOV ES, AX
	
	MOV AH, 09h
	LEA DX, input_message
	INT 21h
	
	LEA SI, input_file
	MOV CX, file_name_limit
	MOV AH, 01h
read_input_filename:
	INT 21h
	
	CMP AL, 0Dh
	JE read_input
	
	MOV [SI], AL
	INC SI
	LOOP read_input_filename
	
read_input:
	open_file input_file_ptr, 0
	read_file file_size, text
	
	INC AX ; add space at the end
	PUSH AX
	
	close_file
	
	create_file result_file_ptr
	
	POP CX
	XOR BX, BX
	XOR AX, AX
	
split_words:
	is_upper text[BX]
	JNE not_upper
	ADD text[BX], 32
	
not_upper:
	CMP text[BX], 'a'
	JL special
	CMP text[BX], 'z'
	JG special
	
letter:
	INC BX
	
	LOOP split_words
	
	MOV AH, 09h
	LEA DX, tokens_message
	INT 21h
	
	XOR DX, DX
	MOV AX, token_count
	MOV BX, 1000
	DIV BX
	
	MOV token_count, DX
	CMP AX, 0
	JE print_triple_digit
	
	ADD AL, '0' ; not ax because ax is a digit
	MOV DL, AL
	MOV AH, 02h
	INT 21h
	
	CMP token_count, 100
	JGE print_triple_digit
	
	MOV DL, '0'
	INT 21h
	
	CMP token_count, 100
	JL print_double_digit_zero
	
print_triple_digit:
	XOR DX, DX
	MOV AX, token_count
	MOV BX, 100
	DIV BX
	
	MOV token_count, DX
	CMP AX, 0
	JE print_double_digit
	
	ADD AL, '0'
	MOV DL, AL
	MOV AH, 02h
	INT 21h
	
print_double_digit_zero:
	CMP token_count, 10
	JGE print_double_digit
	
	MOV DL, '0'
	INT 21h
	JMP print_single_digit
	
print_double_digit:
	XOR DX, DX
	MOV AX, token_count
	MOV BX, 10
	DIV BX
	
	MOV token_count, DX
	CMP AX, 0
	JE print_single_digit
	
	ADD AL, '0'
	MOV DL, AL
	MOV AH, 02h
	INT 21h

print_single_digit:
	MOV AH, 02h
	MOV DX, token_count
	ADD DL, '0'
	INT 21h
	
	MOV AH, 09h
	LEA DX, commons_message
	INT 21h
	
	;read number
	MOV CX, 3
	MOV BX, 10
	
read_digit:
	MOV AH, 01h
	INT 21h
	
	CMP AL, '0'
	JL read_common_number_complete
	CMP AL, '9'
	JG read_common_number_complete
	
	XOR AH, AH
	SUB AL, '0'
	
	PUSH CX
	MOV CL, AL
	
	MOV AX, commons_count
	MUL BX
	MOV commons_count, AX
	
	XOR CH, CH
	ADD commons_count, CX
	POP CX
	
	LOOP read_digit
	
read_common_number_complete:
	CMP commons_count, 0
	JE exit
	
	CMP commons_count, max_commons
	JG n_too_large
	
	print_commons

	JMP exit
	
special:
	CMP BX, AX
	JE single_char
	
token:
	MOV SI, AX
	MOV DX, BX
	CALL tokenize
	
single_char:
	CMP text[BX], ' '
	JE continue
	CMP text[BX], 0Dh
	JE continue
	CMP text[BX], 0Ah
	JE continue
	CMP text[BX], 09h ; tab
	JE continue
	
	MOV SI, BX
	MOV DX, BX
	INC DX
	CALL tokenize

continue:
	MOV AX, BX
	INC AX
	
	JMP letter
	
n_too_large:
	MOV AH, 09h
	LEA DX, n_error_message
	INT 21h
	JMP exit
	
error_file:
	MOV AH, 09h
	LEA DX, file_error_message
	INT 21h

exit:
	MOV AX, 4C00h
	INT 21h

END main

; Ideas: 
; - error handling
; - remove trailing spaces
; - read input in pages (not 1000)
; - write number with file (not only 4 digits)
; - make commons work for more than 300
; - retry after error
; - prettier commons printing