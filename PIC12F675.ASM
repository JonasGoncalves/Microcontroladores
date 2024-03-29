;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICA��ES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                    FEVEREIRO DE 2016                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; RESISTORES 1K E 2K2, COM O 2K2 SENDO A REFERENCIA
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

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_ON & _MCLRE_ON & _INTRC_OSC_NOCLKOUT

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
		COUNT1
		COUNT2
		ENDERECO
		AUX
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

BORDA_CLOCK
	
	MOVLW	.0
VOLTA
	MOVWF	AUX
	INCF	AUX,1
	MOVFW	AUX
	SUBLW	.10
	BTFSS	STATUS,Z
	GOTO	VOLTA
	
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
	MOVLW	B'00000111'
	MOVWF	OPTION_REG	;DEFINE OP��ES DE OPERA��O
	MOVLW	B'10000000'
	MOVWF	INTCON		;DEFINE OP��ES DE INTERRUP��ES
	MOVLW	B'10001000' ;VREF = 2,5V
	MOVWF	VRCON	    
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00000100'
	MOVWF	CMCON		;DEFINE O MODO DE OPERA��O DO COMPARADOR ANAL�GICO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZA��O DAS VARI�VEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

MASTER

	MOVLW	.76
	MOVWF	COUNT1
	MOVLW	.47
	MOVWF	ENDERECO
	MOVLW	.0
	MOVWF	COUNT2
	BSF	GPIO,GP5

COMP
	BANK0	; COMO IR� USAR UM REGISTRADOR DO BANCO 0, � NECESSARIO INDICAR.
	BTFSC	CMCON,COUT; EST� SENDO FEITO A VERIFICA��O DO BIT COUT PARA SABER
	BSF	GPIO,GP4    ;SE O LED � ACESO OU N�O, A GP4 � A PORTA DO LED >>ATUADOR<<
	
START
	CLRF	COUNT2
	BCF	GPIO,GP2    ;O MASTER MANDA A START BIT PARA COME�AR O PROTOCOL I2C
	CALL	BORDA_CLOCK ; O TEMPO DE AGUARDO PARA PODER SUBIR O CLOCK
	BSF	GPIO,GP0    ;SOBE O CLOCK
	CALL	BORDA_CLOCK ; ESPERA PARA DESCER O CLOCK
	
	
DESCE
	CALL	BORDA_CLOCK
	BANK0
	BCF	GPIO,GP0    ;DESCE O CLOCK
	

MANDA_DADO
	BANK1
	BCF	STATUS,C    ;SER� FEITO O ENVIO DO ENDERECO UM BIT POR VEZ.
	RRF	ENDERECO,1  ;SER� DESLOCADO OS BITS PARA ENVIAR ZERO OU UM
	BTFSS	STATUS,C    ;ESCOLHE SE � HIGH OU LOW
	GOTO	BIT_LOW
	GOTO	BIT_HIGH

BIT_LOW
	
	BANK0
	BCF	GPIO,GP2    ;BLOCO PARA ENVIAR O BIT COMO ZERO,
	INCF	COUNT2,1    ; RESPEITANDO O NIVEL DO CLOCK E DO SDA
	CALL	BORDA_CLOCK 
	BSF	GPIO,GP0    ; SOBE O CLOCK
	MOVLW	.8
	BANK1
	CLRWDT
	SUBWF	COUNT2,0    ;COMPARA PARA VER SE JA TEVE 8 PULSOS
	BTFSS	STATUS,Z
	GOTO	DESCE	    ; SE TEVE, VAI ESPERAR O ACK, SE N�O, VOLTA PRA OBTER DE NOVO
	GOTO	AGUARDA_ACK
	
BIT_HIGH
	
	BANK0
	BSF	GPIO,GP2    ;MESMO BLOCO QUE O ANTERIOR, MAS COLOCA O BIT EM 1.
	INCF	COUNT2,1
	CALL	BORDA_CLOCK
	BSF	GPIO,GP0
	MOVLW	.8
	BANK1
	CLRWDT
	SUBWF	COUNT2,0
	BTFSS	STATUS,Z
	GOTO	DESCE	
	GOTO	AGUARDA_ACK
	
