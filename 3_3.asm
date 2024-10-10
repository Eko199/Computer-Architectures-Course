Code segment
     assume cs:Code, ds:Data
begin:
       mov  ax, Data            ;Инициализация  на сегмента с данни
       mov  ds, ax

       mov  ah, 09h             ;Установяване номера на функцията
       mov  dx, offset var      ;Установяване стойността на аргумента
       int  21h                 ;Обръщение към MS DOS (функция 09h)

       mov  ah, 4Ch             ;Изход в MS DOS
       int  21h

Code ends
Data segment
     var db 'Hello, World!!!$',13,10;текст за извеждане

Data ends
Stk    segment   stack
       dw   100 dup(?)          ;Памет за стека
Stk    ends
end    begin
