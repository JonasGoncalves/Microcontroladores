;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICAÇÕES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                    FEVEREIRO DE 2016                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; RESISTORES 1K E 2K2, COM O 2K2 COMO REFERENCIA.
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       NOME DO PROJETO                           *
;*                           CLIENTE                               *
;*         DESENVOLVIDO PELA MOSAICO ENGENHARIA E CONSULTORIA      *
;*   VERSÃO: 1.0                           DATA: 17/06/03          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     DESCRIÇÃO DO ARQUIVO                        *
;*-----------------------------------------------------------------*
;*   MODELO PARA O PIC 16f628a                                      *
;*                                                                 *
;*                                                                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINIÇÕES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <p16f628a.inc>	;ARQUIVO PADRÃO MICROCHIP PARA 12F675

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_ON & _MCLRE_OFF & _INTRC_OSC_NOCLKOUT & _LVP_OFF

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    PAGINAÇÃO DE MEMÓRIA                         *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;DEFINIÇÃO DE COMANDOS DE USUÁRIO PARA ALTERAÇÃO DA PÁGINA DE MEMÓRIA
#DEFINE	BANK0	BCF STATUS,RP0	;SETA BANK 0 DE MEMÓRIA
#DEFINE	BANK1	BSF STATUS,RP0	;SETA BANK 1 DE MAMÓRIA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         VARIÁVEIS                               *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DOS NOMES E ENDEREÇOS DE TODAS AS VARIÁVEIS UTILIZADAS 
; PELO SISTEMA

	CBLOCK	0x20	;ENDEREÇO INICIAL DA MEMÓRIA DE
					;USUÁRIO
		W_TEMP		;REGISTRADORES TEMPORÁRIOS PARA USO
		STATUS_TEMP	;JUNTO ÀS INTERRUPÇÕES
		O_DADO
		COUNT		;NOVAS VARIÁVEIS
		COUNT1
		COUNT2
		ENDERECO
		AUX

	ENDC			;FIM DO BLOCO DE MEMÓRIA
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           ENTRADAS                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS PINOS QUE SERÃO UTILIZADOS COMO ENTRADA
; RECOMENDAMOS TAMBÉM COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           SAÍDAS                                *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS PINOS QUE SERÃO UTILIZADOS COMO SAÍDA
; RECOMENDAMOS TAMBÉM COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       VETOR DE RESET                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	ORG	0x00			;ENDEREÇO INICIAL DE PROCESSAMENTO
	GOTO	INICIO
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    INÍCIO DA INTERRUPÇÃO                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; ENDEREÇO DE DESVIO DAS INTERRUPÇÕES. A PRIMEIRA TAREFA É SALVAR OS
; VALORES DE "W" E "STATUS" PARA RECUPERAÇÃO FUTURA

	ORG	0x04			;ENDEREÇO INICIAL DA INTERRUPÇÃO
	MOVWF	W_TEMP		;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP	;COPIA STATUS PARA STATUS_TEMP

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUPÇÃO                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; AQUI SERÁ ESCRITA AS ROTINAS DE RECONHECIMENTO E TRATAMENTO DAS
; INTERRUPÇÕES

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                 ROTINA DE SAÍDA DA INTERRUPÇÃO                  *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; OS VALORES DE "W" E "STATUS" DEVEM SER RECUPERADOS ANTES DE 
; RETORNAR DA INTERRUPÇÃO

