;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICAÇÕES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                    FEVEREIRO DE 2014                            *
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
#INCLUDE <P12F675.INC>	;ARQUIVO PADRÃO MICROCHIP PARA 12F675

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
		DADO		;ARMAZENA O DADO PARA A EEPROM
		MAIOR
		MENOR
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
; INICIALIZAÇÃO DA EEPROM, DE ACORDO COM A DESCRIÇÃO NO ARQUIVO "Def_Rega_Formigas.inc"

;A PARTIR DO ENDEREÇO ZERO DA EEPROM, DADOS EM ORDEM ALEATÓRIA
	
	

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

	SAI_INT
	
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
LE_EEPROM
;LER DADO DA EEPROM, CUJO ENDEREÇO É INDICADO EM W
;DADO LIDO RETORNA EM W
	ANDLW	.127		;LIMITA ENDEREÇO MAX. 127
	BANK1				;ACESSO VIA BANK 1
	MOVWF	EEADR		;INDICA O END. DE LEITURA
	BSF		EECON1,RD	;INICIA O PROCESSO DE LEITURA
	MOVF	EEDATA,W	;COLOCA DADO LIDO EM W
	BANK0				;POSICIONA PARA BANK 0
	RETURN

GRAVA_EEPROM
;ESCREVE DADO (DADO) NA EEPROM, CUJO ENDEREÇO É INDICADO EM W
	ANDLW	.127		;LIMITA ENDEREÇO MAX. 127
	BANK1				;ACESSO VIA BANK 1
	MOVWF	EEADR
	MOVF	DADO,W
	MOVWF	EEDATA
	BSF		EECON1,WREN ;HABILITA ESCRITA
	BCF		INTCON,GIE	;DESLIGA INTERRUPÇÕES
	MOVLW	B'01010101'	;DESBLOQUEIA ESCRITA
	MOVWF	EECON2		;
	MOVLW	B'10101010'	;DESBLOQUEIA ESCRITA
	MOVWF	EECON2		;
	BSF		EECON1,WR ;INICIA A ESCRITA
AGUARDA
	BTFSC	EECON1,WR ;TERMINOU?
	GOTO	AGUARDA
	BSF		INTCON,GIE ;HABILITA INTERRUPÇÕES
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
	MOVWF	TRISIO		;COMO SAÍDAS
	MOVLW	B'00010010'
	MOVWF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000110'
	MOVWF	OPTION_REG	;DEFINE OPÇÕES DE OPERAÇÃO
	MOVLW	B'10000000'
	MOVWF	INTCON		;DEFINE OPÇÕES DE INTERRUPÇÕES
	BANK0				;RETORNA PARA O BANCO
	MOVLW   B'00000101'
	MOVWF	ADCON0
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERAÇÃO DO COMPARADOR ANALÓGICO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZAÇÃO DAS VARIÁVEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN
	

TESTE
	BTFSC	GPIO,GP0 ; A PORTA GP0 TEM QUE MANDAR SINAL LOW COMO É ESPECIFI-
	GOTO	TESTE	 ; CADO, E ESSAS 3 VERIRICAÇÕES SERVEM PARA GARANTIR QUE
TESTE2			 ; QUANDO CONECTADO NO PIC, NÃO COMECE O PROGRAMA E ARMA
	BTFSS	GPIO,GP0 ; ZENE VALORES ALEATORIOS.
	GOTO	TESTE2	 ; POR ISSO O USO DOS BTFSC E BTFSS PARA GARANTIR QUE ESPERE
TESTE3			 ; O APERTO DOS BOTÕES.
	BTFSC	GPIO,GP0
	GOTO	TESTE3
	BSF	ADCON0,GO ; QUANDO APEERTADO, A CONVERSAO SERÁ INICIADA.
CONTINUA
	BTFSC	ADCON0,GO ; SERA SENDO VERIFICADO SE A CONVERSAO A/D JA ACABOU
	GOTO	CONTINUA  ; SE NAO FICA EM LOOP
	MOVLW	.140
	SUBWF	ADRESH,0  ; SERA VERIFICADO SE O VALOR DE ADRESH É MAIOR QUE 140
	BTFSC	STATUS,C  ; SE FOR, IRA PARA O TIMER, SE NAO VOLTARA PRO COMEÇO DO
	GOTO	TIMER	   ; DO PROGRAMA
	GOTO	TESTE
	
