		RS EQU P1.3
		EN EQU P1.2

		ORG 0000H
		LJMP INICIO

		ORG 0010H
LINHA:
		DB "LINHA?"
  		DB 00h
COLUNA:
		DB "COLUNA?"
  		DB 00h
LINHA_INV:
		DB "LINHA"
  		DB 00h
COLUNA_INV:
		DB "COLUNA"
  		DB 00h
INVALIDA:
		DB "INVALIDA"
		DB 00H
ERROU:
		DB "ERROU!"
  		DB 00h
ACERTOU:
		DB "ACERTOU!"
  		DB 00h
JA:
		DB "JA"
  		DB 00h
ATINGIDO:
		DB "ATINGIDO"
  		DB 00h

		ORG 0100H
INICIO:
		ACALL TABULEIRO
		ACALL lcd_init

JOGO:
		ACALL clearDisplay
		MOV A, #05h
		ACALL posicionaCursor
		MOV DPTR,#LINHA    
		ACALL escreveStringROM
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
		ACALL clearDisplay
		SJMP PEDE_COLUNA
	LINHA_INVALIDA:
		ACALL clearDisplay
		MOV A, #05h
		ACALL posicionaCursor
		MOV DPTR,#LINHA_INV    
		ACALL escreveStringROM
		MOV A, #43h
		ACALL posicionaCursor
		MOV DPTR,#INVALIDA    
		ACALL escreveStringROM
		SJMP JOGO

PEDE_COLUNA:
		ACALL clearDisplay
		MOV A, #04h
		ACALL posicionaCursor
		MOV DPTR,#COLUNA    
		ACALL escreveStringROM	

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
		ACALL clearDisplay
		MOV A, #04h
		ACALL posicionaCursor
		MOV DPTR,#COLUNA_INV    
		ACALL escreveStringROM
		MOV A, #43h
		ACALL posicionaCursor
		MOV DPTR,#INVALIDA    
		ACALL escreveStringROM
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

		ACALL clearDisplay
		MOV A, #05h
		ACALL posicionaCursor
		MOV DPTR,#ERROU    
		ACALL escreveStringROM
		SJMP FIM_JOGADA
	ACERTO:
		CJNE A, #01H, JA_ATINGIDO
		MOV @R0, #03H ; 3 Tiro certo

		ACALL clearDisplay
		MOV A, #04h
		ACALL posicionaCursor
		MOV DPTR,#ACERTOU    
		ACALL escreveStringROM
		SJMP FIM_JOGADA
	JA_ATINGIDO:
		ACALL clearDisplay
		MOV A, #07h
		ACALL posicionaCursor
		MOV DPTR,#JA    
		ACALL escreveStringROM
		MOV A, #44h
		ACALL posicionaCursor
		MOV DPTR,#ATINGIDO    
		ACALL escreveStringROM 

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

escreveStringROM:
  PUSH 1
  MOV R1, #00h
	; Inicia a escrita da String no Display LCD
loop:
  MOV A, R1
	MOVC A,@A+DPTR 	 ;lê da memória de programa
	JZ finish		; if A is 0, then end of data has been reached - jump out of loop
	ACALL sendCharacter	; send data in A to LCD module
	INC R1			; point to next piece of data
   MOV A, R1
	JMP loop		; repeat
finish:
	POP 1
	RET
 
lcd_init:

	CLR RS		; clear RS - indicates that instructions are being sent to the module

; function set	
	CLR P1.7		; |
	CLR P1.6		; |
	SETB P1.5		; |
	CLR P1.4		; | high nibble set

	SETB EN		; |
	CLR EN		; | negative edge on E

	CALL delay		; wait for BF to clear	
					; function set sent for first time - tells module to go into 4-bit mode
; Why is function set high nibble sent twice? See 4-bit operation on pages 39 and 42 of HD44780.pdf.

	SETB EN		; |
	CLR EN		; | negative edge on E
					; same function set high nibble sent a second time

	SETB P1.7		; low nibble set (only P1.7 needed to be changed)

	SETB EN		; |
	CLR EN		; | negative edge on E
				; function set low nibble sent
	CALL delay		; wait for BF to clear


