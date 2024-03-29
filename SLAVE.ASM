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
		O_DADO
		COUNT
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
	MOVLW	B'00000011' ;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SA�DAS
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000111'
	MOVWF	OPTION_REG	;DEFINE OP��ES DE OPERA��O
	MOVLW	B'10000000'
	MOVWF	INTCON		;DEFINE OP��ES DE INTERRUP��ES
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERA��O DO COMPARADOR ANAL�GICO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZA��O DAS VARI�VEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN
	
	MOVLW	.0  ;INICIA O CONTADOR EM 0
	MOVWF	COUNT

START_BIT
	
	BTFSC	GPIO,GP1    ;ESSE BLOCO SE TRATA DA ANALISE DO START SEQUENCE
	GOTO	START_BIT   ; QUE DIR� SE O RECEBIMENTO DE DADO PODE COME�AR
	BTFSS	GPIO,GP0    ; VERIFICA SE O SDA EST� INDO PARA 0, E DEPOIS SE
	GOTO	START_BIT   ;SCL EST� EM ALTA, ASSIM PODE COME�AR A TRANSMISS�O

VERIFICA0
	BTFSC	GPIO,GP0    ;DEPOIS DO START BIT, � NECESS�RIO VERIFICAR SE O
	GOTO	VERIFICA0   ;CLOCK FOI PRA BAIXO

SCL
	BTFSS	GPIO,GP0    ;E DEPOIS VERIRIFICAR SE ELE SUBIU PARA RECEBER O
	GOTO	SCL	    ; PRIMEIRO BIT DE DADO
	
	INCF	COUNT,1	    ;O CONTADOR SERA INCREMENTADO A CADA DADO RECEBIDO
	BTFSS	GPIO,GP1    ;AGORA � VERIFICADO SE O DADO � 0 OU 1
	GOTO	BIT_0	    ;SE FOR 0, IR� PRA O TRATAMENTO PARA DEPOSITAR 0
	GOTO	BIT_1	    ;CASO SEJA 1, IRA TRATAR ESTE CASO.

BIT_0
	BCF	STATUS,C    ;QUANDO � ZERO, � PRECISO ZERAR O CARRY, PARA QUE
	RLF	O_DADO,1    ;ESSE SEJA O VALOR COLOCADO PELA INSTRU��O DE DESLOC
AGUARDA			    ;CAMENTO, DE FORMA QUE COLOCA NO LSB E VAI DESLOCANDO
	BTFSC	GPIO,GP0    ;AGUARDA O CLOCK DESCER PARA PODER FAZER A COMPARACAO
	GOTO	AGUARDA	    ;FICA EM LOOP
	MOVLW	.8	    ; COMPARA SE JA HOUVE 8 PULSOS DE CLOCK QUE � QUANTI 
	SUBWF	COUNT,0	    ;DADE QUE SE DEVE PARAR PARA ANALISAR O ENDERE�O
	BTFSS	STATUS,Z    ;SE FOI O OITAVO PULSO, SERA FEITO UMA VERIFICA��O
	GOTO	SCL	    ;SE O ENDERE�O DIZ RESPEITO AO MEU SLAVE, SE N�O FOR
	GOTO	SOU_EU	    ;O OITAVO, VOLTA PARA RECEBER O PROXIMO BIT.

BIT_1
	BSF	STATUS,C    ;ESSE BLOCO � IGUAL AO ANTEIROR, TENDO COMO DIFEREN�A
	RLF	O_DADO,1    ;QUE O VALOR COLOCADO NA VARIAVEL � 1 EM VEZ DE ZERO.
AGUARDA2
	BTFSC	GPIO,GP0
	GOTO	AGUARDA2
	MOVLW	.8
	SUBWF	COUNT,0
	BTFSS	STATUS,Z
	GOTO	SCL
	GOTO	SOU_EU
	
SOU_EU
	BCF	STATUS,C    ;NESSE BLOCO SER� VERIFICADO SE OS 7 PRIMEIROS BITS
	RRF	O_DADO,0    ;DIZEM RESPEITO AO MEU SLAVE, POR ISSO � DESLOCADO
	SUBLW	.23	    ; UM BIT PRA DIREITA PARA PEGAR APENAS OS 7 PRIMEIROS
	BTFSS	STATUS,Z    ; BITS, SE FOR EU IRA PARA O SINAL ACK, SE N�O, VOLTA
	GOTO	MAIN	    ;R� PARA O COME�O DO CODIGO
	GOTO	ACK

ACK
	BANK1
	MOVLW	B'00000001' ; SE FOR EU, SERA MANDADO UM SINAL ACK, ENT�O EH NEC
	MOVWF	TRISIO	    ;ESSARIO TORNAR A GP1 SAIDA, E MANDAR O SINAL EM BAIXO
	BCF	GPIO,GP1
AGUARDA3
	BANK0
	BTFSS	GPIO,GP0    ;FAZ DUAS VERIFICA��ES ESPERANDO O NONO PULSO DO CLOCK
	GOTO	AGUARDA3    ; ACABAR
AGUARDA4
	BTFSC	GPIO,GP0
	GOTO	AGUARDA4
	
	BANK1
	MOVLW	B'00000010' ;AGORA TRANSFORMAR A GP0 EM SAIDA
	MOVWF	TRISIO
	BANK0
	BCF	GPIO,GP0    ;COLOCA O CLOCK EM LOW
	BSF	GPIO,GP5    ;LIGA O LED
	
	MOVLW	.61	    ;E VAI ESPERAR 50MS
	MOVWF	TMR0
LOOP
	BTFSS	INTCON,T0IF ;MANTEM UM LOOP DURANTE 50MS E VERIFICA SE DEU O TEMPO
	GOTO	LOOP
	BCF	INTCON,T0IF
	BCF	GPIO,GP5    ;APOS, O LED � DESLIGADO
	BANK1
	MOVLW	B'00000011' ;O CLOCK � LIBERADO PARA O MASTER NOVAMENTE
	MOVWF	TRISIO
	GOTO	STOP_BIT

STOP_BIT
	 BANK0
	 BTFSS	GPIO,GP1    ; E SER� VERIFICADO SE O STOP BIT ACONTECEU
	 GOTO	STOP_BIT    ; SE O SDA FOI PRA 1 E O CLOCK EST� EM 1
	 BTFSS	GPIO,GP0
	 GOTO	STOP_BIT
	 GOTO	MAIN	    ;E VOLTA PARA O COME�O DO PROGRAMA.

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
