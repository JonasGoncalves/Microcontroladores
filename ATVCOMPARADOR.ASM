;   >>>>>>>>>>>>>>>>>> RESISTORES: 1K E 2K2 <<<<<<<<<<<<<<<<
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICA��ES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                    FEVEREIRO DE 2016                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       NOME DO PROJETO                           *
;*                           CLIENTE                               *
;*         DESENVOLVIDO PELA MOSAICO ENGENHARIA E CONSULTORIA      *
;*   VERS�O: 1.0                           DATA: 17/06/03          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     DESCRI��O DO ARQUIVO                        *
;*-----------------------------------------------------------------*
;*   MODELO PARA O PIC 12F675                                      *
;*                                                                 *
;*                                                                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINI��ES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <p12f675.inc>	;ARQUIVO PADR�O MICROCHIP PARA 12F675

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_ON & _INTRC_OSC_NOCLKOUT

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    PAGINA��O DE MEM�RIA                         *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;DEFINI��O DE COMANDOS DE USU�RIO PARA ALTERA��O DA P�GINA DE MEM�RIA
#DEFINE	BANK0	BCF STATUS,RP0	;SETA BANK 0 DE MEM�RIA
#DEFINE	BANK1	BSF STATUS,RP0	;SETA BANK 1 DE MAM�RIA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         VARI�VEIS                               *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DOS NOMES E ENDERE�OS DE TODAS AS VARI�VEIS UTILIZADAS 
; PELO SISTEMA

	CBLOCK	0x20	;ENDERE�O INICIAL DA MEM�RIA DE
					;USU�RIO
		W_TEMP		;REGISTRADORES TEMPOR�RIOS PARA USO
		STATUS_TEMP	;JUNTO �S INTERRUP��ES

		;NOVAS VARI�VEIS

	ENDC			;FIM DO BLOCO DE MEM�RIA
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           ENTRADAS                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS PINOS QUE SER�O UTILIZADOS COMO ENTRADA
; RECOMENDAMOS TAMB�M COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           SA�DAS                                *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS PINOS QUE SER�O UTILIZADOS COMO SA�DA
; RECOMENDAMOS TAMB�M COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       VETOR DE RESET                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	ORG	0x00			;ENDERE�O INICIAL DE PROCESSAMENTO
	GOTO	INICIO
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    IN�CIO DA INTERRUP��O                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; ENDERE�O DE DESVIO DAS INTERRUP��ES. A PRIMEIRA TAREFA � SALVAR OS
; VALORES DE "W" E "STATUS" PARA RECUPERA��O FUTURA

	ORG	0x04			;ENDERE�O INICIAL DA INTERRUP��O
	MOVWF	W_TEMP		;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP	;COPIA STATUS PARA STATUS_TEMP

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUP��O                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; AQUI SER� ESCRITA AS ROTINAS DE RECONHECIMENTO E TRATAMENTO DAS
; INTERRUP��ES

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                 ROTINA DE SA�DA DA INTERRUP��O                  *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; OS VALORES DE "W" E "STATUS" DEVEM SER RECUPERADOS ANTES DE 
; RETORNAR DA INTERRUP��O

SAI_INT
	SWAPF	STATUS_TEMP,W
	MOVWF	STATUS		;MOVE STATUS_TEMP PARA STATUS
	SWAPF	W_TEMP,F
	SWAPF	W_TEMP,W	;MOVE W_TEMP PARA W
	RETFIE

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*	            	 ROTINAS E SUBROTINAS                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; CADA ROTINA OU SUBROTINA DEVE POSSUIR A DESCRI��O DE FUNCIONAMENTO
; E UM NOME COERENTE �S SUAS FUN��ES.

SUBROTINA1

	;CORPO DA ROTINA

	RETURN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00000010' ;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SA�DAS
	MOVLW	B'00010010'
	MOVWF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000100'
	MOVWF	OPTION_REG	;DEFINE OP��ES DE OPERA��O
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OP��ES DE INTERRUP��ES
	
	
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00000100'
	MOVWF	CMCON		;DEFINE O MODO DE OPERA��O DO COMPARADOR ANAL�GICO
	MOVLW	B'00000000'
	CLRF	GPIO
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZA��O DAS VARI�VEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN
	; OS RESISTORES UTILIZADOS FORAM: 1K E 2K2.
	; CODIGO USANDO O COMPARADOR QUE IR� PEGAR UMA TENSAO NA ENTRADA GP1
	; E COMPARAR COM UMA TENS�O DE REFERENCIA QUE SER� CONSTATEMENTE ALTERADA
	; PARA ENCONTRAR EM QUAL INTERVALO A TENS�O SE ENCONTRA E MANDAR UMA INDI-
	;CA��O PARA UM LCD.
	