SAI_INT
	SWAPF	STATUS_TEMP,W
	MOVWF	STATUS		;MOVE STATUS_TEMP PARA STATUS
	SWAPF	W_TEMP,F
	SWAPF	W_TEMP,W	;MOVE W_TEMP PARA W
	RETFIE

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*	            	 ROTINAS E SUBROTINAS                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; CADA ROTINA OU SUBROTINA DEVE POSSUIR A DESCRIÇÃO DE FUNCIONAMENTO
; E UM NOME COERENTE ÀS SUAS FUNÇÕES.

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
	BANK1			;ALTERA PARA O BANCO 1
	MOVLW	B'00001000'	;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISA		;COMO SAÍDAS	
	MOVLW	B'00000100'
	MOVWF	TRISB		
	MOVLW	B'00000111'
	MOVWF	OPTION_REG 	;DEFINE OPÇÕES DE OPERAÇÃO	
	MOVLW	B'10000000'
	MOVWF	INTCON	    ;DEFINE OPÇÕES DE INTERRUPÇÕES	
	MOVLW	B'10011000'
	MOVWF	VRCON
	BANK0			;RETORNA PARA O BANCO		
	MOVLW	B'00001010'
	MOVWF	CMCON		;DEFINE O MODO DE OPERAÇÃO DO COMPARADOR ANALÓGICO


;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZAÇÃO DAS VARIÁVEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

BTFSS	STATUS,4
GOTO	MASTER


SLAVE
	BCF	PORTB,RB7
	MOVLW	.0	    ;INICIA O CONTADOR EM 0
	MOVWF	COUNT

START_BIT
	
	BTFSC	PORTA,RB1    ;ESSE BLOCO SE TRATA DA ANALISE DO START SEQUENCE
	GOTO	START_BIT   ; QUE DIRÁ SE O RECEBIMENTO DE DADO PODE COMEÇAR
	CLRWDT
	BTFSS	PORTA,RB0    ; VERIFICA SE O SDA ESTÁ INDO PARA 0, E DEPOIS SE
	GOTO	START_BIT   ;SCL ESTÁ EM ALTA, ASSIM PODE COMEÇAR A TRANSMISSÃO

VERIFICA0
	BTFSC	PORTA,RB0    ;DEPOIS DO START BIT, É NECESSÁRIO VERIFICAR SE O
	GOTO	VERIFICA0   ;CLOCK FOI PRA BAIXO

SCL
	BANK0
	BTFSS	PORTA,RB0    ;E DEPOIS VERIRIFICAR SE ELE SUBIU PARA RECEBER O
	GOTO	SCL	    ; PRIMEIRO BIT DE DADO
	
	INCF	COUNT,1	    ;O CONTADOR SERA INCREMENTADO A CADA DADO RECEBIDO
	BTFSS	PORTA,RB1    ;AGORA É VERIFICADO SE O DADO É 0 OU 1
	GOTO	BIT_0	    ;SE FOR 0, IRÁ PRA O TRATAMENTO PARA DEPOSITAR 0
	GOTO	BIT_1	    ;CASO SEJA 1, IRA TRATAR ESTE CASO.

BIT_0
	BANK1
	BCF	STATUS,C    ;QUANDO É ZERO, É PRECISO ZERAR O CARRY, PARA QUE
	RLF	O_DADO,1    ;ESSE SEJA O VALOR COLOCADO PELA INSTRUÇÃO DE DESLOC
AGUARDA			    ;CAMENTO, DE FORMA QUE COLOCA NO LSB E VAI DESLOCANDO
	BANK0
	BTFSC	PORTA,RB0    ;AGUARDA O CLOCK DESCER PARA PODER FAZER A COMPARACAO
	GOTO	AGUARDA	    ;FICA EM LOOP
	CLRWDT
	MOVLW	.8	    ; COMPARA SE JA HOUVE 8 PULSOS DE CLOCK QUE É QUANTI 
	SUBWF	COUNT,0	    ;DADE QUE SE DEVE PARAR PARA ANALISAR O ENDEREÇO
	BANK1
	BTFSS	STATUS,Z    ;SE FOI O OITAVO PULSO, SERA FEITO UMA VERIFICAÇÃO
	GOTO	SCL	    ;SE O ENDEREÇO DIZ RESPEITO AO MEU SLAVE, SE NÃO FOR
	GOTO	SOU_EU	    ;O OITAVO, VOLTA PARA RECEBER O PROXIMO BIT.

