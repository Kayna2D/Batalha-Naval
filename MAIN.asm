		ORG 0000H
		LJMP INICIO

		ORG 0100H
INICIO:
		ACALL TABULEIRO
		SJMP $


TABULEIRO:
		MOV R0, #020H  
   		MOV R1, #25

	ZERA_TABULEIRO:
    	MOV @R0, #0  ; 0 = água
    	INC R0           
    	DJNZ R1, ZERA_TABULEIRO

   		MOV 031H, #01 ; 1 = navio
 		MOV 022h, #0x01  
   		MOV 044h, #0x01
		RET  
