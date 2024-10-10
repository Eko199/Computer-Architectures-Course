SSEG	SEGMENT	PARA    STACK   'Stack'    ;      (EXE)  
          		DW      32      	DUP('S')                         
  SSEG    	ENDS                                             
  ;===================  ==================  
  DSEG    	SEGMENT 	PARA 	'Data'                           
  STR1    	DB	20H,71H,'E',0F4H,'s',71H,'c',71H,'a',71H 
  STR2    	DB      	'p',71H,'e',71H,'!',74H,20H,71H          
  DSEG   	ENDS                                              
  ;====================    =================  
  CSEG    	SEGMENT 	PARA	'Code'                           
  MAIN    	PROC    	FAR                                      
          	ASSUME  	CS:CSEG,DS:DSEG,SS:SSEG,ES:DSEG          
          	PUSH 	DS		
 		XOR 	AX,AX 		
          	PUSH 	AX          	
          	MOV    AX,DSEG  	     
          	MOV    DS,AX    	      
          	MOV    ES,AX    	
;---------------------------------------------------------                               
          		MOV     AL,03H                                   
          		CALL    INITSCR                                  
          		MOV     DH,0AH       ;R 10                            
          		MOV     DL,23H       ;C 35                            
          		CALL    OUTWORD                                  
          		MOV     BL,1BH      ;code ESC                             
          		CALL    WAITKBD                                  
          		RET
			
                                              
  MAIN    	ENDP                                             
  ;------------------------------------------------------- 
  INITSCR 	PROC                                             
          		MOV AH,00H                                   
          		INT 10H                                      
          		RET                                              
  INITSCR 	ENDP                                             
  ;--------------------------------------------------------
  OUTWORD 	PROC                                             
          		MOV AX,1303H                                 
          		LEA BP,STR1	;  STR1  -> ES:BP          
          		MOV CX,09H                                   
          		INT   	10H                                      
          		RET                                              
  OUTWORD 	ENDP                                             
  ;------------------------------------------------------- 
  WAITKBD 	PROC                                             
  CKL:    	MOV   AH,0                                     
          	INT 16H                                      
          	CMP AL,BL           ;BL = 27                         
          	JNE CKL                                      
          	RET                                              
  WAITKBD 	ENDP                                             
  CSEG    	ENDS                                             
          END     	MAIN		
