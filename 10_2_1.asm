include	mac.inc
extrn	my_proc2:far,pr0:byte
public	pr1,pr2
stk	segment	stack
	db	256 dup (0)
stk	ends
data	segment	para public 'data'
pr1	db	'1'
pr2	db	'2'
data	ends
code	segment
main	proc	far
assume	cs:code,ds:data,ss:stk
	mov	ax,data
	mov	ds,ax
	mov	dl,pr0
	OutChar
call	my_proc2
	Exit
main	endp
code	ends
end	main