; entry mode set
; set to increment with no shift
	CLR P1.7		; |
	CLR P1.6		; |
	CLR P1.5		; |
	CLR P1.4		; | high nibble set

	SETB EN		; |
	CLR EN		; | negative edge on E

	SETB P1.6		; |
	SETB P1.5		; |low nibble set

	SETB EN		; |
	CLR EN		; | negative edge on E

	CALL delay		; wait for BF to clear


; display on/off control
; the display is turned on, the cursor is turned on and blinking is turned on
	CLR P1.7		; |
	CLR P1.6		; |
	CLR P1.5		; |
	CLR P1.4		; | high nibble set

	SETB EN		; |
	CLR EN		; | negative edge on E

	SETB P1.7		; |
	SETB P1.6		; |
	SETB P1.5		; |
	SETB P1.4		; | low nibble set

	SETB EN		; |
	CLR EN		; | negative edge on E

	CALL delay		; wait for BF to clear
	RET


sendCharacter:
	SETB RS  		; setb RS - indicates that data is being sent to module
	MOV C, ACC.7		; |
	MOV P1.7, C			; |
	MOV C, ACC.6		; |
	MOV P1.6, C			; |
	MOV C, ACC.5		; |
	MOV P1.5, C			; |
	MOV C, ACC.4		; |
	MOV P1.4, C			; | high nibble set

	SETB EN			; |
	CLR EN			; | negative edge on E

	MOV C, ACC.3		; |
	MOV P1.7, C			; |
	MOV C, ACC.2		; |
	MOV P1.6, C			; |
	MOV C, ACC.1		; |
	MOV P1.5, C			; |
	MOV C, ACC.0		; |
	MOV P1.4, C			; | low nibble set

	SETB EN			; |
	CLR EN			; | negative edge on E

	CALL delay			; wait for BF to clear
	CALL delay			; wait for BF to clear
	RET

;Posiciona o cursor na linha e coluna desejada.
;Escreva no Acumulador o valor de endereço da linha e coluna.
;|--------------------------------------------------------------------------------------|
;|linha 1 | 00 | 01 | 02 | 03 | 04 |05 | 06 | 07 | 08 | 09 |0A | 0B | 0C | 0D | 0E | 0F |
;|linha 2 | 40 | 41 | 42 | 43 | 44 |45 | 46 | 47 | 48 | 49 |4A | 4B | 4C | 4D | 4E | 4F |
;|--------------------------------------------------------------------------------------|
posicionaCursor:
	CLR RS	
	SETB P1.7		    ; |
	MOV C, ACC.6		; |
	MOV P1.6, C			; |
	MOV C, ACC.5		; |
	MOV P1.5, C			; |
	MOV C, ACC.4		; |
	MOV P1.4, C			; | high nibble set

	SETB EN			; |
	CLR EN			; | negative edge on E

	MOV C, ACC.3		; |
	MOV P1.7, C			; |
	MOV C, ACC.2		; |
	MOV P1.6, C			; |
	MOV C, ACC.1		; |
	MOV P1.5, C			; |
	MOV C, ACC.0		; |
	MOV P1.4, C			; | low nibble set

	SETB EN			; |
	CLR EN			; | negative edge on E

	CALL delay			; wait for BF to clear
	CALL delay			; wait for BF to clear
	RET


;Retorna o cursor para primeira posição sem limpar o display
retornaCursor:
	CLR RS	
	CLR P1.7		; |
	CLR P1.6		; |
	CLR P1.5		; |
	CLR P1.4		; | high nibble set

	SETB EN		; |
	CLR EN		; | negative edge on E

	CLR P1.7		; |
	CLR P1.6		; |
	SETB P1.5		; |
	SETB P1.4		; | low nibble set

	SETB EN		; |
	CLR EN		; | negative edge on E

	CALL delay		; wait for BF to clear
	RET


;Limpa o display
clearDisplay:
	CLR RS	
	CLR P1.7		; |
	CLR P1.6		; |
	CLR P1.5		; |
	CLR P1.4		; | high nibble set

	SETB EN		; |
	CLR EN		; | negative edge on E

	CLR P1.7		; |
	CLR P1.6		; |
	CLR P1.5		; |
	SETB P1.4		; | low nibble set

	SETB EN		; |
	CLR EN		; | negative edge on E

	MOV R4, #40
	rotC:
	CALL delay		; wait for BF to clear
	DJNZ R4, rotC
	RET


delay:
	MOV R0, #50
	DJNZ R0, $
	RET