MASM
MODEL	small
STACK	256
.data
mes	db	0ah,0dh,'Masiv - ','$'
mas	db	10 dup (?)	;масив
i	db	0
.code
main:
	mov	ax,@data
	mov	ds,ax
	xor	ax,ax	;зануляване на ax
	mov	cx,10	;стойността на брояча на цикъла в cx
	mov	si,0	;индекса на началния елемент в si
go:		;цикъл за инициализация
	mov	bh,i	;i в bh
	mov	mas[si],bh	;запис в масива на i
	inc	i	;инкремент i
	inc	si	;преход към следващия елемент на масива
	loop	go	;да се повтори цикъла
;извеждане на екрана на получения масив
	mov	cx,10
	mov	si,0
	mov	ah,09h
	lea	dx,mes
	int	21h
show:
	mov	ah,02h	;функция за извеждане стойността на al на екрана
	mov	dl,mas[si]
	add	dl,30h	;преобразуване на число в символ
	int	21h
	inc	si
	loop	show
exit:
	mov	ax,4c00h
	int	21h
end	main

