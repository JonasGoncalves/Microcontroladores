;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICA��ES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                    FEVEREIRO DE 2014                            *
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
#INCLUDE <P12F675.INC>	;ARQUIVO PADR�O MICROCHIP PARA 12F675

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
		DADO		;ARMAZENA O DADO PARA A EEPROM
		MAIOR
		MENOR
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
; INICIALIZA��O DA EEPROM, DE ACORDO COM A DESCRI��O NO ARQUIVO "Def_Rega_Formigas.inc"

;A PARTIR DO ENDERE�O ZERO DA EEPROM, DADOS EM ORDEM ALEAT�RIA
	
	

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

	SAI_INT
	
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
LE_EEPROM
;LER DADO DA EEPROM, CUJO ENDERE�O � INDICADO EM W
;DADO LIDO RETORNA EM W
	ANDLW	.127		;LIMITA ENDERE�O MAX. 127
	BANK1				;ACESSO VIA BANK 1
	MOVWF	EEADR		;INDICA O END. DE LEITURA
	BSF		EECON1,RD	;INICIA O PROCESSO DE LEITURA
	MOVF	EEDATA,W	;COLOCA DADO LIDO EM W
	BANK0				;POSICIONA PARA BANK 0
	RETURN

GRAVA_EEPROM
;ESCREVE DADO (DADO) NA EEPROM, CUJO ENDERE�O � INDICADO EM W
	ANDLW	.127		;LIMITA ENDERE�O MAX. 127
	BANK1				;ACESSO VIA BANK 1
	MOVWF	EEADR
	MOVF	DADO,W
	MOVWF	EEDATA
	BSF		EECON1,WREN ;HABILITA ESCRITA
	BCF		INTCON,GIE	;DESLIGA INTERRUP��ES
	MOVLW	B'01010101'	;DESBLOQUEIA ESCRITA
	MOVWF	EECON2		;
	MOVLW	B'10101010'	;DESBLOQUEIA ESCRITA
	MOVWF	EECON2		;
	BSF		EECON1,WR ;INICIA A ESCRITA
AGUARDA
	BTFSC	EECON1,WR ;TERMINOU?
	GOTO	AGUARDA
	BSF		INTCON,GIE ;HABILITA INTERRUP��ES
	BANK0				;POSICIONA PARA BANK 0
	RETURN

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
	MOVLW	B'00010010'
	MOVWF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000110'
	MOVWF	OPTION_REG	;DEFINE OP��ES DE OPERA��O
	MOVLW	B'10000000'
	MOVWF	INTCON		;DEFINE OP��ES DE INTERRUP��ES
	BANK0				;RETORNA PARA O BANCO
	MOVLW   B'00000101'
	MOVWF	ADCON0
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERA��O DO COMPARADOR ANAL�GICO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZA��O DAS VARI�VEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN
	

TESTE
	BTFSC	GPIO,GP0 ; A PORTA GP0 TEM QUE MANDAR SINAL LOW COMO � ESPECIFI-
	GOTO	TESTE	 ; CADO, E ESSAS 3 VERIRICA��ES SERVEM PARA GARANTIR QUE
TESTE2			 ; QUANDO CONECTADO NO PIC, N�O COMECE O PROGRAMA E ARMA
	BTFSS	GPIO,GP0 ; ZENE VALORES ALEATORIOS.
	GOTO	TESTE2	 ; POR ISSO O USO DOS BTFSC E BTFSS PARA GARANTIR QUE ESPERE
TESTE3			 ; O APERTO DOS BOT�ES.
	BTFSC	GPIO,GP0
	GOTO	TESTE3
	BSF	ADCON0,GO ; QUANDO APEERTADO, A CONVERSAO SER� INICIADA.
CONTINUA
	BTFSC	ADCON0,GO ; SERA SENDO VERIFICADO SE A CONVERSAO A/D JA ACABOU
	GOTO	CONTINUA  ; SE NAO FICA EM LOOP
	MOVLW	.140
	SUBWF	ADRESH,0  ; SERA VERIFICADO SE O VALOR DE ADRESH � MAIOR QUE 140
	BTFSC	STATUS,C  ; SE FOR, IRA PARA O TIMER, SE NAO VOLTARA PRO COME�O DO
	GOTO	TIMER	   ; DO PROGRAMA
	GOTO	TESTE
	
