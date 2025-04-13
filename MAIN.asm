		ORG 0000H
		LJMP INICIO

		ORG 0100H
INICIO:
		ACALL TABULEIRO
MONTADO:
		MOV A,#0FFH
		ACALL INPUT
		MOV R5,A
		SJMP MONTADO


TABULEIRO:
		MOV R0, #020H  
   		MOV R1, #25

	ZERA_TABULEIRO:
    	MOV @R0, #0  ; 0 = agua
    	INC R0           
    	DJNZ R1, ZERA_TABULEIRO

   		MOV 031H, #01 ; 1 = navio
 		MOV 022h, #0x01  
   		MOV 044h, #0x01
		RET 



INPUT:
		   		PUSH 0
		   		PUSH 1
		   		PUSH 2
          
				MOV R0, #0 
				MOV R1, #0CH
				MOV R2, #0

				SETB P0.3
				CLR P0.0 
				CALL colScan2 

				SETB P0.0 
				CLR P0.1 
				CALL colScan 

				SETB P0.1 
				CLR P0.2 
         		CALL colScan 

				SETB P0.2 
				CLR P0.3 
				CALL colScan 
				CJNE R0,#0CH,SAI
          MOV A,#0FFH
SAI:
				POP 0
				POP 1
				POP 2
				RET
          
          colScan:
				JNB P0.4, gotKey ; if col0 is cleared - key found
				INC R0 ; otherwise move to next key
				DEC R1
				JNB P0.5, gotKey ; if col1 is cleared - key found
				INC R0 ; otherwise move to next key
				DEC R1
				JNB P0.6, gotKey ; if col2 is cleared - key found
				INC R0 ; otherwise move to next key
				DEC R1
				RET ; return from subroutine - key not found
gotKey:
				MOV A,R1
				RET  

		colScan2:
				JNB P0.5, gotKey2 
				INC R0	
				MOV R2, #0BH
				DEC R1
				JNB P0.4, gotKey2
				INC R0
				DEC R1
				MOV R2, #0AH
				JNB P0.6, gotKey2 
				INC R0 
				DEC R1
				RET 

gotKey2:
				MOV A,R2
				RET  
 