BIT_1
	BANK1
	BSF	STATUS,C    ;ESSE BLOCO É IGUAL AO ANTEIROR, TENDO COMO DIFERENÇA
	RLF	O_DADO,1    ;QUE O VALOR COLOCADO NA VARIAVEL É 1 EM VEZ DE ZERO.
AGUARDA2
	BANK0
	BTFSC	PORTA,RB0
	GOTO	AGUARDA2
	CLRWDT
	MOVLW	.8
	SUBWF	COUNT,0
	BANK1
	BTFSS	STATUS,Z
	GOTO	SCL
	GOTO	SOU_EU
	
SOU_EU
	BCF	STATUS,C    ;NESSE BLOCO SERÁ VERIFICADO SE OS 7 PRIMEIROS BITS
	RRF	O_DADO,0    ;DIZEM RESPEITO AO MEU SLAVE, POR ISSO É DESLOCADO
	SUBLW	.23	    ; UM BIT PRA DIREITA PARA PEGAR APENAS OS 7 PRIMEIROS
	BTFSS	STATUS,Z    ; BITS, SE FOR EU IRA PARA O SINAL ACK, SE NÃO, VOLTA
	GOTO	SLAVE	    ;RÁ PARA O COMEÇO DO CODIGO
	GOTO	ACK

ACK
	BANK1
	MOVLW	B'00000011' ; SE FOR EU, SERA MANDADO UM SINAL ACK, ENTÃO EH NEC
	MOVWF	TRISA	    ;ESSARIO TORNAR A GP1 SAIDA, E MANDAR O SINAL EM BAIXO
	BCF	PORTA,RB1
AGUARDA3
	BANK0
	BTFSS	PORTA,RB0    ;FAZ DUAS VERIFICAÇÕES ESPERANDO O NONO PULSO DO CLOCK
	GOTO	AGUARDA3   
AGUARDA4
	BTFSC	PORTA,RB0
	GOTO	AGUARDA4
	
	BANK1
	MOVLW	B'00000111'
	MOVWF	TRISA
	GOTO	STOP_BIT

STOP_BIT
	 BANK0
	 BTFSS	PORTA,RB1    ; E SERÁ VERIFICADO SE O STOP BIT ACONTECEU
	 GOTO	STOP_BIT    ; SE O SDA FOI PRA 1 E O CLOCK ESTÁ EM 1
	 CLRWDT
	 BTFSS	PORTA,RB0
	 GOTO	STOP_BIT
	 GOTO	MASTER	    ; O STOP BIT É A DEIXA PARA VOLTAR PARA O MASTER
	 
MASTER

	MOVLW	.76
	MOVWF	COUNT1
	MOVLW	.47
	MOVWF	ENDERECO
	MOVLW	.0
	MOVWF	COUNT2
	BSF	PORTB,RB7

COMP
	BANK0	; COMO IRÁ USAR UM REGISTRADOR DO BANCO 0, É NECESSARIO INDICAR.
	BTFSC	CMCON,COUT; ESTÁ SENDO FEITO A VERIFICAÇÃO DO BIT COUT PARA SABER
	BSF	GPIO,GP4    ;SE O LED É ACESO OU NÃO, A GP4 É A PORTA DO LED >>ATUADOR<<
	
START
	CLRF	COUNT2
	BCF	PORTA,RB1    ;O MASTER MANDA A START BIT PARA COMEÇAR O PROTOCOL I2C
	CALL	BORDA_CLOCK ; O TEMPO DE AGUARDO PARA PODER SUBIR O CLOCK
	BSF	PORTA,RB0    ;SOBE O CLOCK
	CALL	BORDA_CLOCK ; ESPERA PARA DESCER O CLOCK
	
	
DESCE
	CALL	BORDA_CLOCK
	BANK0
	BCF	PORTA,RB0    ;DESCE O CLOCK
	

