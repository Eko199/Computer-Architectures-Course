MODEL	small
STACK	256
.data
match	db	0ah,0dh,'match','$'
failed	db	0ah,0dh,'failed','$'
string1	db	'0123456789',0ah,0dh,'$'
string2	db	'0123406789','$'
.code
ASSUME	ds:@data,es:@data
main:
	mov	ax,@data 
	mov	ds,ax
	mov	es,ax 
	mov	ah,09h
	lea	dx,string1
	int	21h
	lea	dx,string2
	int	21h
	cld		
	lea	si,string1 
	lea	di,string2 
	mov	cx,10 
cycl:
	repe	cmps	string1,string2
	jcxz	equal	;cx=0 
	jne	not_match 
equal: 
	mov	ah,09h 
	lea	dx,match
	int	21h
	jmp	exit 
not_match: 
	mov	ah,09h
	lea	dx,failed
	int	21h 
	dec	si
	dec	di
	;inc	si
	;inc	di
	;jmp	cycl
exit: 
	mov	ax,4c00h
	int	21h
end	main

