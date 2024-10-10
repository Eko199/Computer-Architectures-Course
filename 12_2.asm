;Извеждане на екрана на числото, записано в регистър AX, в десетична бройна система. (Използва се делител байт.)
model small
stack 100h
.code
main:
       mov ax, 77h 	; използваме маркер за край
       push ax		; поставяме маркера в стека
       mov ax, 234d	; числото за извеждане
       mov CL, 10d	; делител на числото

labelDIV:
       mov ah, 00h
       div CL 		; AX/CL –> частното в AL, остатъка в AH
       push AX 		; запазване на остатъка в стека
       cmp AL, 0 		; проверка за нулево частно
       jne labelDIV

       mov ah, 02h

labelPRINT:
       pop DX
       cmp DX, 77h 	; проверка за край
       je ProgExit
       mov dl, dh
       add dl, 30h
       int 21h
       jmp labelPRINT

ProgExit:
       mov ax, 4c00h 
       int 21h
end 	main