AGUARDA_ACK
	BANK0		    ;ESSE BLOCO ESPERA A CONFIRMA��O DO ACK VINDO DO SLAVE
	CALL	BORDA_CLOCK ; COLOCANDO O CLOCK PELO 9 PULSO
	BCF	GPIO,GP0
	CALL	BORDA_CLOCK
	BSF	GPIO,GP0
	
	BANK1
	MOVLW	B'00000110' ;LIBERO O SDA PARA O SLAVE ASSUMIR.
	MOVWF	TRISIO
	CLRWDT		    ;LIMPO O WATCHDOG
LOOP
	BANK0
	BTFSC	GPIO,GP2    ;VERIFICO SE O SDA MANDOU ACK
	GOTO	LOOP	    ;SE SIM, CONTINUO, WSE N�O, AGUARDO.
	CLRWDT		    ;LIMPO WDT
	
	BANK1
	MOVLW	B'00000010' ;TOMO O SDA DE VOLTA
	MOVWF	TRISIO
	CALL	BORDA_CLOCK
AQUI
	CLRWDT
	BTFSS	INTCON,T0IF ;FICO PRESO ATE O T0IF ESTOURAR
	GOTO	AQUI
	BCF	INTCON,T0IF
	DECF	COUNT1,1    ;DECREMENTO O CONTADOR
	

	BANK0
	BCF	GPIO,GP0    ;DES�O O CLOCK
	
	BANK1
	MOVLW	.0
	SUBWF	COUNT1,0    ;VERIFICO SE JA CONTOU OS 5S
	BTFSS	STATUS,Z
	GOTO	START	;SE CONTOU, VOU PARA O STOP BIT, SE N�O VOLTOU PARA O START BIT
	GOTO	STOP
	
STOP
	
	CALL	BORDA_CLOCK ;QUANDO CHEGA AQUI JA PASSOU DOS 5S
	BANK0
	BCF	STATUS,T0IF ;LIMPA A FLAG
	BSF	GPIO,GP0    ;FAZ O STOP BIT COLOCANDO O CLOCK EM 1
	CALL	BORDA_CLOCK
	BSF	GPIO,GP2    ;COLOCA O SDA EM 1
	GOTO	SLAVE	    ; VAI PARA O MASTER
		

SLAVE
	BCF	GPIO,GP5
	MOVLW	.0	    ;INICIA O CONTADOR EM 0
	MOVWF	COUNT

START_BIT
	
	BTFSC	GPIO,GP2    ;ESSE BLOCO SE TRATA DA ANALISE DO START SEQUENCE
	GOTO	START_BIT   ; QUE DIR� SE O RECEBIMENTO DE DADO PODE COME�AR
	CLRWDT
	BTFSS	GPIO,GP0    ; VERIFICA SE O SDA EST� INDO PARA 0, E DEPOIS SE
	GOTO	START_BIT   ;SCL EST� EM ALTA, ASSIM PODE COME�AR A TRANSMISS�O

VERIFICA0
	BTFSC	GPIO,GP0    ;DEPOIS DO START BIT, � NECESS�RIO VERIFICAR SE O
	GOTO	VERIFICA0   ;CLOCK FOI PRA BAIXO

SCL
	BANK0
	BTFSS	GPIO,GP0    ;E DEPOIS VERIRIFICAR SE ELE SUBIU PARA RECEBER O
	GOTO	SCL	    ; PRIMEIRO BIT DE DADO
	
	INCF	COUNT,1	    ;O CONTADOR SERA INCREMENTADO A CADA DADO RECEBIDO
	BTFSS	GPIO,GP2    ;AGORA � VERIFICADO SE O DADO � 0 OU 1
	GOTO	BIT_0	    ;SE FOR 0, IR� PRA O TRATAMENTO PARA DEPOSITAR 0
	GOTO	BIT_1	    ;CASO SEJA 1, IRA TRATAR ESTE CASO.

