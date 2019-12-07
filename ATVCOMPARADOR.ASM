;   >>>>>>>>>>>>>>>>>> RESISTORES: 1K E 2K2 <<<<<<<<<<<<<<<<
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
	MOVLW	B'00000010' ;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SAÍDAS
	MOVLW	B'00010010'
	MOVWF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000100'
	MOVWF	OPTION_REG	;DEFINE OPÇÕES DE OPERAÇÃO
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OPÇÕES DE INTERRUPÇÕES
	
	
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00000100'
	MOVWF	CMCON		;DEFINE O MODO DE OPERAÇÃO DO COMPARADOR ANALÓGICO
	MOVLW	B'00000000'
	CLRF	GPIO
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZAÇÃO DAS VARIÁVEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN
	; OS RESISTORES UTILIZADOS FORAM: 1K E 2K2.
	; CODIGO USANDO O COMPARADOR QUE IRÁ PEGAR UMA TENSAO NA ENTRADA GP1
	; E COMPARAR COM UMA TENSÃO DE REFERENCIA QUE SERÁ CONSTATEMENTE ALTERADA
	; PARA ENCONTRAR EM QUAL INTERVALO A TENSÃO SE ENCONTRA E MANDAR UMA INDI-
	;CAÇÃO PARA UM LCD.
	
COMP1
	BANK1	; NECESSARIO FAZER A INDICAÇÃO DE QUAIS BANCOS ESTÃO SENDO USADOS
	MOVLW	B'10100010' ; AQUI ESTÁ SENDO ATIVADO E DEFINIDO UMA TENSÃO DE
	MOVWF	VRCON	; REFERENCIA QUE SERÁ COMPARADO COM A GP1.VREF = 0,41V.
	BANK0	; COMO IRÁ USAR UM REGISTRADOR DO BANCO 0, É NECESSARIO INDICAR.
	BTFSC	CMCON,COUT ; ESTÁ SENDO FEITO A VERIFICAÇÃO DO BIT COUT PARA SABER
	GOTO	DISP0 ; O RESULTADO DA COMPARACÃO, E PULAR PARA O CAMINHO INDICADO.

	;SE A COMPARACAO INDICAR QUE O VREF É MAIOR QUE O DA GP1, O CODIGO IRÁ 
	;PARA UMA LABEL QUE SETA O VALOR A SER MOSTRADO NO DISPLAY, SE A GP1
	;FOR MAIOR, O CODIGO CONTINUARÁ, E AS COMPARAÇÕES TAMBEM, ATE UM INTERVALO
	;SER ENCONTRADO E SETAR O DISPLAY.
	
	;É NECESSARIO DEZ COMPARACOES, COMO INDICADO NAS ESPECIFICAÇÕES, ENTÃO
	;AS PROXIMAS LINHAS DO PROGRAMA BASICAMENTE SE REPETEM, ALTERANDO APENAS
	; AS TENSÕES DE REFERENCIA E QUAL VALOR SERA ENVIADO PARA O DISPLAY.
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
; O COMEÇO DO CODIGO PARA NOVAS COMPARAÇÕES.
	
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
