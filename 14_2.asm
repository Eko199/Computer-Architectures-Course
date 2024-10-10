masm
model use16 small
.stack 100h
.data   
a dw 1
x dw 8
y dw 4
u dt 0
.code
main 	proc
        mov ax, @data
        mov ds, ax
        finit;привеждаме копроцесора в начално състояние
        fild a; зареждаме стойността на а в st(0)
        fxam ; определяме типа на а
        jc no_null
        jp no_null
        jnz no_null
        ;за а<>0, изчисляване на формулата u=x+y
        fild x
        fiadd y
        fbstp u	; запомняне на BCD число и операция pop
        jmp exit
        no_null:
        ;за а=0, изчисляване на формулата u=(x–y)/a
        fild x
        fisub y
        fidiv a
        fbstp u	; запомняне на BCD число и операция pop
exit:
        mov ax, 4c00h
        int 21h
main 	endp
end 	main

