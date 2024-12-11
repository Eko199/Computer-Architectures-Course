code_seg 	segment
		assume cs: code_seg

m1:		mov ah, 01h		
		int 21h			 	
		jmp m1			
code_seg 	ends
end
