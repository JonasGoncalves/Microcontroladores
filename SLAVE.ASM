;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICAÇÕES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                    FEVEREIRO DE 2016                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       NOME DO PROJETO                           *
;*                           CLIENTE                               *
;*         DESENVOLVIDO PELA MOSAICO ENGENHARIA E CONSULTORIA      *
;*   VERSÃO: 1.0                           DATA: 17/06/03          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     DESCRIÇÃO DO ARQUIVO                        *
;*-----------------------------------------------------------------*
;*   MODELO PARA O PIC 12F675                                      *
;*                                                                 *
;*                                                                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINIÇÕES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <p12f675.inc>	;ARQUIVO PADRÃO MICROCHIP PARA 12F675

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_ON & _INTRC_OSC_NOCLKOUT

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
		COUNT
		;NOVAS VARIÁVEIS

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

	;CORPO DA ROTINA

	RETURN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00000011' ;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SAÍDAS
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000111'
	MOVWF	OPTION_REG	;DEFINE OPÇÕES DE OPERAÇÃO
	MOVLW	B'10000000'
	MOVWF	INTCON		;DEFINE OPÇÕES DE INTERRUPÇÕES
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERAÇÃO DO COMPARADOR ANALÓGICO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZAÇÃO DAS VARIÁVEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN
	
	MOVLW	.0  ;INICIA O CONTADOR EM 0
	MOVWF	COUNT

START_BIT
	
	BTFSC	GPIO,GP1    ;ESSE BLOCO SE TRATA DA ANALISE DO START SEQUENCE
	GOTO	START_BIT   ; QUE DIRÁ SE O RECEBIMENTO DE DADO PODE COMEÇAR
	BTFSS	GPIO,GP0    ; VERIFICA SE O SDA ESTÁ INDO PARA 0, E DEPOIS SE
	GOTO	START_BIT   ;SCL ESTÁ EM ALTA, ASSIM PODE COMEÇAR A TRANSMISSÃO

VERIFICA0
	BTFSC	GPIO,GP0    ;DEPOIS DO START BIT, É NECESSÁRIO VERIFICAR SE O
	GOTO	VERIFICA0   ;CLOCK FOI PRA BAIXO

SCL
	BTFSS	GPIO,GP0    ;E DEPOIS VERIRIFICAR SE ELE SUBIU PARA RECEBER O
	GOTO	SCL	    ; PRIMEIRO BIT DE DADO
	
	INCF	COUNT,1	    ;O CONTADOR SERA INCREMENTADO A CADA DADO RECEBIDO
	BTFSS	GPIO,GP1    ;AGORA É VERIFICADO SE O DADO É 0 OU 1
	GOTO	BIT_0	    ;SE FOR 0, IRÁ PRA O TRATAMENTO PARA DEPOSITAR 0
	GOTO	BIT_1	    ;CASO SEJA 1, IRA TRATAR ESTE CASO.

BIT_0
	BCF	STATUS,C    ;QUANDO É ZERO, É PRECISO ZERAR O CARRY, PARA QUE
	RLF	O_DADO,1    ;ESSE SEJA O VALOR COLOCADO PELA INSTRUÇÃO DE DESLOC
AGUARDA			    ;CAMENTO, DE FORMA QUE COLOCA NO LSB E VAI DESLOCANDO
	BTFSC	GPIO,GP0    ;AGUARDA O CLOCK DESCER PARA PODER FAZER A COMPARACAO
	GOTO	AGUARDA	    ;FICA EM LOOP
	MOVLW	.8	    ; COMPARA SE JA HOUVE 8 PULSOS DE CLOCK QUE É QUANTI 
	SUBWF	COUNT,0	    ;DADE QUE SE DEVE PARAR PARA ANALISAR O ENDEREÇO
	BTFSS	STATUS,Z    ;SE FOI O OITAVO PULSO, SERA FEITO UMA VERIFICAÇÃO
	GOTO	SCL	    ;SE O ENDEREÇO DIZ RESPEITO AO MEU SLAVE, SE NÃO FOR
	GOTO	SOU_EU	    ;O OITAVO, VOLTA PARA RECEBER O PROXIMO BIT.

BIT_1
	BSF	STATUS,C    ;ESSE BLOCO É IGUAL AO ANTEIROR, TENDO COMO DIFERENÇA
	RLF	O_DADO,1    ;QUE O VALOR COLOCADO NA VARIAVEL É 1 EM VEZ DE ZERO.
AGUARDA2
	BTFSC	GPIO,GP0
	GOTO	AGUARDA2
	MOVLW	.8
	SUBWF	COUNT,0
	BTFSS	STATUS,Z
	GOTO	SCL
	GOTO	SOU_EU
	
SOU_EU
	BCF	STATUS,C    ;NESSE BLOCO SERÁ VERIFICADO SE OS 7 PRIMEIROS BITS
	RRF	O_DADO,0    ;DIZEM RESPEITO AO MEU SLAVE, POR ISSO É DESLOCADO
	SUBLW	.23	    ; UM BIT PRA DIREITA PARA PEGAR APENAS OS 7 PRIMEIROS
	BTFSS	STATUS,Z    ; BITS, SE FOR EU IRA PARA O SINAL ACK, SE NÃO, VOLTA
	GOTO	MAIN	    ;RÁ PARA O COMEÇO DO CODIGO
	GOTO	ACK

ACK
	BANK1
	MOVLW	B'00000001' ; SE FOR EU, SERA MANDADO UM SINAL ACK, ENTÃO EH NEC
	MOVWF	TRISIO	    ;ESSARIO TORNAR A GP1 SAIDA, E MANDAR O SINAL EM BAIXO
	BCF	GPIO,GP1
AGUARDA3
	BANK0
	BTFSS	GPIO,GP0    ;FAZ DUAS VERIFICAÇÕES ESPERANDO O NONO PULSO DO CLOCK
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
	BCF	GPIO,GP5    ;APOS, O LED É DESLIGADO
	BANK1
	MOVLW	B'00000011' ;O CLOCK É LIBERADO PARA O MASTER NOVAMENTE
	MOVWF	TRISIO
	GOTO	STOP_BIT

STOP_BIT
	 BANK0
	 BTFSS	GPIO,GP1    ; E SERÁ VERIFICADO SE O STOP BIT ACONTECEU
	 GOTO	STOP_BIT    ; SE O SDA FOI PRA 1 E O CLOCK ESTÁ EM 1
	 BTFSS	GPIO,GP0
	 GOTO	STOP_BIT
	 GOTO	MAIN	    ;E VOLTA PARA O COMEÇO DO PROGRAMA.

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
