model   small
stack   256
.data   
pr1   db  2,3,4,6,8,2 ;unpacked BCD-number 286432
pr2   dt  9875645     ;packed BCD-number 9875645
.code
main:
	mov ax,@data
	mov ds,ax
	mov ax,4c00h
 	int 21h
end main
