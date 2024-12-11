masm
model small
.data
handle	dw	0 
filename	db	'my_file.txt',0
point_fname	dd	filename
.stack	256
.code
main:
	mov	ax,@data 
	mov	ds,ax
	xor	cx,cx
	lds	dx,point_fname
	mov	ah,3ch
	int	21h	
	jc	exit
	mov	handle,ax 
exit:
	mov	ax,4c00h 
	int	21h
end	main
