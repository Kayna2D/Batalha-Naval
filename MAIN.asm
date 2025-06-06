		RS EQU P1.3
		EN EQU P1.2

		ORG 0000H
		LJMP INICIO

		ORG 0F00H

; Armazenamento de Strings
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
REPETIDO:
		DB "TIRO REPETIDO"
  		DB 00h
BEMVINDO:
		DB "BEM-VINDO A"
		DB 00h
TITULO:
		DB "BATALHA NAVAL"
		DB 00h
JOGUE:
		DB "JOGUE EM UM"
		DB 00h
TAB:
		DB "TABULEIRO 5x5"
		DB 00h

TECLE1:
		DB "DIGITE ENTRE 0-4"
		DB 00h
DEF_LINHA:
		DB "P/ DEFINIR LINHA"
		DB 00h
TECLE2:
		DB "DIGITE ENTRE 5-9"
		DB 00h
DEF_COLUNA:
		DB "P/ DEFINIR COL"
		DB 00h
VENCE:
		DB "VENCE AQUELE QUE"
		DB 00h
PONTOS:
		DB "FIZER 3 PONTOS"
		DB 	00h
COORD:
		DB "COORDENADA"
		DB 00h
ABRE:      
		DB "("
		DB 00h
VIRGULA:   
		DB ","
		DB 00h
FECHA:      
		DB ")"
		DB 00h

VEZ_JOG1:      
		DB "VEZ DO JOGADOR 1"
		DB 00h
VEZ_JOG2:      
		DB "VEZ DO JOGADOR 2"
		DB 00h
PONTUACAO:      
		DB "PONTOS~"
		DB 00h
JOGADOR_1:
		DB "JOGADOR 1"
		DB 00h
JOGADOR_2:
		DB "JOGADOR 2"
		DB 00h
VENCEU:
		DB "VENCEU!"
		DB 00h

; Armazenamento de var�veis
		ORG 070H
JOGADOR:	DB 1 ; controla vez do jogador
PONTOS_J1:	DB 0
PONTOS_J2:	DB 0
NAVIOS:		DB 5

		ORG 0100H
; Inicializa tabuleiro e display
INICIO:
		ACALL lcd_init  
NOVO_JOGO:
		ACALL TABULEIRO

; Mostra mensagem de introdu��o 
; no display
INTRODUCAO:
		ACALL clearDisplay
		MOV A, #03h
		ACALL posicionaCursor
		MOV DPTR,#BEMVINDO    
		ACALL escreveStringROM
		MOV A, #42h
		ACALL posicionaCursor
		MOV DPTR,#TITULO    
		ACALL escreveStringROM
		ACALL DELAY_2S

		ACALL clearDisplay
		MOV A, #02h
		ACALL posicionaCursor
		MOV DPTR,#JOGUE    
		ACALL escreveStringROM
		MOV A, #41h
		ACALL posicionaCursor
		MOV DPTR,#TAB    
		ACALL escreveStringROM
		ACALL DELAY_2S

		ACALL clearDisplay
		MOV A, #00h
		ACALL posicionaCursor
		MOV DPTR,#TECLE1    
		ACALL escreveStringROM
		MOV A, #40h
		ACALL posicionaCursor
		MOV DPTR,#DEF_LINHA
		ACALL escreveStringROM
		ACALL DELAY_2S

		ACALL clearDisplay
		MOV A, #00h
		ACALL posicionaCursor
		MOV DPTR,#TECLE2    
		ACALL escreveStringROM
		MOV A, #41h
		ACALL posicionaCursor
		MOV DPTR,#DEF_COLUNA    
		ACALL escreveStringROM
		ACALL DELAY_2S

		ACALL clearDisplay
		MOV A, #00h
		ACALL posicionaCursor
		MOV DPTR,#VENCE    
		ACALL escreveStringROM
		MOV A, #41h
		ACALL posicionaCursor
		MOV DPTR,#PONTOS    
		ACALL escreveStringROM
		ACALL DELAY_2S


VEZ:
		ACALL MOSTRA_VEZ ; Mostra de quem � a vez
		ACALL DELAY_2S


JOGO:
		ACALL clearDisplay
		MOV A, #05h
		ACALL posicionaCursor
		MOV DPTR,#LINHA    
		ACALL escreveStringROM
		ACALL DELAY_2S
		MOV R6, #0FFH ; Linha
		MOV R7, #0FFH ; Coluna
		MOV A,#0FFH
		ACALL INPUT
		CJNE A, #0FFH, CHECK_LINHA ; Checa se algo foi digitado
		SJMP JOGO

