		ORG 0000H
		LJMP INICIO

		ORG 0100H
INICIO:
		ACALL TABULEIRO

JOGO:
		; Pedir linha
		MOV R6, #0FFH ; Linha
		MOV R7, #0FFH ; Coluna
		MOV A,#0FFH
		ACALL INPUT
		CJNE A, #0FFH, CHECK_LINHA
		SJMP JOGO

CHECK_LINHA:
		CLR C
		CJNE A,#5,TESTA_LINHA
		SJMP JOGO
	TESTA_LINHA:
		; A <= 5: C = 0
		JNC LINHA_INVALIDA
		MOV R6, A
		SJMP PEDE_COLUNA
	LINHA_INVALIDA:
		; Print linha invalida
		SJMP JOGO

PEDE_COLUNA:
		; Pedir coluna
		MOV A, #0FFH
		ACALL INPUT
		CJNE A, #0FFH, CHECK_COL
		SJMP PEDE_COLUNA
	CHECK_COL:
		CLR C
		MOV R3, A
		SUBB A, #5
		JC COL_INVALIDA
		MOV A, R3
		SUBB A, #5
		MOV R7, A
		SJMP JOGADA
	COL_INVALIDA:
		; Print coluna invalida
		SJMP PEDE_COLUNA

JOGADA:
		; L*10+20+COL=END
		MOV A, R6
		MOV B, #010H
		MUL AB
		ADD A, #020H
		ADD A, R7
		MOV R0, A

		MOV A, @R0
		CJNE A, #00H, ACERTO
		MOV @R0, #02H ; 2 = Tiro errado
		SJMP FIM_JOGADA
	ACERTO:
		CJNE A, #01H, JA_ATINGIDO
		MOV @R0, #03H ; 3 Tiro certo
		SJMP FIM_JOGADA
	JA_ATINGIDO:
		; Print návio já atingido 

	FIM_JOGADA:
		LJMP JOGO

TABULEIRO:
    	MOV 20H, #00H
    	MOV 21H, #00H
    	MOV 22H, #01H  ; Navio
    	MOV 23H, #00H
    	MOV 24H, #00H
    
    	MOV 30H, #00H
    	MOV 31H, #01H  ; Navio
    	MOV 32H, #00H
    	MOV 33H, #00H
    	MOV 34H, #00H
     
    	MOV 40H, #00H
   	 	MOV 41H, #00H	
    	MOV 42H, #00H
    	MOV 43H, #00H
    	MOV 44H, #01H  ; Navio
    
    	MOV 50H, #00H
    	MOV 51H, #00H
    	MOV 52H, #00H
    	MOV 53H, #01H  ; Navio
    	MOV 54H, #00H
    
    	MOV 60H, #01H  ; Navio
    	MOV 61H, #00H
    	MOV 62H, #00H
    	MOV 63H, #00H
    	MOV 64H, #00H
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
 