COMP1
	BANK1	; NECESSARIO FAZER A INDICA��O DE QUAIS BANCOS EST�O SENDO USADOS
	MOVLW	B'10100010' ; AQUI EST� SENDO ATIVADO E DEFINIDO UMA TENS�O DE
	MOVWF	VRCON	; REFERENCIA QUE SER� COMPARADO COM A GP1.VREF = 0,41V.
	BANK0	; COMO IR� USAR UM REGISTRADOR DO BANCO 0, � NECESSARIO INDICAR.
	BTFSC	CMCON,COUT ; EST� SENDO FEITO A VERIFICA��O DO BIT COUT PARA SABER
	GOTO	DISP0 ; O RESULTADO DA COMPARAC�O, E PULAR PARA O CAMINHO INDICADO.

	;SE A COMPARACAO INDICAR QUE O VREF � MAIOR QUE O DA GP1, O CODIGO IR� 
	;PARA UMA LABEL QUE SETA O VALOR A SER MOSTRADO NO DISPLAY, SE A GP1
	;FOR MAIOR, O CODIGO CONTINUAR�, E AS COMPARA��ES TAMBEM, ATE UM INTERVALO
	;SER ENCONTRADO E SETAR O DISPLAY.
	
	;� NECESSARIO DEZ COMPARACOES, COMO INDICADO NAS ESPECIFICA��ES, ENT�O
	;AS PROXIMAS LINHAS DO PROGRAMA BASICAMENTE SE REPETEM, ALTERANDO APENAS
	; AS TENS�ES DE REFERENCIA E QUAL VALOR SERA ENVIADO PARA O DISPLAY.
COMP2
	BANK1
	MOVLW	B'10100011' ;VREF = 0,62V
	MOVWF	VRCON
	BANK0
	BTFSC	CMCON,COUT
	GOTO	DISP1
COMP3
	BANK1
	MOVLW	B'10100101' ;VREF = 1,04V
	MOVWF	VRCON
	BANK0
	BTFSC	CMCON,COUT
	GOTO	DISP2
COMP4
	
	BANK1
	MOVLW	B'10000001' ;VREF = 1,4V
	MOVWF	VRCON
	BANK0
	BTFSC	CMCON,COUT
	GOTO	DISP3
	
COMP5
	BANK1
	MOVLW	B'10000011' ;VREF = 1,71V
	MOVWF	VRCON
	BANK0
	BTFSC	CMCON,COUT
	GOTO	DISP4

COMP6
	BANK1
	MOVLW	B'10000101' ;VREF = 2V
	MOVWF	VRCON
	BANK0
	BTFSC	CMCON,COUT
	GOTO	DISP5

COMP7
	BANK1
	MOVLW	B'10000111'; VREF = 2,34V
	MOVWF	VRCON
	BANK0
	BTFSC	CMCON,COUT
	GOTO	DISP6

COMP8
	BANK1
	MOVLW	B'10101101' ;VREF = 2,7V
	MOVWF	VRCON
	BANK0
	BTFSC	CMCON,COUT
	GOTO	DISP7

COMP9
	BANK1
	MOVLW	B'10001100' ;VREF = 3,125V
	MOVWF	VRCON
	BANK0
	BTFSC	CMCON,COUT
	GOTO	DISP8	

COMP10
	BANK1
	MOVLW	B'10001110' ;VREF = 3,43V
	MOVWF	VRCON
	BANK0
	BTFSC	CMCON,COUT
	GOTO	DISP9
	GOTO	MAIN

; AS LABELS SEGUINTES ESCREVEM UM VALOR EM BINARIO NA SAIDA, E VOLTAM PARA
; O COME�O DO CODIGO PARA NOVAS COMPARA��ES.
	
DISP0
	MOVLW	B'00000000' ;ESCREVE 0000 NO LCD.
	MOVWF	GPIO
	GOTO	MAIN

DISP1
	MOVLW	B'00000001' ;ESCREVE 0001 NO LCD.
	MOVWF	GPIO
	GOTO	MAIN
	
DISP2
	MOVLW	B'00000100' ;ESCREVE 0010 NO LCD.
	MOVWF	GPIO
	GOTO	MAIN

DISP3
	MOVLW	B'00000101' ;ESCREVE 0011 NO LCD.
	MOVWF	GPIO
	GOTO	MAIN

DISP4
	MOVLW	B'00010000' ;ESCREVE 0100 NO LCD.
	MOVWF	GPIO
	GOTO	MAIN

DISP5
	MOVLW	B'00010001' ;ESCREVE 0101 NO LCD.
	MOVWF	GPIO
	GOTO	MAIN

DISP6
	MOVLW	B'00010100' ;ESCREVE 0110 NO LCD.
	MOVWF	GPIO
	GOTO	MAIN
	
DISP7
	MOVLW	B'00010101' ;ESCREVE 0111 NO LCD.
	MOVWF	GPIO
	GOTO	MAIN
	
DISP8
	MOVLW	B'00100000' ;ESCREVE 1000 NO LCD.
	MOVWF	GPIO
	GOTO	MAIN
	
DISP9
	MOVLW	B'00100001' ;ESCREVE 1001 NO LCD.
	MOVWF	GPIO
	GOTO	MAIN

FIM
	GOTO FIM
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
