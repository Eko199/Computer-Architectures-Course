masm
model	small
stack	256
.data	
b	db	17h	;опакованото число 17h
c	db	45h	;опакованото число 45h
sum	db	2 dup (0)
.code	
main:	
	mov	ax,@data
	mov	ds,ax
	xor	ax,ax
	mov	al,b
	add	al,c
	daa
	jnc	$+6	;преход, за резултат <= 99
	mov	sum+1,ah	;отчитане на преноса при събиране (резултатът > 99)
	mov	sum,al	;младшите опаковани цифри на резултата
	mov	ax,4c00h
	int	21h
end	main