CHECK_LINHA:
		CLR C
		CJNE A,#5,TESTA_LINHA
		SJMP JOGO
	TESTA_LINHA:
		; A <= 5: C = 0
		JNC LINHA_INVALIDA
		MOV R6, A ; Guarda 1-4
		ACALL clearDisplay
		SJMP PEDE_COLUNA
	LINHA_INVALIDA: ; Mensagem para linha >= 5
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
		ACALL DELAY_2S

		MOV A, #0FFH
		ACALL INPUT
		CJNE A, #0FFH, CHECK_COL
		SJMP PEDE_COLUNA
	CHECK_COL:
		CLR C
		MOV R3, A
		SUBB A, #5
		JC COL_INVALIDA ; Checa se coluna < 5
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
		; L*10+20+(COL-5)=ENDERECO
		MOV A, R6
		MOV B, #010H
		MUL AB
		ADD A, #020H
		ADD A, R7
		MOV R0, A

		MOV A, @R0
		CJNE A, #00H, ACERTO ; Checa se o tiro foi na �gua
		MOV @R0, #02H ; 2 = Tiro errado

		ACALL clearDisplay
		MOV A, #05h
		ACALL posicionaCursor
		MOV DPTR,#ERROU    
		ACALL escreveStringROM
		MOV A, #40h
		ACALL posicionaCursor
		MOV DPTR,#COORD    
		ACALL escreveStringROM
		MOV A, #4Bh
		ACALL posicionaCursor
		ACALL MOSTRA_COORD
		ACALL DELAY_2S
		ACALL ALTERNA_JOGADOR
		SJMP FIM_JOGADA
	ACERTO:
		CJNE A, #01H, JA_ATINGIDO ; Verifica se o navio ja foi atingido
		MOV @R0, #03H ; 3 Tiro certo

		; Incremento de pontos
		MOV A, JOGADOR
		CJNE A,#1,PONTO_J2
		MOV A, PONTOS_J1
		INC A
		MOV PONTOS_J1, A
		SJMP CHECK_VITORIA
	PONTO_J2:
		MOV A, PONTOS_J2
		INC A
		MOV PONTOS_J2, A
	; Verifica se algum jogador chegou a 3 pontos
	CHECK_VITORIA:
		MOV A, PONTOS_J1
		CJNE A, #03H, VERIFICA_J2
		LJMP VITORIA
	VERIFICA_J2:
		MOV A, PONTOS_J2
		CJNE A, #03H, CONTINUA_JOGO
		LJMP VITORIA

	CONTINUA_JOGO:
		ACALL clearDisplay
		MOV A, #04h
		ACALL posicionaCursor
		MOV DPTR,#ACERTOU    
		ACALL escreveStringROM
		MOV A, #40h
		ACALL posicionaCursor
		MOV DPTR,#COORD    
		ACALL escreveStringROM
		MOV A, #4Bh
		ACALL posicionaCursor
		ACALL MOSTRA_COORD
		ACALL DELAY_2S
		ACALL ALTERNA_JOGADOR
		SJMP FIM_JOGADA
	JA_ATINGIDO:
		ACALL clearDisplay
		MOV A, #02h
		ACALL posicionaCursor
		MOV DPTR,#REPETIDO    
		ACALL escreveStringROM
		MOV A, #40h
		ACALL posicionaCursor
		MOV DPTR,#COORD    
		ACALL escreveStringROM
		MOV A, #4Bh
		ACALL posicionaCursor
		ACALL MOSTRA_COORD
		ACALL DELAY_2S 
		LJMP JOGO

	FIM_JOGADA:
		LJMP VEZ

VITORIA:
		ACALL clearDisplay
		MOV A, #03h
		ACALL  posicionaCursor

		MOV A, JOGADOR
		CJNE A, #1, VITORIA_J2
		MOV DPTR,#JOGADOR_1
		SJMP MOSTRA_VITORIA
	VITORIA_J2:
		MOV DPTR, #JOGADOR_2

	MOSTRA_VITORIA:
		ACALL escreveStringROM
		MOV A, #44h
		ACALL posicionaCursor
		MOV DPTR, #VENCEU
		ACALL escreveStringROM	
		ACALL DELAY_2S

		LJMP NOVO_JOGO ; Reinicia o jogo

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

		MOV 70H, #01H
		MOV 71H, #00H
		MOV 72H, #00H		
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
	MOVC A,@A+DPTR 	 ;l� da mem�ria de programa
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
;Escreva no Acumulador o valor de endere�o da linha e coluna.
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


;Retorna o cursor para primeira posi��o sem limpar o display
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

DELAY_2S:           
    PUSH 0
    PUSH 1
    MOV R0, #5    
DELAY_2S_LOOP:
    MOV R1, #250    
    DJNZ R1, $      
    DJNZ R0, DELAY_2S_LOOP
    POP 1
    POP 0
    RET

MOSTRA_NUM:
		ADD A, #'0'
		ACALL sendCharacter
		RET

MOSTRA_COORD:
		MOV DPTR, #ABRE
		ACALL escreveStringROM

		MOV A, R6
		ACALL MOSTRA_NUM

		MOV DPTR, #VIRGULA
		ACALL escreveStringROM

		MOV A, R7
		ADDC A, #5
		ACALL MOSTRA_NUM

		MOV DPTR, #FECHA
		ACALL escreveStringROM
		RET

ALTERNA_JOGADOR:
		MOV A, JOGADOR
		CJNE A, #1, SETJOG1
		MOV JOGADOR, #2
		RET
	SETJOG1:
		MOV JOGADOR, #1
		RET

MOSTRA_VEZ:
		ACALL clearDisplay
		MOV A, #00h
		ACALL posicionaCursor
		
		MOV A, JOGADOR
		CJNE A, #1, JOG2
		MOV DPTR, #VEZ_JOG1 
		SJMP MOSTRA_PONTOS
	JOG2:
		MOV DPTR, #VEZ_JOG2
	MOSTRA_PONTOS:
		ACALL escreveStringROM	
		MOV A, #44
		ACALL posicionaCursor
		MOV DPTR, #PONTUACAO
		ACALL escreveStringROM

		MOV A, JOGADOR
		CJNE A, #1, J2
		MOV A, PONTOS_J1
		SJMP MOSTRA_NUMERO
	J2:
		MOV A, PONTOS_J2

	MOSTRA_NUMERO:
		ACALL MOSTRA_NUM
		RET		
