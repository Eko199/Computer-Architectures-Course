model small
.stack	100h
.data
len equ	10
mas db 1, 0, 9, 8, 0, 7, 8, 0, 2, 0
.code
start:
	mov ax, @data
	mov ds, ax
	mov cx, len	
	xor ax, ax
	xor si, si
	jcxz exit	
cycl:
	cmp mas[si], 0
	jne m1
	inc al
m1:
	inc si
	loop cycl
exit:
	mov ax, 4c00h
	int 21h
end	start
