; Turbo Debuger -> Numeric processor
masm
model use16 small
.stack 100h
.data
ch_dt dt 43567		;ch_dt=00 00 00 00 00 00 00 04 35 67
x dw 3			;x=00 03
y_real dq 34e7		;y_real=41 b4 43 fd 00 00
ch_dt_st dt 0
x_st dw 0
y_real_st dq 0
.code
main 	proc
mov ax, @data
mov ds, ax
fbld ch_dt		;st(0)=43S67
fild x			;st(l)=43567, st(0)=3
fild y_real		;st(2)=43567, st(l)=3, st(0)=340000000
fxch st(2)		;st(2)=340000000, st(l)=3, st(0)=43567
fbstp ch_dt_st		;st(l)=340000000, st(0)=3
			;ch_dt_st=00 00 00 00 00 00 00 04 35 67
fistp x_st		;st(0)=340000000, x_st=00
fstp y_real_st		;y_real_st=41 b4 43 fd 00
exit:
mov ax, 4c00h
int 21h
main 	endp
end 	main