MANDA_DADO
	BANK1
	BCF	STATUS,C    ;SERÁ FEITO O ENVIO DO ENDERECO UM BIT POR VEZ.
	RRF	ENDERECO,1  ;SERÁ DESLOCADO OS BITS PARA ENVIAR ZERO OU UM
	BTFSS	STATUS,C    ;ESCOLHE SE É HIGH OU LOW
	GOTO	BIT_LOW
	GOTO	BIT_HIGH

BIT_LOW
	
	BANK0
	BCF	PORTA,RB1    ;BLOCO PARA ENVIAR O BIT COMO ZERO,
	INCF	COUNT2,1    ; RESPEITANDO O NIVEL DO CLOCK E DO SDA
	CALL	BORDA_CLOCK 
	BSF	PORTA,RB0    ; SOBE O CLOCK
	MOVLW	.8
	BANK1
	CLRWDT
	SUBWF	COUNT2,0    ;COMPARA PARA VER SE JA TEVE 8 PULSOS
	BTFSS	STATUS,Z
	GOTO	DESCE	    ; SE TEVE, VAI ESPERAR O ACK, SE NÃO, VOLTA PRA OBTER DE NOVO
	GOTO	AGUARDA_ACK
	
BIT_HIGH
	
	BANK0
	BSF	PORTA,RB1    ;MESMO BLOCO QUE O ANTERIOR, MAS COLOCA O BIT EM 1.
	INCF	COUNT2,1
	CALL	BORDA_CLOCK
	BSF	PORTA,RB0
	MOVLW	.8
	BANK1
	CLRWDT
	SUBWF	COUNT2,0
	BTFSS	STATUS,Z
	GOTO	DESCE	
	GOTO	AGUARDA_ACK
	
AGUARDA_ACK
	BANK0		    ;ESSE BLOCO ESPERA A CONFIRMAÇÃO DO ACK VINDO DO SLAVE
	CALL	BORDA_CLOCK ; COLOCANDO O CLOCK PELO 9 PULSO
	BCF	PORTA,RB0
	CALL	BORDA_CLOCK
	BSF	PORTA,RB0
	
	BANK1
	MOVLW	B'00000110' ;LIBERO O SDA PARA O SLAVE ASSUMIR.
	MOVWF	TRISA
	CLRWDT		    ;LIMPO O WATCHDOG
LOOP
	BANK0
	BTFSC	PORTA,RB1    ;VERIFICO SE O SDA MANDOU ACK
	GOTO	LOOP	    ;SE SIM, CONTINUO, WSE NÃO, AGUARDO.
	CLRWDT		    ;LIMPO WDT
	
	BANK1
	MOVLW	B'00000010' ;TOMO O SDA DE VOLTA
	MOVWF	TRISA
	CALL	BORDA_CLOCK
AQUI
	CLRWDT
	BTFSS	INTCON,T0IF ;FICO PRESO ATE O T0IF ESTOURAR
	GOTO	AQUI
	BCF	INTCON,T0IF
	DECF	COUNT1,1    ;DECREMENTO O CONTADOR
	

	BANK0
	BCF	PORTA,RB0    ;DESÇO O CLOCK
	
	BANK1
	MOVLW	.0
	SUBWF	COUNT1,0    ;VERIFICO SE JA CONTOU OS 5S
	BTFSS	STATUS,Z
	GOTO	START	;SE CONTOU, VOU PARA O STOP BIT, SE NÃO VOLTOU PARA O START BIT
	GOTO	STOP
	
STOP
	
	CALL	BORDA_CLOCK ;QUANDO CHEGA AQUI JA PASSOU DOS 5S
	BANK0
	BCF	STATUS,T0IF ;LIMPA A FLAG
	BSF	PORTA,RB0    ;FAZ O STOP BIT COLOCANDO O CLOCK EM 1
	CALL	BORDA_CLOCK
	BSF	PORTA,RB1    ;COLOCA O SDA EM 1
	GOTO	SLAVE	    ; VAI PARA O MASTER
		


;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