BIT_0
	BANK1
	BCF	STATUS,C    ;QUANDO � ZERO, � PRECISO ZERAR O CARRY, PARA QUE
	RLF	O_DADO,1    ;ESSE SEJA O VALOR COLOCADO PELA INSTRU��O DE DESLOC
AGUARDA			    ;CAMENTO, DE FORMA QUE COLOCA NO LSB E VAI DESLOCANDO
	BANK0
	BTFSC	GPIO,GP0    ;AGUARDA O CLOCK DESCER PARA PODER FAZER A COMPARACAO
	GOTO	AGUARDA	    ;FICA EM LOOP
	CLRWDT
	MOVLW	.8	    ; COMPARA SE JA HOUVE 8 PULSOS DE CLOCK QUE � QUANTI 
	SUBWF	COUNT,0	    ;DADE QUE SE DEVE PARAR PARA ANALISAR O ENDERE�O
	BANK1
	BTFSS	STATUS,Z    ;SE FOI O OITAVO PULSO, SERA FEITO UMA VERIFICA��O
	GOTO	SCL	    ;SE O ENDERE�O DIZ RESPEITO AO MEU SLAVE, SE N�O FOR
	GOTO	SOU_EU	    ;O OITAVO, VOLTA PARA RECEBER O PROXIMO BIT.

BIT_1
	BANK1
	BSF	STATUS,C    ;ESSE BLOCO � IGUAL AO ANTEIROR, TENDO COMO DIFEREN�A
	RLF	O_DADO,1    ;QUE O VALOR COLOCADO NA VARIAVEL � 1 EM VEZ DE ZERO.
AGUARDA2
	BANK0
	BTFSC	GPIO,GP0
	GOTO	AGUARDA2
	CLRWDT
	MOVLW	.8
	SUBWF	COUNT,0
	BANK1
	BTFSS	STATUS,Z
	GOTO	SCL
	GOTO	SOU_EU
	
SOU_EU
	BCF	STATUS,C    ;NESSE BLOCO SER� VERIFICADO SE OS 7 PRIMEIROS BITS
	RRF	O_DADO,0    ;DIZEM RESPEITO AO MEU SLAVE, POR ISSO � DESLOCADO
	SUBLW	.23	    ; UM BIT PRA DIREITA PARA PEGAR APENAS OS 7 PRIMEIROS
	BTFSS	STATUS,Z    ; BITS, SE FOR EU IRA PARA O SINAL ACK, SE N�O, VOLTA
	GOTO	SLAVE	    ;R� PARA O COME�O DO CODIGO
	GOTO	ACK

ACK
	BANK1
	MOVLW	B'00000011' ; SE FOR EU, SERA MANDADO UM SINAL ACK, ENT�O EH NEC
	MOVWF	TRISIO	    ;ESSARIO TORNAR A GP1 SAIDA, E MANDAR O SINAL EM BAIXO
	BCF	GPIO,GP2
AGUARDA3
	BANK0
	BTFSS	GPIO,GP0    ;FAZ DUAS VERIFICA��ES ESPERANDO O NONO PULSO DO CLOCK
	GOTO	AGUARDA3   
AGUARDA4
	BTFSC	GPIO,GP0
	GOTO	AGUARDA4
	
	BANK1
	MOVLW	B'00000111'
	MOVWF	TRISIO
	GOTO	STOP_BIT

STOP_BIT
	 BANK0
	 BTFSS	GPIO,GP2    ; E SER� VERIFICADO SE O STOP BIT ACONTECEU
	 GOTO	STOP_BIT    ; SE O SDA FOI PRA 1 E O CLOCK EST� EM 1
	 CLRWDT
	 BTFSS	GPIO,GP0
	 GOTO	STOP_BIT
	 GOTO	MASTER	    ; O STOP BIT � A DEIXA PARA VOLTAR PARA O MASTER
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
