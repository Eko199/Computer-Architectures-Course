include	mac.inc
extrn	pr1:byte,pr2:byte
public	my_proc2,pr0
data	segment	para public 'data'
pr0	db	'0'
data	ends
code	segment
my_proc2	proc	far
assume	cs:code,ds:data
	mov	dl,pr0
	OutChar
	mov	dl,pr1
	OutChar
	mov	dl,pr2
	OutChar
	mov	dl,pr0
	OutChar
	ret
my_proc2	endp
code	ends
	end

