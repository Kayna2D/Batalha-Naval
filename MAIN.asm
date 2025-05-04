		RS EQU P1.3
		EN EQU P1.2

		ORG 0000H
		LJMP INICIO

		ORG 0100H
INICIO:
		ACALL TABULEIRO
		ACALL lcd_init

PRINT_LINHA:
		MOV A, #05H
		ACALL posicionaCursor 
		MOV A, #'L'
		ACALL sendCharacter	
		MOV A, #'I'
		ACALL sendCharacter	
		MOV A, #'N'
		ACALL sendCharacter	
		MOV A, #'H'
		ACALL sendCharacter	
		MOV A, #'A'
		ACALL sendCharacter	
		MOV A, #'?'
		ACALL sendCharacter	
		ACALL retornaCursor

JOGO:
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
		SJMP PRINT_COLUNA
	LINHA_INVALIDA:
		; Print linha invalida
		SJMP JOGO

PRINT_COLUNA:
		MOV A, #04H
		ACALL posicionaCursor 
		MOV A, #'C'
		ACALL sendCharacter	
		MOV A, #'O'
		ACALL sendCharacter	
		MOV A, #'L'
		ACALL sendCharacter	
		MOV A, #'U'
		ACALL sendCharacter	
		MOV A, #'N'
		ACALL sendCharacter	
		MOV A, #'A'
		ACALL sendCharacter	
		ACALL retornaCursor		

PEDE_COLUNA:
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
		; print errou
		SJMP FIM_JOGADA
	ACERTO:
		CJNE A, #01H, JA_ATINGIDO
		MOV @R0, #03H ; 3 Tiro certo
		; print acerou
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

lcd_init:

	CLR RS	
	
	CLR P1.7		
	CLR P1.6
	SETB P1.5
	CLR P1.4	

	SETB EN
	CLR EN	

	CALL delay 	

	SETB EN		
	CLR EN		

	SETB P1.7	

	SETB EN		
	CLR EN		
	CALL delay	

	CLR P1.7		
	CLR P1.6		
	CLR P1.5		
	CLR P1.4		

	SETB EN		
	CLR EN		

	SETB P1.6	
	SETB P1.5	

	SETB EN		
	CLR EN		

	CALL delay	

	CLR P1.7		
	CLR P1.6		
	CLR P1.5		
	CLR P1.4		

	SETB EN		
	CLR EN		

	SETB P1.7		
	SETB P1.6		
	SETB P1.5		
	SETB P1.4		

	SETB EN		
	CLR EN		

	CALL delay		
	RET
 
sendCharacter:
	SETB RS  		
	MOV C, ACC.7		
	MOV P1.7, C			
	MOV C, ACC.6		
	MOV P1.6, C			
	MOV C, ACC.5		
	MOV P1.5, C			
	MOV C, ACC.4		
	MOV P1.4, C			

	SETB EN			
	CLR EN			

	MOV C, ACC.3		
	MOV P1.7, C			
	MOV C, ACC.2		
	MOV P1.6, C			
	MOV C, ACC.1		
	MOV P1.5, C			
	MOV C, ACC.0		
	MOV P1.4, C			

	SETB EN			
	CLR EN			

	CALL delay		
	RET

;|--------------------------------------------------------------------------------------|
;|linha 1 | 00 | 01 | 02 | 03 | 04 |05 | 06 | 07 | 08 | 09 |0A | 0B | 0C | 0D | 0E | 0F |
;|linha 2 | 40 | 41 | 42 | 43 | 44 |45 | 46 | 47 | 48 | 49 |4A | 4B | 4C | 4D | 4E | 4F |
;|--------------------------------------------------------------------------------------|
posicionaCursor:
	CLR RS	        
	SETB P1.7		    
	MOV C, ACC.6		
	MOV P1.6, C			
	MOV C, ACC.5		
	MOV P1.5, C			
	MOV C, ACC.4		
	MOV P1.4, C			

	SETB EN			
	CLR EN			

	MOV C, ACC.3		
	MOV P1.7, C			
	MOV C, ACC.2		
	MOV P1.6, C			
	MOV C, ACC.1		
	MOV P1.5, C			
	MOV C, ACC.0		
	MOV P1.4, C			

	SETB EN			
	CLR EN			

	CALL delay			
	RET 

retornaCursor:
	CLR RS	      
	CLR P1.7		
	CLR P1.6		
	CLR P1.5		
	CLR P1.4		

	SETB EN		
	CLR EN		

	CLR P1.7		
	CLR P1.6		
	SETB P1.5		
	SETB P1.4		

	SETB EN		
	CLR EN		

	CALL delay		
	RET

clearDisplay:
	CLR RS	      
	CLR P1.7		
	CLR P1.6		
	CLR P1.5		
	CLR P1.4		

	SETB EN		
	CLR EN		

	CLR P1.7		
	CLR P1.6		
	CLR P1.5		
	SETB P1.4		

	SETB EN		
	CLR EN		

	CALL delay		
	RET

delay:
	MOV R0, #50
	DJNZ R0, $
	RET