TIMER
	
	MOVLW	.106	; SERA COLOCADO NO TIMER UM VALOR PARA QUE FIQUE EM
	MOVWF	TMR0	; LOOP POR 19,2MS FAZENDO A CONVERS�O
	BSF	ADCON0,GO ;A CONVERSAO � LIGADA
LOOP
	BTFSC	ADCON0,GO ; VERIFICA SE A CONVERSAO ACABOU
	GOTO	LOOP	  ; CASO N�O, CONTINUA EM LOOP
	MOVLW	.0	  ; NO PRIMEIRO CASO TEMOS QUE COLOCAR O PRIMEIRO VALOR
	SUBWF	MAIOR,0	  ; OBTIDO NO ADRESH NO MAIOR E MENOR, POR ISSO A VERIFI
	BTFSC	STATUS,Z  ;CA��O SE O MAIOR TEM VALOR 0, PARA IR PARA O PRIMEIRO
	GOTO	PRIMCASO  ; CASO
	MOVFW	ADRESH	  ;AGORA VERIFICAREMOS SE OS PROXIMOS VALORES OBTIDOS
	SUBWF	MAIOR,0	  ;SAO MAIORES QUE O GUARDADO EM MAIOR.
	BTFSC	STATUS,C  ;SE NAO FOR, IR� PARA OUTRO LABEL
	GOTO	COMPARACAO2
	MOVFW	ADRESH	   ; SE FOR MAIOR SER� SUBSTITUIDO O VALOR NA VARIAVEL
	MOVWF	MAIOR
RETORNA
	BSF	ADCON0,GO  ;ATIVAMOS A CONVERS�O NOVAMENTE
	BTFSS	INTCON,T0IF ; VERIFICAMOS SE O TIMER ESTOROU OU N�O
	GOTO	LOOP	; SE N�O, VOLTAMOS PARA O LOOP
	BCF	INTCON,T0IF ; SE ESTOROU, ZERAMOS A FLAG
	MOVFW	MAIOR	; COME�AMOS O PROCESSO DE GRAVA��O DOS VALORES OBTIDOS
	MOVWF	DADO	; NAS VARIAVEIS NA EEPROM
	MOVLW	.14	; GRAVANDO PRIMEIRO O MAIOR
	CALL	GRAVA_EEPROM
	CLRF	DADO
	MOVFW	MENOR	; DEPOIS O MENOR NAS RESPECTIVAS POSI��ES 
	MOVWF	DADO
	MOVLW	.15
	CALL	GRAVA_EEPROM
	CLRF	DADO
	GOTO	TESTE	; VOLTAMOS PARA O TIMER PARA COME�AR UM NOVO PROCESSO.
	
	
	
COMPARACAO2
	
	MOVFW	ADRESH	    ;ESSA COMPARA��O � PARA VER SE O VALOR NA ADRESH �
	SUBWF	MENOR,0	    ; MENOR QUE O MENOR ATUAL
	BTFSS	STATUS,C    ; SE FOR, IRA SER SUBSTITUIDO
	GOTO	RETORNA	    ; SE N�O FOR, NADA SER� FEITO E VOLTARA PARA O FIM DO
	MOVFW	ADRESH	    ; LOOP PARA VOLTAR PARA O COME�O
	MOVWF	MENOR
	GOTO	RETORNA

PRIMCASO
	
	MOVFW	ADRESH	; NO PRIMEIRO CASO O VALOR CONTIDO NO ADRESH SER� COLOCADO
	MOVWF	MAIOR	; NAS DUAS VARIAVEIS E DEPOIS IREMOS SETAR A CONVERS�O
	MOVWF	MENOR	; E VOLTAR PARA O LOOP
	BSF	ADCON0,GO
	GOTO	LOOP
	
FIM
	GOTO FIM

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
