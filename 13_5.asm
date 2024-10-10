masm
model small
.data
fname	db	"maket.asm"
point_fname	dd	fname
.stack	256
.code
main:
	mov	ax,@data 
	mov	ds,ax
	lds	dx,point_fname 
	mov	ax,4300h 
	int	21h
	jc	exit 
	nop 
exit:
	mov	ax,4c00h 
	int	21h
end	main	
