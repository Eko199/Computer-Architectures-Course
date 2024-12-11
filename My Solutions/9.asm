MODEL	small
STACK	256
.data
maxlen equ 30
input db maxlen DUP (' ')

.code
assume ds:@data, es:@data
main:
	mov	ax, @data 
	mov	ds, ax
	mov	es, ax 
	
	mov ah, 01h
	mov cx, maxlen
	xor bx, bx
	
input_cycl:
	int 21h
	cmp al, 0Dh
	je check
	mov input[bx], al
	push ax
	inc bx
	loop input_cycl
	
check:
	mov cx, bx
	lea si, input
	
check_cycl:
	pop dx
	cmp [si], dl
	jne not_match
	inc si
	loop check_cycl

equal: 
	mov	ah, 02h 
	mov dl, 'Y'
	jmp	exit 
	
not_match: 
	mov	ah, 02h 
	mov	dl, 'N'
	
exit: 
	int	21h
	mov	ax, 4c00h
	int	21h
end	main

