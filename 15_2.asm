SG SEGMENT PARA
	ASSUME CS:SG,DS:SG,ES:SG,SS:SG                 
	ORG	100H 
                                                            
BEGIN: 
	JMP   	MAIN 
;--------------------------------------------------------- 
STR1    DB      20H,71H,'E',0F4H,'s',71H,'c',71H,'a',71H    
STR2    DB      'p',71H,'e',71H,'!',74H,20H,71H            
;--------------------------------------------------------- 
MAIN PROC NEAR
	MOV	AL,03H
	CALL	INITSCR
	MOV	DH,0AH
	MOV	DL,23H
	CALL	OUTWORD
	MOV	BL,1BH
	CALL	WAITKBD
	INT	20H
MAIN ENDP
;--------------------------------------------------------- 
INITSCR	PROC NEAR
		MOV AH,00H
		INT 10H
		RET
INITSCR	ENDP
;----------------------------------------------------------
OUTWORD	PROC NEAR
		MOV AX,1303H
		LEA BP,STR1
		MOV CX,09H
		INT 10H
		RET
OUTWORD	ENDP
;----------------------------------------------------------
WAITKBD	PROC NEAR
CKL:		MOV AH,0 
		INT 16H
		CMP AL,BL
		JNE CKL
		RET
WAITKBD	ENDP
;----------------------------------------------------------
SG		ENDS
;==========================================
		END	BEGIN