TIMER
	
	MOVLW	.106	; SERA COLOCADO NO TIMER UM VALOR PARA QUE FIQUE EM
	MOVWF	TMR0	; LOOP POR 19,2MS FAZENDO A CONVERSÃO
	BSF	ADCON0,GO ;A CONVERSAO É LIGADA
LOOP
	BTFSC	ADCON0,GO ; VERIFICA SE A CONVERSAO ACABOU
	GOTO	LOOP	  ; CASO NÃO, CONTINUA EM LOOP
	MOVLW	.0	  ; NO PRIMEIRO CASO TEMOS QUE COLOCAR O PRIMEIRO VALOR
	SUBWF	MAIOR,0	  ; OBTIDO NO ADRESH NO MAIOR E MENOR, POR ISSO A VERIFI
	BTFSC	STATUS,Z  ;CAÇÃO SE O MAIOR TEM VALOR 0, PARA IR PARA O PRIMEIRO
	GOTO	PRIMCASO  ; CASO
	MOVFW	ADRESH	  ;AGORA VERIFICAREMOS SE OS PROXIMOS VALORES OBTIDOS
	SUBWF	MAIOR,0	  ;SAO MAIORES QUE O GUARDADO EM MAIOR.
	BTFSC	STATUS,C  ;SE NAO FOR, IRÁ PARA OUTRO LABEL
	GOTO	COMPARACAO2
	MOVFW	ADRESH	   ; SE FOR MAIOR SERÁ SUBSTITUIDO O VALOR NA VARIAVEL
	MOVWF	MAIOR
RETORNA
	BSF	ADCON0,GO  ;ATIVAMOS A CONVERSÃO NOVAMENTE
	BTFSS	INTCON,T0IF ; VERIFICAMOS SE O TIMER ESTOROU OU NÃO
	GOTO	LOOP	; SE NÃO, VOLTAMOS PARA O LOOP
	BCF	INTCON,T0IF ; SE ESTOROU, ZERAMOS A FLAG
	MOVFW	MAIOR	; COMEÇAMOS O PROCESSO DE GRAVAÇÃO DOS VALORES OBTIDOS
	MOVWF	DADO	; NAS VARIAVEIS NA EEPROM
	MOVLW	.14	; GRAVANDO PRIMEIRO O MAIOR
	CALL	GRAVA_EEPROM
	CLRF	DADO
	MOVFW	MENOR	; DEPOIS O MENOR NAS RESPECTIVAS POSIÇÕES 
	MOVWF	DADO
	MOVLW	.15
	CALL	GRAVA_EEPROM
	CLRF	DADO
	GOTO	TESTE	; VOLTAMOS PARA O TIMER PARA COMEÇAR UM NOVO PROCESSO.
	
	
	
COMPARACAO2
	
	MOVFW	ADRESH	    ;ESSA COMPARAÇÃO É PARA VER SE O VALOR NA ADRESH É
	SUBWF	MENOR,0	    ; MENOR QUE O MENOR ATUAL
	BTFSS	STATUS,C    ; SE FOR, IRA SER SUBSTITUIDO
	GOTO	RETORNA	    ; SE NÃO FOR, NADA SERÁ FEITO E VOLTARA PARA O FIM DO
	MOVFW	ADRESH	    ; LOOP PARA VOLTAR PARA O COMEÇO
	MOVWF	MENOR
	GOTO	RETORNA

PRIMCASO
	
	MOVFW	ADRESH	; NO PRIMEIRO CASO O VALOR CONTIDO NO ADRESH SERÁ COLOCADO
	MOVWF	MAIOR	; NAS DUAS VARIAVEIS E DEPOIS IREMOS SETAR A CONVERSÃO
	MOVWF	MENOR	; E VOLTAR PARA O LOOP
	BSF	ADCON0,GO
	GOTO	LOOP
	
FIM
	GOTO FIM

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
