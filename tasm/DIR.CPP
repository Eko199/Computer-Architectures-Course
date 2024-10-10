#include <stdlib.h>
#include <conio.h>
#include <stdio.h>

void main()
{
switch(system("dir")){
	case -1: printf("FAILED.");break;
	case 0: printf("YEAH!");
        }
getch();
}